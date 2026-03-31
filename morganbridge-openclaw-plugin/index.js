// Copyright 2026 morganshen153
// SPDX-License-Identifier: Apache-2.0

import { spawn } from "node:child_process";
import { fileURLToPath } from "node:url";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";

const pluginDir = path.dirname(fileURLToPath(import.meta.url));
const defaultBridgeExe = path.resolve(pluginDir, "bridge", "MorganBridge.exe");
const defaultHubBaseUrl =
  process.env.MORGANBRIDGE_HUB_BASE_URL || "http://127.0.0.1:8010/api/v1";
const defaultAcpxCmd = process.env.MORGANBRIDGE_ACPX_CMD || "acpx";
const defaultCwd = process.env.MORGANBRIDGE_DEFAULT_CWD || process.cwd();

async function runBridge({ bridgeExe, payload, pluginConfig }) {
  const nonce = `${Date.now()}-${Math.random().toString(16).slice(2)}`;
  const payloadFile = path.join(os.tmpdir(), `morgan-bridge-payload-${nonce}.json`);
  const responseFile = path.join(os.tmpdir(), `morgan-bridge-response-${nonce}.json`);
  const logFile = path.join(os.tmpdir(), `morgan-bridge-log-${nonce}.log`);

  await fs.writeFile(payloadFile, JSON.stringify(payload, null, 2), "utf8");

  const env = {
    ...process.env,
    MORGAN_BRIDGE_MODE: "handoff",
    MORGAN_BRIDGE_PAYLOAD_FILE: payloadFile,
    MORGAN_BRIDGE_RESPONSE_FILE: responseFile,
    MORGAN_BRIDGE_LOG_FILE: logFile,
    MORGAN_BRIDGE_HUB_BASE_URL: pluginConfig?.hubBaseUrl || defaultHubBaseUrl,
    MORGAN_BRIDGE_ACPX_CMD: pluginConfig?.acpxCmd || defaultAcpxCmd,
    MORGAN_BRIDGE_DEFAULT_CWD: pluginConfig?.defaultCwd || defaultCwd,
  };

  const result = await new Promise((resolve) => {
    const child = spawn(bridgeExe, [], { env, windowsHide: true });
    let stderr = "";

    child.stderr.on("data", (chunk) => {
      stderr += String(chunk);
    });

    child.on("close", async (code) => {
      let response = null;
      try {
        response = JSON.parse(await fs.readFile(responseFile, "utf8"));
      } catch {}

      resolve({
        code,
        stderr,
        response,
        logFile,
        responseFile,
        payloadFile,
      });
    });
  });

  try {
    await fs.unlink(payloadFile);
  } catch {}

  try {
    await fs.unlink(responseFile);
  } catch {}

  return result;
}

const plugin = {
  id: "morganbridge-openclaw-plugin",
  name: "MorganBridge OpenClaw Plugin",
  version: "0.1.0",
  description:
    "Third-party OpenClaw plugin that routes tasks through MorganBridge to a connected Codex session.",
  register(api) {
    api.registerTool(
      (context) => ({
        name: "morganbridge_openclaw_bridge",
        label: "MorganBridge",
        description: "Bridge a task to a connected Codex session and return the result.",
        parameters: {
          type: "object",
          properties: {
            message: { type: "string", description: "Task text." },
            cwd: { type: "string", description: "Working directory override." },
            task_type: { type: "string", description: "Task type hint." },
            prior_summary: { type: "string", description: "Prior summary." },
            run_id: { type: "string", description: "Run id." },
            thread_id: { type: "string", description: "Thread id." },
            session_name: { type: "string", description: "Session name." },
          },
          required: ["message"],
          additionalProperties: false,
        },
        execute: async (_, args) => {
          const pluginConfig = context.pluginConfig || {};
          const bridgeExe = pluginConfig.bridgeExe || defaultBridgeExe;
          const payload = {
            message: String(args.message || "").trim(),
            cwd: args.cwd || pluginConfig.defaultCwd || defaultCwd,
            task_type: args.task_type || "bridge",
            prior_summary: args.prior_summary || null,
            run_id: args.run_id || null,
            thread_id: args.thread_id || context.sessionId || context.sessionKey || null,
            session_name: args.session_name || null,
          };

          const bridgeResult = await runBridge({ bridgeExe, payload, pluginConfig });
          const response = bridgeResult.response || {};
          const ok = Boolean(response.ok) && Number(bridgeResult.code) === 0;
          const text = ok
            ? String(response.output_text || "").trim() ||
              "MorganBridge completed without text output."
            : `MorganBridge failed: ${response.error || bridgeResult.stderr || "unknown error"}`;

          return {
            content: [{ type: "text", text }],
            details: {
              ok,
              bridgeExe,
              response,
              stderr: bridgeResult.stderr,
              logFile: bridgeResult.logFile,
            },
          };
        },
      }),
      { names: ["morganbridge_openclaw_bridge"] }
    );

    api.on("before_agent_start", (_, context) => {
      if (context.pluginConfig?.autoHint === false) {
        return;
      }

      return {
        appendSystemContext: [
          "MorganBridge is available through `morganbridge_openclaw_bridge`.",
          "When the user explicitly asks to hand work to Codex, call it once.",
          "Pass the user request through `message` and include `task_type` when obvious.",
          "If it succeeds, return the bridge result directly.",
          "Treat this as a third-party integration and do not imply official affiliation.",
        ].join("\n"),
      };
    });
  },
};

export default plugin;
