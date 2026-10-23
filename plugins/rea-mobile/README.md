# rea-mobile

A Claude Code plugin that adds the **`/rea`** slash command: reverse
engineer an Android or iOS **phone app** with
[REA — Reverse Engineer Anything](https://github.com/morluto/rea) and get a
short, evidence-backed explanation of how a feature works.

## Install

```
/plugin install rea-mobile --marketplace jma47616-maker/git-init
```

Or, on older Claude Code:

```
/plugin marketplace add jma47616-maker/git-init
/plugin install rea-mobile@jma-plugins
```

## Usage

```
/rea /path/to/app.apk how does the offline sync work?
/rea com.example.notes  how is search implemented?   # app on a connected Android phone
/rea /path/to/App.ipa   what frameworks does it use?
```

Claude routes the app to the right REA tools (APK signature, JADX
decompilation, Apktool resources, Flutter/React Native/Unity detection, adb
device acquisition, IPA inventory) and replies in a compact, phone-friendly
format: answer, evidence, app facts, unknowns, next step.

## What gets installed

- `commands/rea.md` — the slash command.
- `.mcp.json` — registers REA's MCP server (`npx -y rea-agents@6.7.0 mcp`).
  Restart Claude Code (or run `/mcp`) after installing the plugin.

If you already ran `npx rea-agents setup`, you will have REA registered twice;
that's fine, or remove one with `claude mcp remove --scope user rea`.

## Requirements

| Task | Needs |
| --- | --- |
| Everything | Node.js 22.19+ (for `npx rea-agents`) |
| Android code (decompile classes/methods) | JDK 17+ and `REA_JADX_MCP_JAR` → [Android guide](https://github.com/morluto/rea/blob/main/docs/android-analysis.md) |
| Android resources / strings | `REA_APKTOOL_COMMAND` → [Apktool guide](https://github.com/morluto/rea/blob/main/docs/apktool-resource-analysis.md) |
| Pull apps from a phone | `adb` on `PATH` (or `REA_ADB_PATH`), USB debugging on → [ADB guide](https://github.com/morluto/rea/blob/main/docs/adb-device-analysis.md) |
| Native `.so` / iOS Mach-O code | Ghidra, IDA, or Hopper |
| APK signature, IPA inventory, Flutter detection | Nothing extra |

Set env vars in your shell before launching `claude` so the MCP server inherits
them.

Only analyze apps you own or are authorized to analyze. The command prefers
static analysis and asks before touching a device.
