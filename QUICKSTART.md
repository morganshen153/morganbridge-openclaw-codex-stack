# Quick Start

MorganBridge Stack is published as a public bundle for people who want a smoother OpenClaw to Codex-compatible workflow.

## Start Here

1. Review the root [`README.md`](./README.md) so you understand the public scope of this repository.
2. Copy the plugin folder into:
   `%USERPROFILE%\.openclaw\extensions\morganbridge-openclaw-plugin\`
3. If your Codex setup supports local skills, place the receiver skill folder in your local skills directory.
4. Restart the relevant app or reopen the conversation after installation.
5. Try a simple continuation request such as:
   - "hand this to Codex"
   - "continue this with Codex"
   - "let Codex do it"

## Recommended Reading

- [`morganbridge-openclaw-plugin/Installation-Guide.md`](./morganbridge-openclaw-plugin/Installation-Guide.md)
- [`morganbridge-receiver-skill/Installation-Guide.md`](./morganbridge-receiver-skill/Installation-Guide.md)

## Interruption Recovery

If a session is interrupted, the reply is cut off, or the workflow loses continuity:

1. keep using the same working folder or project context
2. reopen the conversation or start a fresh one if needed
3. restate the task in one short sentence instead of re-explaining everything
4. mention the most recent successful result or last visible checkpoint
5. continue with the next concrete step instead of restarting from zero

In most cases, a short resume prompt works better than a full rewrite of the original task.

Examples:

- "Continue from the last step and finish the fix."
- "Resume the previous coding task from the last visible checkpoint."
- "Pick up the interrupted handoff and continue the same task."

## Public Scope Note

This repository is the current public bundle release. It includes both Apache-2.0-ready material and bundled runtime distribution material.

If you need exact release and redistribution boundaries, review:

- [`LICENSE_SCOPE.md`](./LICENSE_SCOPE.md)
- [`SOURCE_BOUNDARY.md`](./SOURCE_BOUNDARY.md)
- [`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md)
