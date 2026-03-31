# MorganBridge Receiver Skill Installation Guide

## What It Is

`morganbridge-receiver-skill` is a third-party Codex skill used with MorganBridge.

Its role is to:
- tell Codex that the task came from a MorganBridge handoff
- keep replies continuous, compact, and usable
- reduce unnecessary reframing or drifting

## How To Install

If your Codex setup supports local skills, place the whole folder in the skills directory you use and keep the folder name as:

`morganbridge-receiver-skill`

If you mainly use the packaged bridge flow, you can also keep this as the receiving-side behavior reference.

## How To Use It

It is usually not something a user launches manually.

The normal pattern is:

1. OpenClaw hands work over
2. Codex receives an OpenClaw-originated task
3. `morganbridge-receiver-skill` helps Codex continue in the right style

## What It Improves

With this skill in place, Codex is more likely to:
- stay on the same task
- answer briefly and directly
- stop at a narrow checkpoint when blocked
- remain stable across multiple rounds

## One-Line Summary

`morganbridge-receiver-skill` shapes how Codex continues after a MorganBridge handoff.`
