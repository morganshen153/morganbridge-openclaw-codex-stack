# MorganBridge Receiver Skill

Third-party Codex skill used with MorganBridge handoff workflows.

This project is maintained independently by `morganshen153`. It is not affiliated with, endorsed by, sponsored by, or certified by OpenAI or the OpenClaw project. References to OpenClaw and Codex are used for compatibility only.

## What It Does

- tells Codex the task arrived through a MorganBridge handoff
- keeps replies compact and continuous instead of reframing the task
- encourages concrete next actions and narrow checkpoint requests when blocked
- reduces reply drift across multi-round bridge sessions

## Files

- `SKILL.md`
  - skill definition and behavior instructions
- `Installation-Guide.md`
  - installation notes for local skill setups

## Installation

If your Codex setup supports local skills, place this folder in your local skills directory and keep the folder name as:

`morganbridge-receiver-skill`

If you mainly use the packaged bridge flow, this directory can also be kept as the receiver-side behavior reference for future cleanup and split publication.

## Intended Behavior

The skill is designed to make Codex:

- continue from the handed task instead of reframing it
- respect MorganBridge guidance and constraints
- stay local-only when OpenClaw-side execution is not guaranteed
- stop at a narrow checkpoint if key context is missing
- avoid implying official affiliation with external products

## When To Use It

Use this skill when Codex receives a task relayed from OpenClaw through MorganBridge and should continue the same work with minimal ceremony.

## Release Status

This directory is prepared for Apache-2.0 publication as a standalone skill package.

For broader naming and release context, see:

- [`../PROJECT_NAMING.md`](../PROJECT_NAMING.md)
- [`../LICENSE_SCOPE.md`](../LICENSE_SCOPE.md)

## License

This project is licensed under the Apache License, Version 2.0. See [`LICENSE`](./LICENSE) for the full license text.
