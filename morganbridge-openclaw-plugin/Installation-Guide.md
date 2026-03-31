# MorganBridge OpenClaw Plugin Installation Guide

## What It Is

`morganbridge-openclaw-plugin` is a third-party OpenClaw plugin.

It is responsible for:
- giving OpenClaw a real path to hand work to MorganBridge
- calling `MorganBridge.exe`
- returning the result back into the current conversation

## Where To Install It

Copy the whole folder to:

`%USERPROFILE%\.openclaw\extensions\morganbridge-openclaw-plugin\`

Do not copy only one file. Keep the folder structure intact.

## What To Do After Installation

1. make sure the plugin folder is in place
2. restart OpenClaw
3. reopen chat or start a new session

## How To Use It

After installation, this plugin should be involved when the user says things like:
- "hand this to Codex"
- "continue this with Codex"
- "let Codex do it"

## Expected Result

When it works correctly:
- OpenClaw stops being only descriptive
- the task is actually handed over
- the Codex result comes back into the chat

## Best Use Cases

- coding tasks
- multi-step execution tasks
- multi-round continuation tasks

## One-Line Summary

`morganbridge-openclaw-plugin` is the OpenClaw-side launcher that makes the bridge actually fire.`
