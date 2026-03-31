# Source Boundary

This document records the current public release boundary for MorganBridge Stack.

## Public Bundle Scope

The current release includes Apache-2.0-ready material and bundled runtime distribution material in the same repository.

## Apache-2.0-Ready Material

Unless a file states otherwise, the following material is intended to be released under Apache License 2.0:

- root documentation files
- `morganbridge-runtime-source/`
- `morganbridge-receiver-skill/`
- `morganbridge-openclaw-plugin/`, excluding its bundled runtime subdirectory

## Bundled Runtime Distribution Material

The following paths are bundled runtime distribution material in the current public release:

- `morganbridge-runtime/`
- `morganbridge-openclaw-plugin/bridge/`

These paths should be described as bundled runtime content, not as a blanket Apache-2.0 source release.

## Why This Boundary Exists

The public bundle includes executable and runtime distribution material alongside source and documentation. Keeping this boundary explicit helps users understand what is Apache-2.0-ready and what remains packaged runtime content.

## Recommended Public Description

When describing this repository publicly:

- refer to it as a public bundle release
- describe the runtime as bundled distribution material
- keep compatibility language descriptive rather than official
- point users to `LICENSE_SCOPE.md` and `THIRD_PARTY_NOTICES.md` for reuse questions
