# Source Boundary

This document records the current publication boundary for the MorganBridge bundle.

## Current Release Decision

### Open Source Under Apache-2.0 In This Repository

- root documentation files
- `morganbridge-runtime-source/`
- `morganbridge-receiver-skill/`
- `morganbridge-openclaw-plugin/`, excluding its bundled runtime subdirectory

### Binary-Only In This Bundle For Now

- `morganbridge-runtime/`
- `morganbridge-openclaw-plugin/bridge/`

These runtime paths should be described as bundled binaries in the current public bundle, not as fully open-source source trees.

## Why This Boundary Exists

The published desktop bundle currently contains executable artifacts and third-party runtime files, but it does not yet include a clean, public source tree plus build instructions for those runtime artifacts.

## Evidence Found In Local Workspace

The clean extracted runtime source now lives inside this desktop bundle:

- `morganbridge-runtime-source/src/morganbridge.py`
- `morganbridge-runtime-source/build/MorganBridge.ps1`
- `morganbridge-runtime-source/build/morganbridge-receiver-skill.md`

Additional local source and build material still exists outside this desktop bundle:

- `E:\codex\ocbridge\standalone-build\morganbridge.dist\morganbridge.exe`
- `E:\codex\ocbridge-src\openclaw-codex-plugin\index.js`
- `E:\codex\ocbridge-src\openclaw-codex-skill\`

## Hash Match

The bundled desktop `MorganBridge.exe` files currently hash to:

- `F7550141DF510267B5BF6B115712F4CBF6939F8BA15C57D49C4D52E8F5207787`

This hash matches the local build artifact at:

- `E:\codex\ocbridge\standalone-build\morganbridge.dist\morganbridge.exe`

This is strong evidence that the desktop bundle runtime came from the local build pipeline. The runtime source has now been extracted, but the public build path still needs verification before the runtime binary itself should be described as fully open source.

## Recommended Publication Strategy

For the current bundle release:

- publish the skill and plugin code as Apache-2.0
- publish `morganbridge-runtime-source/` as Apache-2.0 runtime source
- describe the runtime as a bundled binary distribution
- keep third-party notices with the runtime payload

For a later source release:

- extract the runtime source into a dedicated repository or source directory
- publish build instructions and dependency provenance
- rebuild `MorganBridge.exe` from that public source before claiming the runtime is open source
