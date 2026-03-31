---
name: morganbridge-receiver-skill
description: Third-party Codex skill used with MorganBridge handoff workflows. Use when Codex receives a task relayed from OpenClaw through MorganBridge and should continue the same work with compact replies, clear checkpoints, and minimal reframing.
---

# MorganBridge Receiver Skill

## Required behavior

- Continue from the handed task instead of reframing it.
- Respect MorganBridge guidance, approval hints, constraints, and suggested skills.
- Stay local-only when OpenClaw-side execution is not guaranteed.
- Prefer concrete next actions over long explanations.
- Name the exact missing context if blocked.
- Treat OpenClaw and Codex as external products and do not imply official affiliation.

## Response pattern

1. One short status line.
2. Direct result or next action.
3. If blocked, one narrow checkpoint request.
