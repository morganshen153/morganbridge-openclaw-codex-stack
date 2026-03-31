# Open Source Risk Review

This is a public engineering note, not legal advice.

## Main Release Considerations

- this repository contains both Apache-2.0-ready material and bundled runtime distribution material
- bundled runtime files should not be described as fully open-source source code
- redistribution should follow the boundary and notice documents included in this repository

## Runtime Bundles

The current public bundle includes runtime distribution material in these locations:

- `morganbridge-runtime/`
- `morganbridge-openclaw-plugin/bridge/`

These paths should be treated as bundled runtime material inside the public release, not as a blanket Apache-2.0 source claim.

## Public Communication Guidance

- describe the repository as a public bundle release
- describe compatibility references as descriptive only
- avoid implying official affiliation with OpenClaw, Codex, or OpenAI
- point users to the boundary documents if they need packaging or license detail

## Recommended Supporting Files

- [`LICENSE_SCOPE.md`](./LICENSE_SCOPE.md)
- [`SOURCE_BOUNDARY.md`](./SOURCE_BOUNDARY.md)
- [`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md)
- [`NOTICE`](./NOTICE)

## Practical Rule

Use this repository as the current public bundle release, and treat the bundled runtime material as separately bounded distribution content.
