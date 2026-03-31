"""MorganBridge runtime source."""

# Copyright 2026 morganshen153
# SPDX-License-Identifier: Apache-2.0

import json
import os
import re
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path


EMBEDDED_SKILL = """---
name: morganbridge-receiver-skill
description: Continue work handed from OpenClaw through MorganBridge. Use when a task arrives from OpenClaw and Codex should keep the task aligned, checkpointed, and concise across multiple rounds without implying official affiliation.
---

# morganbridge-receiver-skill

## Required behavior

- Continue from the handed task instead of reframing it.
- Respect Morgan Bridge guidance, approval hints, constraints, and suggested skills.
- Stay local-only when OpenClaw-side execution is not guaranteed.
- Prefer short execution updates over long explanations.
- If blocked, ask for one narrow checkpoint instead of a broad clarification.
- Treat OpenClaw and Codex as external products and do not imply official affiliation.
"""


def env(name: str, default: str = "") -> str:
    value = os.environ.get(name, "")
    return value if value.strip() else default


def write_log(message: str) -> None:
    log_path = env("MORGAN_BRIDGE_LOG_FILE")
    if not log_path:
        return
    line = f"[{datetime.now().astimezone().isoformat()}] {message}\r\n"
    Path(log_path).parent.mkdir(parents=True, exist_ok=True)
    with open(log_path, "a", encoding="utf-8") as handle:
        handle.write(line)


def write_response(payload: dict, exit_code: int = 0) -> None:
    response_path = env("MORGAN_BRIDGE_RESPONSE_FILE")
    if not response_path:
        raise RuntimeError("MORGAN_BRIDGE_RESPONSE_FILE is not set.")
    Path(response_path).parent.mkdir(parents=True, exist_ok=True)
    with open(response_path, "w", encoding="utf-8", newline="") as handle:
        json.dump(payload, handle, ensure_ascii=False, indent=2)
    raise SystemExit(exit_code)


