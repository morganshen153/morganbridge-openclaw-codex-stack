# Open Source Risk Review

This is an engineering risk review, not legal advice.

## High Risk

### Bundled third-party binaries need provenance and license review

- `morganbridge-runtime/` ships `MorganBridge.exe`, Python runtime files, OpenSSL DLLs, and other binary dependencies.
- `morganbridge-openclaw-plugin/bridge/` contains a second copy of the same runtime bundle.
- Do not publish these bundles under a blanket Apache-2.0 claim until you document which files are yours and which are third-party redistributions.

### Public renaming is incomplete without a bridge rebuild

- String scans still show legacy names and local-runtime traces inside `morganbridge-runtime/MorganBridge.exe`.
- The duplicate binary under `morganbridge-openclaw-plugin/bridge/MorganBridge.exe` shows the same legacy strings.
- Without source code or a rebuild process, the public-facing rename cannot fully remove old branding from the binary payload.

### Runtime source exists, but the public build path is not yet verified

- `morganbridge-runtime-source/` now contains extracted runtime source and build inputs.
- The bundled runtime binary should still be described as a binary distribution until you rebuild and validate it from the public source tree.

## Medium Risk

### Plugin code previously exposed machine-specific defaults

- `morganbridge-openclaw-plugin/index.js` used to hardcode `C:/Users/Administrator/...`, `E:/codex`, and a specific npm shim path.
- This file has been rewritten to prefer environment variables and runtime defaults instead.

### Docs previously exposed a user-specific install path

- The OpenClaw plugin docs used a fixed `C:\Users\Administrator\...` path.
- The docs now use `%USERPROFILE%` so the published instructions are portable.

### No top-level release license set yet

- If you intend to release under Apache-2.0, add `LICENSE` at the project roots you actually own.
- Add `THIRD_PARTY_NOTICES.md` or equivalent before publishing any bundled runtimes.

## Low Risk

### Current public naming is now lower risk

- Public names now place `MorganBridge` first and treat `OpenClaw` and `Codex` as compatibility terms, not as primary branding.

## Recommended Next Steps

1. Separate your original code from bundled third-party binaries.
2. Add `LICENSE`, `NOTICE` if needed, and `THIRD_PARTY_NOTICES.md`.
3. Decide whether `MorganBridge.exe` will be open source, source-available, or binary-only.
4. Rebuild the bridge from source before claiming the rename is complete.
