# MorganBridge Stack

Community bridge/plugin stack for OpenClaw and Codex-compatible workflows.

MorganBridge Stack is a third-party integration bundle for handing work from an OpenClaw-side plugin into a connected Codex session through MorganBridge. It packages the current working pieces of the stack in one public entry repository while the components are being cleaned up for more focused publication.

This project is maintained independently by `morganshen153`. It is not affiliated with, endorsed by, sponsored by, or certified by OpenAI or the OpenClaw project. References to OpenClaw and Codex are used for compatibility and discoverability only.

## What Is Included

- [`morganbridge-openclaw-plugin/`](./morganbridge-openclaw-plugin)  
  OpenClaw-side launcher plugin that invokes MorganBridge and returns results into the originating conversation.
- [`morganbridge-receiver-skill/`](./morganbridge-receiver-skill)  
  Codex-side receiver skill that keeps handoff responses compact, continuous, and task-focused.
- [`morganbridge-runtime-source/`](./morganbridge-runtime-source)  
  Extracted source-side runtime tree prepared for Apache-2.0 publication.
- [`morganbridge-runtime/`](./morganbridge-runtime)  
  Bundled runtime payload currently kept as a distribution artifact while public provenance and rebuild boundaries are being tightened.

## Component Relationship

```mermaid
flowchart LR
  U["User request in OpenClaw"] --> P["morganbridge-openclaw-plugin<br/>OpenClaw-side launcher"]
  P --> B["morganbridge-runtime<br/>Bundled runtime payload"]
  P -. "bundled copy today" .-> PB["morganbridge-openclaw-plugin/bridge<br/>Embedded runtime copy"]
  RS["morganbridge-runtime-source<br/>Source-side runtime tree"] -. "future clean rebuild path" .-> B
  B --> C["Connected Codex session"]
  C --> S["morganbridge-receiver-skill<br/>Receiver-side behavior"]
  S --> R["Returned result"]
```

Today, the stack is published as one umbrella repository. The long-term cleaner shape is to keep the plugin, receiver skill, and runtime source in their own repositories while leaving this repo as the overview and integration entry point.

## Quick Start

1. Copy [`morganbridge-openclaw-plugin/`](./morganbridge-openclaw-plugin) into `%USERPROFILE%\.openclaw\extensions\morganbridge-openclaw-plugin\`.
2. If your Codex setup supports local skills, place [`morganbridge-receiver-skill/`](./morganbridge-receiver-skill) in your local skills directory.
3. Review the component installation guides before redistribution or customization:
   - [`morganbridge-openclaw-plugin/Installation-Guide.md`](./morganbridge-openclaw-plugin/Installation-Guide.md)
   - [`morganbridge-receiver-skill/Installation-Guide.md`](./morganbridge-receiver-skill/Installation-Guide.md)
4. Treat [`morganbridge-runtime-source/`](./morganbridge-runtime-source) as the source-side reference point, and treat bundled runtime binaries as a separate release boundary until the public build path is fully documented.

## Why This Repository Exists

This repository is the umbrella entry point for the full stack. It gives users one place to:

- discover the project through OpenClaw, Codex, plugin, skill, and bridge search terms
- understand how the plugin, skill, and runtime pieces fit together
- review naming, release-boundary, and licensing notes before reuse
- start from a working bundle before the components are split into narrower public repos

## Why A Multi-Repo Split May Follow

Keeping everything in one repository is convenient for discovery, but splitting the stack into multiple public repos later has practical advantages:

- clearer license and provenance boundaries between source code and bundled runtime artifacts
- lower legal and release risk because runtime binaries can be isolated or delayed without blocking source publication
- smaller, more focused repositories for users who only need the plugin or only need the receiver skill
- independent issues, releases, and versioning for each component
- better long-term search fit because plugin, skill, and runtime repos can each carry their own description, topics, and documentation

The most natural future split is:

- `morganbridge-openclaw-plugin`
- `morganbridge-receiver-skill`
- `morganbridge-runtime-source`
- this umbrella repo as the overview, relationship map, and integration entry point

The current split plan and publish checklist live in [`REPO_SPLIT_PLAN.md`](./REPO_SPLIT_PLAN.md).

## Release Boundary

- Apache-2.0-ready material:
  - [`morganbridge-openclaw-plugin/`](./morganbridge-openclaw-plugin)
  - [`morganbridge-receiver-skill/`](./morganbridge-receiver-skill)
  - [`morganbridge-runtime-source/`](./morganbridge-runtime-source)
- Pending binary/provenance review:
  - [`morganbridge-runtime/`](./morganbridge-runtime)
  - [`morganbridge-openclaw-plugin/bridge/`](./morganbridge-openclaw-plugin/bridge)

See these files for release and compliance details:

- [`LICENSE_SCOPE.md`](./LICENSE_SCOPE.md)
- [`SOURCE_BOUNDARY.md`](./SOURCE_BOUNDARY.md)
- [`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md)
- [`OPEN_SOURCE_RISK_REVIEW.md`](./OPEN_SOURCE_RISK_REVIEW.md)
- [`PROJECT_NAMING.md`](./PROJECT_NAMING.md)

## License

This project is released under the Apache License, Version 2.0 for the material identified as Apache-2.0-ready above. See [`LICENSE`](./LICENSE) for the full license text, and review the release-boundary documents before redistributing bundled runtime artifacts.
