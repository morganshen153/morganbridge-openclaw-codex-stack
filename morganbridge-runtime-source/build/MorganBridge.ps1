# Copyright 2026 morganshen153
# SPDX-License-Identifier: Apache-2.0

param()

$ErrorActionPreference = "Stop"

function Get-BridgeValue {
  param(
    [Parameter(Mandatory = $true)]$Object,
    [Parameter(Mandatory = $true)][string]$Name,
    $Default = $null
  )

  if ($null -eq $Object) {
    return $Default
  }
  $property = $Object.PSObject.Properties[$Name]
  if ($null -eq $property) {
    return $Default
  }
  if ($null -eq $property.Value) {
    return $Default
  }
  return $property.Value
}

function Write-BridgeResponse {
  param(
    [Parameter(Mandatory = $true)][hashtable]$Payload,
    [int]$ExitCode = 0
  )

  $responsePath = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_RESPONSE_FILE", "Process")
  if ([string]::IsNullOrWhiteSpace($responsePath)) {
    throw "MORGAN_BRIDGE_RESPONSE_FILE is not set."
  }
  $json = $Payload | ConvertTo-Json -Depth 8
  [System.IO.File]::WriteAllText($responsePath, $json, [System.Text.UTF8Encoding]::new($false))
  exit $ExitCode
}

function Write-BridgeLog {
  param([string]$Message)
  $logPath = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_LOG_FILE", "Process")
  if ([string]::IsNullOrWhiteSpace($logPath)) {
    return
  }
  $line = "[{0}] {1}`r`n" -f ([DateTimeOffset]::Now.ToString("o")), $Message
  Add-Content -Path $logPath -Value $line -Encoding UTF8
}

function Invoke-CmdCapture {
  param(
    [Parameter(Mandatory = $true)][string]$CommandLine,
    [string]$WorkingDirectory
  )

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $env:ComSpec
  $psi.Arguments = "/d /c $CommandLine"
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.UseShellExecute = $false
  $psi.CreateNoWindow = $true
  if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
    $psi.WorkingDirectory = $WorkingDirectory
  }

  $proc = New-Object System.Diagnostics.Process
  $proc.StartInfo = $psi
  [void]$proc.Start()
  $stdout = $proc.StandardOutput.ReadToEnd()
  $stderr = $proc.StandardError.ReadToEnd()
  $proc.WaitForExit()
  return @{
    ExitCode = $proc.ExitCode
    StdOut = $stdout
    StdErr = $stderr
  }
}

function Invoke-MorganHubGuidance {
  param(
    [Parameter(Mandatory = $true)][hashtable]$Payload
  )

  $hubBaseUrl = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_HUB_BASE_URL", "Process")
  if ([string]::IsNullOrWhiteSpace($hubBaseUrl)) {
    $hubBaseUrl = "http://127.0.0.1:8010/api/v1"
  }
  $hubBaseUrl = $hubBaseUrl.TrimEnd("/")
  $uri = "$hubBaseUrl/platform/bridge/codex-context"
  $message = [string](Get-BridgeValue -Object $Payload -Name "message" -Default "")
  $runId = [string](Get-BridgeValue -Object $Payload -Name "run_id" -Default "")
  $body = @{
    instruction   = $message
    run_id        = $runId
    round         = $Payload.round
    thread_id     = $Payload.thread_id
    cwd           = $Payload.cwd
    task_type     = $Payload.task_type
    prior_summary = $Payload.prior_summary
  } | ConvertTo-Json -Depth 6

  try {
    return Invoke-RestMethod -Method Post -Uri $uri -ContentType "application/json; charset=utf-8" -Body $body -TimeoutSec 20
  } catch {
    Write-BridgeLog ("MorganHub guidance failed: " + $_.Exception.Message)
    return $null
  }
}

function Build-BridgePrompt {
  param(
    [Parameter(Mandatory = $true)][hashtable]$Payload,
    $Guidance,
    [string]$SkillPath
  )

  $parts = @()
  if (-not [string]::IsNullOrWhiteSpace($SkillPath) -and (Test-Path $SkillPath)) {
    $parts += (Get-Content -Path $SkillPath -Raw -Encoding UTF8)
  }
  if ($Guidance) {
    if ($Guidance.guidance_summary) {
      $parts += "Morgan Bridge guidance summary:`n$($Guidance.guidance_summary)"
    }
    if ($Guidance.bridge_confidence) {
      $parts += "Bridge confidence: $($Guidance.bridge_confidence)"
    }
    if ($Guidance.approval_hint) {
      $parts += "Approval hint: $($Guidance.approval_hint)"
    }
    if ($Guidance.constraints) {
      $parts += "Constraints:`n- " + (($Guidance.constraints -join "`n- "))
    }
    if ($Guidance.suggested_skills) {
      $parts += "Suggested skills: " + ($Guidance.suggested_skills -join ", ")
    }
  }
  $message = if ($Payload.ContainsKey("message") -and $null -ne $Payload.message) { [string]$Payload.message } else { "" }
  $parts += "Original OpenClaw task:`n$message"
  $priorSummary = [string](Get-BridgeValue -Object $Payload -Name "prior_summary" -Default "")
  if (-not [string]::IsNullOrWhiteSpace($priorSummary)) {
    $parts += "Prior summary:`n$priorSummary"
  }
  return ($parts -join "`n`n").Trim()
}