def load_payload() -> dict:
    payload_path = env("MORGAN_BRIDGE_PAYLOAD_FILE")
    if not payload_path:
        return {}
    payload_file = Path(payload_path)
    if not payload_file.exists():
        return {}
    with open(payload_file, "r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise RuntimeError("Bridge payload must be a JSON object.")
    return data


def quote_cmd(args: list[str]) -> str:
    return subprocess.list2cmdline(args)


def run_cmd(args: list[str], cwd: str | None = None) -> dict:
    cmdline = quote_cmd(args)
    proc = subprocess.run(
        ["cmd.exe", "/d", "/c", cmdline],
        cwd=cwd or None,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    return {
        "exit_code": proc.returncode,
        "stdout": proc.stdout.strip(),
        "stderr": proc.stderr.strip(),
        "command_line": cmdline,
    }


def post_json(url: str, body: dict, timeout: int = 20) -> dict | None:
    raw = json.dumps(body, ensure_ascii=False).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=raw,
        headers={"Content-Type": "application/json; charset=utf-8"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            text = response.read().decode("utf-8", errors="replace")
        if not text.strip():
            return None
        data = json.loads(text)
        return data if isinstance(data, dict) else {"raw": data}
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        write_log(f"MorganHub guidance HTTP {exc.code}: {detail}")
        return None
    except Exception as exc:  # noqa: BLE001
        write_log(f"MorganHub guidance failed: {exc}")
        return None


def get_json(url: str, timeout: int = 10) -> dict | None:
    try:
        with urllib.request.urlopen(url, timeout=timeout) as response:
            text = response.read().decode("utf-8", errors="replace")
        if not text.strip():
            return None
        data = json.loads(text)
        return data if isinstance(data, dict) else {"raw": data}
    except Exception as exc:  # noqa: BLE001
        write_log(f"MorganHub GET failed: {exc}")
        return None


def guidance_request(payload: dict) -> dict:
    return {
        "instruction": str(payload.get("message") or ""),
        "run_id": payload.get("run_id"),
        "round": payload.get("round"),
        "thread_id": payload.get("thread_id"),
        "cwd": payload.get("cwd"),
        "task_type": payload.get("task_type"),
        "prior_summary": payload.get("prior_summary"),
    }


def resolve_cwd(payload: dict) -> str:
    default_cwd = env("MORGAN_BRIDGE_DEFAULT_CWD", str(Path.cwd()))
    payload_cwd = str(payload.get("cwd") or "").strip()
    cwd = payload_cwd or default_cwd
    if not Path(cwd).exists():
        write_log(f"Requested cwd does not exist, falling back: {cwd}")
        return default_cwd
    return cwd


def resolve_session_name(payload: dict) -> str:
    session_name = str(payload.get("session_name") or "").strip()
    if session_name:
        return session_name
    thread_id = str(payload.get("thread_id") or "").strip()
    if thread_id:
        return f"ocbridge-{thread_id}"
    run_id = str(payload.get("run_id") or "").strip()
    if run_id:
        return f"ocbridge-{run_id}"
    return "ocbridge-" + datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S")


def build_prompt(payload: dict, guidance: dict | None) -> str:
    parts: list[str] = [EMBEDDED_SKILL.strip()]
    if guidance:
        guidance_summary = str(guidance.get("guidance_summary") or "").strip()
        if guidance_summary:
            parts.append("Morgan Bridge guidance summary:\n" + guidance_summary)
        bridge_confidence = str(guidance.get("bridge_confidence") or "").strip()
        if bridge_confidence:
            parts.append("Bridge confidence: " + bridge_confidence)
        approval_hint = str(guidance.get("approval_hint") or "").strip()
        if approval_hint:
            parts.append("Approval hint: " + approval_hint)
        constraints = guidance.get("constraints") or []
        if isinstance(constraints, list) and constraints:
            parts.append("Constraints:\n- " + "\n- ".join(str(item) for item in constraints))
        suggested_skills = guidance.get("suggested_skills") or []
        if isinstance(suggested_skills, list) and suggested_skills:
            parts.append("Suggested skills: " + ", ".join(str(item) for item in suggested_skills))
    message = str(payload.get("message") or "").strip()
    parts.append("Original OpenClaw task:\n" + message)
    prior_summary = str(payload.get("prior_summary") or "").strip()
    if prior_summary:
        parts.append("Prior summary:\n" + prior_summary)
    return "\n\n".join(part for part in parts if part.strip()).strip()


def strip_acpx_noise(stdout: str) -> str:
    lines = []
    for raw_line in stdout.splitlines():
        line = raw_line.strip()
        if not line:
            continue
        if line.startswith("[done]"):
            continue
        if line.startswith("[acpx]"):
            continue
        if line.startswith("[client]"):
            continue
        if line == "[error] RUNTIME: Resource not found":
            continue
        lines.append(raw_line.rstrip())
    return "\n".join(lines).strip()


def ensure_session(acpx_cmd: str, cwd: str, session_name: str) -> dict:
    return run_cmd(
        [acpx_cmd, "--cwd", cwd, "codex", "sessions", "ensure", "--name", session_name],
        cwd=cwd,
    )


def prompt_session(acpx_cmd: str, cwd: str, session_name: str, prompt_text: str) -> dict:
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", newline="", suffix=".txt", delete=False
    ) as handle:
        handle.write(prompt_text)
        prompt_path = handle.name
    try:
        return run_cmd(
            [acpx_cmd, "--cwd", cwd, "--format", "text", "codex", "-s", session_name, "-f", prompt_path],
            cwd=cwd,
        )
    finally:
        try:
            os.remove(prompt_path)
        except OSError:
            pass


def doctor(acpx_cmd: str, cwd: str, hub_base_url: str) -> None:
    acpx_info = run_cmd([acpx_cmd, "config", "show"], cwd=cwd)
    hub_health = get_json(hub_base_url.rstrip("/") + "/health") or {"ok": False}
    write_response(
        {
            "ok": acpx_info["exit_code"] == 0,
            "mode": "doctor",
            "acpx_exit_code": acpx_info["exit_code"],
            "acpx_stdout": acpx_info["stdout"],
            "acpx_stderr": acpx_info["stderr"],
            "hub_health": hub_health,
        }
    )


def handoff(payload: dict, acpx_cmd: str, cwd: str, hub_base_url: str) -> None:
    guidance = post_json(
        hub_base_url.rstrip("/") + "/platform/bridge/codex-context",
        guidance_request(payload),
        timeout=20,
    )
    session_name = resolve_session_name(payload)
    prompt_text = build_prompt(payload, guidance)

    ensure = ensure_session(acpx_cmd, cwd, session_name)
    if ensure["exit_code"] != 0:
        write_response(
            {
                "ok": False,
                "mode": "handoff",
                "error": "acpx session ensure failed",
                "session_name": session_name,
                "ensure_stdout": ensure["stdout"],
                "ensure_stderr": ensure["stderr"],
                "guidance": guidance,
            },
            exit_code=1,
        )

    invoke = prompt_session(acpx_cmd, cwd, session_name, prompt_text)
    if invoke["exit_code"] != 0:
        write_response(
            {
                "ok": False,
                "mode": "handoff",
                "error": "acpx prompt failed",
                "session_name": session_name,
                "prompt_stdout": invoke["stdout"],
                "prompt_stderr": invoke["stderr"],
                "guidance": guidance,
            },
            exit_code=1,
        )

    write_response(
        {
            "ok": True,
            "mode": "handoff",
            "session_name": session_name,
            "cwd": cwd,
            "acpx_cmd": acpx_cmd,
            "guidance": guidance,
            "output_text": strip_acpx_noise(invoke["stdout"]),
            "ensure_stdout": ensure["stdout"],
            "ensure_stderr": ensure["stderr"],
            "prompt_stdout": invoke["stdout"],
            "prompt_stderr": invoke["stderr"],
        }
    )


def main() -> None:
    mode = env("MORGAN_BRIDGE_MODE", "handoff")
    acpx_cmd = env("MORGAN_BRIDGE_ACPX_CMD", "acpx")
    hub_base_url = env("MORGAN_BRIDGE_HUB_BASE_URL", "http://127.0.0.1:8010/api/v1")
    payload = load_payload()
    cwd = resolve_cwd(payload)

    if mode == "doctor":
        doctor(acpx_cmd, cwd, hub_base_url)
        return
    handoff(payload, acpx_cmd, cwd, hub_base_url)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as exc:  # noqa: BLE001
        write_log(f"Unhandled error: {exc}")
        write_response({"ok": False, "mode": env('MORGAN_BRIDGE_MODE', 'handoff'), "error": str(exc)}, exit_code=1)
