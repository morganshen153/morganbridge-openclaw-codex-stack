# Repo Split Plan

This document turns the current umbrella repository into an actionable multi-repo release plan.

It is an engineering release checklist, not legal advice.

## Recommended Repository Set

| Role | Recommended repo slug | Current source path | Publish now |
| --- | --- | --- | --- |
| Umbrella entry repo | `morganbridge-openclaw-codex-stack` | repository root | Yes |
| OpenClaw plugin | `morganbridge-openclaw-plugin` | `morganbridge-openclaw-plugin/` | Yes, with binary boundary handled explicitly |
| Codex receiver skill | `morganbridge-receiver-skill` | `morganbridge-receiver-skill/` | Yes |
| Runtime source repo | `morganbridge-runtime-source` | `morganbridge-runtime-source/` | Yes |

## Recommended Release Order

1. `morganbridge-receiver-skill`
2. `morganbridge-runtime-source`
3. `morganbridge-openclaw-plugin`
4. keep `morganbridge-openclaw-codex-stack` as the integration and discovery repo

This order reduces risk because the cleanest source-only pieces go public first, and the plugin repo can then link to the runtime-source repo instead of trying to explain everything itself.

## Umbrella Repo Checklist

Target repo:

- `morganbridge-openclaw-codex-stack`

Description:

- `Community bridge/plugin stack for OpenClaw and Codex-compatible workflows`

Topics:

- `morganbridge`
- `openclaw`
- `codex`
- `plugin`
- `skill`
- `bridge`
- `automation`

Keep in repo:

- root `README.md`
- `LICENSE`
- `NOTICE`
- `LICENSE_SCOPE.md`
- `SOURCE_BOUNDARY.md`
- `THIRD_PARTY_NOTICES.md`
- `OPEN_SOURCE_RISK_REVIEW.md`
- `PROJECT_NAMING.md`
- component folders while the split is in progress

Future cleanup after split:

- keep this repo as an overview, diagram, compatibility notes, and integration map
- link out to the three component repos from the top of `README.md`
- decide whether bundled runtime artifacts should remain here or move to a separate binary-distribution channel

## Receiver Skill Repo Checklist

Target repo:

- `morganbridge-receiver-skill`

Description:

- `Third-party Codex receiver skill for MorganBridge handoff workflows`

Topics:

- `morganbridge`
- `codex`
- `skill`
- `handoff`
- `workflow`
- `automation`

Copy into repo:

- `SKILL.md`
- `README.md`
- `Installation-Guide.md`
- `Installation-Guide.txt`
- `LICENSE`
- optional localized install docs if you want bilingual release assets

Do not copy:

- unrelated umbrella docs unless they are still referenced
- runtime binaries
- plugin code

Pre-publish checks:

- confirm `SKILL.md` has no local-machine paths
- confirm README keeps the non-affiliation statement
- confirm installation notes describe a generic local skills directory

Publish steps:

- create public repo `morganbridge-receiver-skill`
- copy the listed files into a clean working tree
- commit the standalone package
- set description and topics
- add a release tag only after testing local installation once

## Runtime Source Repo Checklist

Target repo:

- `morganbridge-runtime-source`

Description:

- `Source-side runtime tree for MorganBridge handoff execution`

Topics:

- `morganbridge`
- `runtime`
- `bridge`
- `python`
- `powershell`
- `codex`

Copy into repo:

- `src/`
- `build/`
- `README.md`
- `LICENSE`

Do not copy:

- `morganbridge-runtime/`
- plugin-side `bridge/` binaries
- any claim that the current bundled executable is reproducibly rebuilt from this repo

Pre-publish checks:

- confirm source headers and license text are present
- confirm README still says the public build path is not yet fully verified
- confirm no user-specific paths remain in source or build docs

Publish steps:

- create public repo `morganbridge-runtime-source`
- copy the listed files into a clean working tree
- commit the standalone source tree
- set description and topics
- later add build instructions only after the rebuild path is validated

## OpenClaw Plugin Repo Checklist

Target repo:

- `morganbridge-openclaw-plugin`

Description:

- `Third-party OpenClaw plugin that routes tasks through MorganBridge to a connected Codex session`

Topics:

- `morganbridge`
- `openclaw`
- `plugin`
- `bridge`
- `codex`
- `integration`

Safest initial repo shape:

- `index.js`
- `openclaw.plugin.json`
- `package.json`
- `README.md`
- `Installation-Guide.md`
- `Installation-Guide.txt`
- `LICENSE`

Risky material to exclude or isolate before standalone publication:

- `bridge/`
- any bundled `MorganBridge.exe`
- any bundled Python runtime files
- any bundled OpenSSL or VC runtime DLLs

Current blocker:

- the plugin currently works with a bundled runtime path by default, but `bridge/` is the highest-risk redistribution area in the whole stack

Recommended publish stance:

- publish the plugin source repo first without `bridge/`, or with a very explicit placeholder explaining that users must provide their own approved runtime path
- only add bundled binaries later if provenance and redistribution terms are fully documented

Pre-publish checks:

- confirm `index.js` still prefers env vars and runtime defaults over machine-specific hardcoded paths
- confirm README documents `bridgeExe`, `hubBaseUrl`, `acpxCmd`, and `defaultCwd`
- confirm standalone install instructions do not imply official OpenClaw support

Publish steps:

- create public repo `morganbridge-openclaw-plugin`
- copy the safe file set into a clean working tree
- decide whether to include a placeholder `bridge/README.md` or remove the directory entirely
- commit the standalone plugin package
- set description and topics
- test one real plugin install against a user-supplied runtime path before tagging a release

## Cross-Repo Rules

- Keep `MorganBridge` as the lead brand in every repo title and README.
- Use `OpenClaw` and `Codex` as compatibility terms, not as primary branding.
- Keep Apache-2.0 license text in each standalone repo root.
- Preserve the non-affiliation disclaimer in every public README.
- Do not make blanket Apache claims over bundled runtime binaries until provenance is documented.

## Suggested Next Execution Pass

1. Create the three standalone repositories on GitHub.
2. Prepare three clean export directories from this umbrella repo.
3. Remove or isolate `bridge/` from the standalone plugin export.
4. Push the receiver-skill repo first.
5. Push the runtime-source repo second.
6. Push the plugin repo third.
7. Update this umbrella repo README to link to the new repos once they exist.
