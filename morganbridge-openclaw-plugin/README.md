# MorganBridge OpenClaw Plugin

Third-party OpenClaw plugin that routes tasks through MorganBridge to a connected Codex session.

This project is maintained independently by `morganshen153`. It is not affiliated with, endorsed by, sponsored by, or certified by OpenAI or the OpenClaw project. References to OpenClaw and Codex are used for compatibility only.

## What It Does

- registers an OpenClaw-side bridge tool
- passes task payloads to MorganBridge
- returns the resulting Codex-side output into the originating conversation
- adds a small system hint so OpenClaw can invoke the bridge when the user explicitly asks

## Files

- `index.js`
  - plugin entry point and tool registration
- `openclaw.plugin.json`
  - plugin metadata and config schema
- `bridge/`
  - bundled runtime payload used by the plugin at execution time
- `Installation-Guide.md`
  - installation notes for local use

## Installation

Copy this folder into:

`%USERPROFILE%\.openclaw\extensions\morganbridge-openclaw-plugin\`

Keep the folder structure intact. Do not copy only one file.

After installation:

1. restart OpenClaw
2. reopen the conversation or start a new one
3. confirm the plugin can invoke the MorganBridge runtime

## Configuration

The plugin supports these configuration fields through `openclaw.plugin.json`:

- `bridgeExe`
  - override the path to `MorganBridge.exe`
- `hubBaseUrl`
  - override the MorganBridge hub API base URL
- `acpxCmd`
  - override the Codex-side launcher command
- `defaultCwd`
  - override the default working directory passed to the bridge

The plugin also supports these environment variables:

- `MORGANBRIDGE_HUB_BASE_URL`
- `MORGANBRIDGE_ACPX_CMD`
- `MORGANBRIDGE_DEFAULT_CWD`

## Typical Use

This plugin is intended for cases where the user explicitly wants work handed off to Codex, for example:

- "hand this to Codex"
- "continue this with Codex"
- "let Codex do it"

## Release Boundary

This directory contains Apache-2.0-ready plugin code, but the bundled binaries under `bridge/` should still be treated as a separate distribution boundary pending full third-party provenance and rebuild review.

For broader release notes, see:

- [`../LICENSE_SCOPE.md`](../LICENSE_SCOPE.md)
- [`../SOURCE_BOUNDARY.md`](../SOURCE_BOUNDARY.md)
- [`../THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md)

## License

This project is licensed under the Apache License, Version 2.0 for the source material in this directory, subject to the binary boundary noted above. See [`LICENSE`](./LICENSE) for the full license text.
