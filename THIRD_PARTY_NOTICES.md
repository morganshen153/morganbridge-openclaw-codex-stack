# Third-Party Notices

This file is a release-preparation inventory for bundled runtime files visible in the current repository. It is not a complete legal opinion and should be verified before public release.

## Bundled Binary Locations

- `morganbridge-runtime/`
- `morganbridge-openclaw-plugin/bridge/`

These two directories currently contain duplicate runtime payloads.

## Confirmed Or Strongly Indicated Third-Party Components

### Python runtime and standard extension modules

Observed files include:

- `python314.dll`
- `select.pyd`
- `unicodedata.pyd`
- `_bz2.pyd`
- `_decimal.pyd`
- `_hashlib.pyd`
- `_lzma.pyd`
- `_socket.pyd`
- `_ssl.pyd`

These filenames strongly indicate redistribution of the CPython runtime and standard extension modules. Python is generally distributed under the Python Software Foundation License, but Python distributions can also include components under additional compatible licenses. Verify the exact bundle provenance before release.

### OpenSSL libraries

Observed files include:

- `libcrypto-3.dll`
- `libssl-3.dll`

OpenSSL 3.x is distributed under Apache License 2.0. Keep its attribution and license notice with any redistributed binary package.

### Microsoft Visual C++ runtime

Observed files include:

- `vcruntime140.dll`
- `vcruntime140_1.dll`

These files are typically redistributed under Microsoft Visual Studio redistribution terms, not under your project license. Confirm that your packaging method complies with Microsoft redistribution rules.

## Unverified Components Requiring Provenance

The following bundled files require explicit source and license confirmation before publication:

- `MorganBridge.exe`
- `_wmi.pyd`
- `_zstd.pyd`

## Release Guidance

Before a public release:

1. Document where each bundled binary came from.
2. Record the governing license or redistribution terms for each bundle component.
3. Decide whether the public repository will include these binaries or instead publish them only as release artifacts.
4. Do not state or imply that all bundled files are covered by your Apache-2.0 license.
