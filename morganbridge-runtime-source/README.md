# MorganBridge Runtime Source

This directory contains the publishable source inputs for the MorganBridge runtime.

It is intended to become the clean source-side counterpart to the bundled runtime payload under `../morganbridge-runtime/`.

## Contents

- `src/morganbridge.py`
  - Python runtime entry logic for handoff and doctor modes
- `build/MorganBridge.ps1`
  - PowerShell wrapper used in the local build and execution flow
- `build/morganbridge-receiver-skill.md`
  - Embedded receiver-skill prompt content used by the bridge

## Current Status

- This source directory is prepared for Apache-2.0 publication.
- The bundled runtime payload is still tracked separately as a binary distribution.
- Public release should not claim the runtime binaries are rebuilt from this exact source tree until you complete and verify a public build path.

## Build Boundary

This directory does not yet contain a complete reproducible public build pipeline. It is the first clean extraction of the runtime source from the local workspace.
