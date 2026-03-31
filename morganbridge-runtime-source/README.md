# MorganBridge Runtime Source

Source-side runtime tree for MorganBridge.

This directory is the clean public source counterpart to the bundled runtime payload tracked elsewhere in the stack. It is intended to hold the publishable logic for MorganBridge handoff execution without overstating binary rebuild guarantees that have not yet been documented end to end.

This project is maintained independently by `morganshen153`. It is not affiliated with, endorsed by, sponsored by, or certified by OpenAI or the OpenClaw project. References to OpenClaw and Codex are used for compatibility only.

## What Is Included

- `src/morganbridge.py`
  - Python runtime entry logic for handoff and doctor flows
- `build/MorganBridge.ps1`
  - PowerShell wrapper used in the local build and execution path
- `build/morganbridge-receiver-skill.md`
  - embedded receiver-skill prompt content used by the bridge

## Purpose

This directory exists to:

- publish the source-side runtime logic under a clear Apache-2.0 boundary
- separate source review from bundled binary redistribution questions
- provide a future base for a cleaner public build and packaging pipeline

## Current Status

- this directory is prepared for Apache-2.0 publication
- the bundled runtime payload is still tracked separately as a binary distribution artifact
- public release should not claim the current runtime binaries are reproducibly rebuilt from this exact tree until the public build path is completed and verified

## Build Boundary

This directory does not yet contain a complete reproducible public build pipeline. It is a clean extraction of the source-side runtime inputs from the local workspace, not yet a final standalone release engineering package.

For provenance and release details, see:

- [`../SOURCE_BOUNDARY.md`](../SOURCE_BOUNDARY.md)
- [`../LICENSE_SCOPE.md`](../LICENSE_SCOPE.md)
- [`../THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md)

## License

This project is licensed under the Apache License, Version 2.0. See [`LICENSE`](./LICENSE) for the full license text.
