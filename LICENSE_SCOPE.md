# License Scope

This file clarifies how the top-level Apache-2.0 license should be applied in this mixed-content repository.

## Apache-2.0 Covered Material

Unless a file says otherwise, the following original material is intended to be released under Apache-2.0:

- root documentation files in this repository
- `morganbridge-runtime-source/`
- `morganbridge-receiver-skill/`
- `morganbridge-openclaw-plugin/`, except the bundled runtime subdirectory

## Not Covered By The Top-Level Apache Claim

The following paths should not be treated as newly relicensed under Apache-2.0 just because they are present in this repository:

- `morganbridge-runtime/`
- `morganbridge-openclaw-plugin/bridge/`

Those directories contain bundled executables, DLLs, and Python extension modules. They require separate provenance and redistribution review. See `THIRD_PARTY_NOTICES.md` and `SOURCE_BOUNDARY.md`.

## Release Rule

If you publish this repository before extracting or relicensing the runtime source, describe the runtime as a bundled binary distribution, not as fully open-source code.