function Resolve-SessionName {
  param([hashtable]$Payload)
  if (-not [string]::IsNullOrWhiteSpace([string]$Payload.session_name)) {
    return [string]$Payload.session_name
  }
  if (-not [string]::IsNullOrWhiteSpace([string]$Payload.thread_id)) {
    return "ocbridge-" + ([string]$Payload.thread_id)
  }
  if (-not [string]::IsNullOrWhiteSpace([string]$Payload.run_id)) {
    return "ocbridge-" + ([string]$Payload.run_id)
  }
  return "ocbridge-" + [DateTimeOffset]::UtcNow.ToString("yyyyMMddHHmmss")
}

try {
  $mode = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_MODE", "Process")
  if ([string]::IsNullOrWhiteSpace($mode)) {
    $mode = "handoff"
  }

  $payloadFile = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_PAYLOAD_FILE", "Process")
  $payload = @{}
  if (-not [string]::IsNullOrWhiteSpace($payloadFile) -and (Test-Path $payloadFile)) {
    $payload = Get-Content -Path $payloadFile -Raw -Encoding UTF8 | ConvertFrom-Json
  }

  $acpxCmd = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_ACPX_CMD", "Process")
  if ([string]::IsNullOrWhiteSpace($acpxCmd)) {
    $acpxCmd = "acpx"
  }
  $defaultCwd = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_DEFAULT_CWD", "Process")
  if ([string]::IsNullOrWhiteSpace($defaultCwd)) {
    $defaultCwd = (Get-Location).Path
  }
  $payloadCwd = [string](Get-BridgeValue -Object $payload -Name "cwd" -Default "")
  $cwd = if (-not [string]::IsNullOrWhiteSpace($payloadCwd)) { $payloadCwd } else { $defaultCwd }

  if ($mode -eq "doctor") {
    $cfg = Invoke-CmdCapture -CommandLine ('"{0}" config show' -f $acpxCmd) -WorkingDirectory $cwd
    $hubHealth = $null
    try {
      $hubBaseUrl = [Environment]::GetEnvironmentVariable("MORGAN_BRIDGE_HUB_BASE_URL", "Process")
      if ([string]::IsNullOrWhiteSpace($hubBaseUrl)) {
        $hubBaseUrl = "http://127.0.0.1:8010/api/v1"
      }
      $hubHealth = Invoke-RestMethod -Method Get -Uri ($hubBaseUrl.TrimEnd("/") + "/health") -TimeoutSec 10
    } catch {
      $hubHealth = @{ ok = $false; error = $_.Exception.Message }
    }
    Write-BridgeResponse -Payload @{
      ok = ($cfg.ExitCode -eq 0)
      mode = "doctor"
      acpx_exit_code = $cfg.ExitCode
      acpx_stdout = $cfg.StdOut.Trim()
      acpx_stderr = $cfg.StdErr.Trim()
      hub_health = $hubHealth
    }
  }

  $guidance = Invoke-MorganHubGuidance -Payload $payload
  $sessionName = Resolve-SessionName -Payload $payload
  $skillPath = Join-Path -Path $PSScriptRoot -ChildPath "morganbridge-receiver-skill.md"
  $prompt = Build-BridgePrompt -Payload $payload -Guidance $guidance -SkillPath $skillPath

  $ensure = Invoke-CmdCapture -CommandLine ('"{0}" codex sessions ensure --name "{1}"' -f $acpxCmd, $sessionName) -WorkingDirectory $cwd
  if ($ensure.ExitCode -ne 0) {
    Write-BridgeResponse -Payload @{
      ok = $false
      mode = "handoff"
      error = "acpx session ensure failed"
      ensure_stdout = $ensure.StdOut.Trim()
      ensure_stderr = $ensure.StdErr.Trim()
    } -ExitCode 1
  }

  $promptFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("morgan-bridge-prompt-" + [guid]::NewGuid().ToString("N") + ".txt")
  [System.IO.File]::WriteAllText($promptFile, $prompt, [System.Text.UTF8Encoding]::new($false))
  try {
    $invoke = Invoke-CmdCapture -CommandLine ('"{0}" --cwd "{1}" --format text codex -s "{2}" -f "{3}"' -f $acpxCmd, $cwd, $sessionName, $promptFile) -WorkingDirectory $cwd
  } finally {
    Remove-Item -Path $promptFile -Force -ErrorAction SilentlyContinue
  }

  if ($invoke.ExitCode -ne 0) {
    Write-BridgeResponse -Payload @{
      ok = $false
      mode = "handoff"
      error = "acpx prompt failed"
      session_name = $sessionName
      prompt_stdout = $invoke.StdOut.Trim()
      prompt_stderr = $invoke.StdErr.Trim()
      guidance = $guidance
    } -ExitCode 1
  }

  $outputText = ($invoke.StdOut -replace '\[done\].*$', '' -replace '\[acpx\].*$', '').Trim()
  Write-BridgeResponse -Payload @{
    ok = $true
    mode = "handoff"
    session_name = $sessionName
    cwd = $cwd
    acpx_cmd = $acpxCmd
    guidance = $guidance
    output_text = $outputText
    ensure_stdout = $ensure.StdOut.Trim()
    ensure_stderr = $ensure.StdErr.Trim()
    prompt_stdout = $invoke.StdOut.Trim()
    prompt_stderr = $invoke.StdErr.Trim()
  }
} catch {
  Write-BridgeLog ("Unhandled error: " + $_.Exception.Message)
  Write-BridgeResponse -Payload @{
    ok = $false
    mode = "handoff"
    error = $_.Exception.Message
  } -ExitCode 1
}
