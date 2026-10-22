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

Check whether REA MCP tools (e.g. `inspect_android_package`, `open_binary`,
`list_adb_devices`) are available in this session. This plugin registers the
`rea` MCP server via `npx -y rea-agents@6.7.0 mcp` (needs Node.js 22.19+).

- Tools present → go straight to step 2. Do not run diagnostics first.
- Tools absent → tell the user to run `/mcp` (or restart Claude Code) so the
  `rea` server starts. If it still fails, run
  `npx -y rea-agents@latest doctor --client claude_code --json` and report the
  blocker. As a fallback you may use the CLI directly:
  `npx -y rea-agents@latest <command> ... --json`.
- Never install Java, JADX, adb, Apktool, or the Android SDK without asking.

## 2. Get the app file

| What the user gave | Do this |
| --- | --- |
| Local `.apk` / `.aab` / `.xapk` / `.zip` | Use the absolute path. |
| Local `.ipa` | Use the absolute path (iOS route below). |
| App name or package on a USB/emulator Android phone | `list_adb_devices` → `resolve_adb_packages <serial> <name>` → `inspect_adb_package` → with the user's OK, `pull_adb_package` into a new empty output directory, then use the pulled `base.apk` (and split APKs). |
| iPhone app with no IPA | Explain that REA needs a decrypted `.ipa`; it cannot pull apps from an iPhone. Ask the user to supply one they are entitled to. |

Device tools need `adb` on `PATH` or `REA_ADB_PATH`, and USB debugging enabled
on the phone.

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
