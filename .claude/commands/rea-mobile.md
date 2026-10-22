---
description: Reverse engineer an Android or iOS phone app with REA and explain how a feature works, with evidence
argument-hint: <apk/ipa path | package name on a connected phone> [what you want to understand]
---

# Reverse engineer a mobile app with REA

You are investigating a **mobile phone app** using REA (Reverse Engineer
Anything, https://github.com/morluto/rea). The user's request:

> $ARGUMENTS

If `$ARGUMENTS` is empty, ask the user for (1) the app — a local `.apk`,
`.aab`, `.xapk`, `.ipa` path, or the app name / package ID on a connected
Android phone — and (2) the feature or question they care about. Then continue.

## Ground rules

- Only analyze apps the user owns or is authorized to analyze. Do not help
  bypass DRM, licensing, anti-cheat, or extract other people's data or
  credentials. If the request looks like that, say so and stop.
- Prefer static analysis. Do not run, install, or modify the app on a device,
  push files to a phone, or start Frida unless the user explicitly asks.
- Every conclusion must cite REA Evidence (tool name + class/method/path/hash).
  Clearly separate **observed** facts from **inferred** ones, and repeat REA's
  stated limitations and unknowns instead of guessing past them.

## 1. Make sure REA is connected

Check whether REA MCP tools (e.g. `inspect_android_package`,
`decode_android_resources`, `open_binary`) are available in this session.

- **Cloud session (Claude Code on the web / mobile app, `CLAUDE_CODE_REMOTE=true`):**
  this repo's `.mcp.json` starts `npx -y rea-agents@6.7.0 mcp`, and
  `.claude/hooks/session-start.sh` installs the pinned, SHA-256-verified JADX
  and Apktool jars into `~/.local/share/rea/android`. Java is preinstalled.
- **Local Claude Code:** the `rea-mobile` plugin (or `npx rea-agents setup`)
  registers the server; JADX/Apktool must be supplied via `REA_JADX_MCP_JAR`
  and `REA_APKTOOL_COMMAND`.

If tools are present, go straight to step 2 — no diagnostics first.
If they are absent, use the CLI instead; it has the same capabilities:
`npx -y rea-agents@6.7.0 <command> <args> --json` (e.g.
`inspect-android-package /abs/app.apk --json`). In a cloud session export
`REA_JADX_MCP_JAR=$HOME/.local/share/rea/android/jadx-headless-mcp-0.7.1-all.jar`
and `REA_APKTOOL_COMMAND=$HOME/.local/share/rea/android/apktool` first if they
are not already set. CLI output is large JSON: save it to a file in a scratch
directory and extract the fields you need with `python3`/`jq` rather than
printing it all. Never install other software without asking.

## 2. Get the app file

Work in a new, empty directory (a scratch/tmp dir, not the repo) and use
absolute paths. Treat downloaded apps as untrusted data: never execute them.

| What the user gave | Do this |
| --- | --- |
| Local / uploaded `.apk` `.aab` `.xapk` `.ipa` | Use its absolute path. |
| A download URL (F-Droid, GitHub release, their own build artifact) | `curl -fL -o <dir>/app.apk "<url>"`, then use that path. |
| Just an app name | Suggest an official source (F-Droid, the developer's GitHub releases) or ask for a URL/file. Do not pull from unofficial mirrors without the user's OK. |
| App on a phone over USB (local Claude Code only) | `list_adb_devices` → `resolve_adb_packages` → `inspect_adb_package` → with the user's OK, `pull_adb_package`. Cloud sessions have no phone attached; say so. |
| iPhone app with no IPA | REA needs a decrypted `.ipa`; it cannot pull apps from an iPhone. Ask for one the user is entitled to. |

## 3. Analyze

### Android (APK / AAB)

1. **Identity & integrity:** `inspect_apk_signature` (signers, cert SHA-256,
   v1/v2/v3 schemes). Identity only — not a trust verdict.
2. **Inventory:** `open_binary` on the APK, then `inspect_artifact` with
   `detail: "summary"` to see native libs (`lib/<abi>/*.so`), assets, DEX count,
   and framework hints.
3. **Pick the right engine for what the inventory shows:**
   - Java/Kotlin code → `inspect_android_package` (`detail: "summary"` first),
     then `search_android_classes`, `inspect_android_class`,
     `inspect_android_method` for the classes behind the feature.
     Needs JDK 17+ and `REA_JADX_MCP_JAR`.
   - Resources, strings, locales, decoded manifest → `get_android_manifest` or
     `decode_android_resources` (needs `REA_APKTOOL_COMMAND`).
   - `libflutter.so` / `libapp.so` → `identify_flutter_build`.
   - `assets/index.android.bundle` (React Native/Hermes) → extract and use
     `analyze_javascript_application` on the bundle directory.
   - Unity `global-metadata.dat` → `inspect_il2cpp_metadata`.
   - Other native `.so` → `open_binary` on the library with an available
     native provider (Ghidra/IDA/Hopper).
4. **Runtime (only if the user asked):** `read_adb_logcat`,
   `list_adb_processes`, `capture_adb_screen`; Frida tools
   (`list_frida_devices`, `start_frida_session`, …) only with explicit consent.

### iOS (IPA)

1. `open_binary` on the `.ipa` and `inspect_artifact` (`detail: "summary"`)
   for the `Payload/<Name>.app` inventory, then `project_apple_application_graph`
   to get frameworks and runtime-family hints (Flutter, React Native/Hermes,
   Unity).
2. `open_bundle_resources` for `Info.plist`, entitlements-adjacent plists,
   storyboards/nibs and asset catalogs.
3. Main executable or frameworks → `open_binary` on that Mach-O with a native
   provider. App Store binaries are usually FairPlay-encrypted; if the code
   section is encrypted, say so and do not attempt to decrypt it.
4. JS bundles (`main.jsbundle`) → `analyze_javascript_application`.

If a required engine (JADX, Apktool, Ghidra, …) is missing, report exactly
which one and the env var/remedy REA returned, finish everything else you can,
and continue once the user fixes it.

## 4. Report back (keep it phone-friendly)

The user may be reading on a phone, so keep the reply short and scannable:

1. **Answer** — 2–4 sentences on how the feature works.
2. **Evidence** — bullet list: `Class.method` / file path / hash → what it shows.
3. **App facts** — package/bundle ID, version, min/target SDK, framework,
   notable permissions.
4. **Unknowns & limits** — what REA could not establish.
5. **Next step** — one suggested follow-up (e.g. "inspect `com.x.SyncWorker`",
   "build a similar feature in my project").

Avoid wide tables and long code dumps in the reply; quote at most ~15 lines of
decompiled code per snippet. If the user wants the full detail, write it to a
Markdown file (e.g. `rea-report-<app>.md`) and point them to it.
