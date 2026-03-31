# MorganBridge Runtime Installation Guide

## What It Is

`morganbridge-runtime` is the local runtime bundle that contains `MorganBridge.exe` and its packaged dependencies.

Its job is to:
- receive a task
- hand it over to Codex
- bring the result back
- continue the same conversation across multiple rounds

## Who This Is For

This is for people who already use:
- OpenClaw
- Codex

and want OpenClaw to hand real work over to Codex.

## How To Install

It is not meant to be used alone in most cases.

The recommended setup is:

1. keep it together with the `morganbridge-openclaw-plugin`
2. let OpenClaw call it through that plugin

If you keep the file manually, make sure:
- `MorganBridge.exe` stays in a stable location
- the plugin can still find it

## How To Use

The normal usage is not double-clicking the exe.

The usual flow is:

1. install `morganbridge-openclaw-plugin` in OpenClaw
2. trigger a "send to Codex" action from OpenClaw
3. the plugin calls `MorganBridge.exe`
4. the result comes back into OpenClaw

## Practical Notes

- Do not treat it like a normal chat app
- Do not rename or separate it from the rest of the package casually
- If you move environments, move the package as a set whenever possible

## One-Line Summary

`morganbridge-runtime` is the local runtime bundle that actually sends the task out and brings the result back.`
