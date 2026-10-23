# jma-plugins — Claude Code Plugin Marketplace

A [Claude Code](https://claude.com/claude-code) plugin marketplace. It currently
hosts two plugins:

- **rendercv-resume** — create an ATS-friendly resume tailored to a job
  description in the exact [RenderCV](https://github.com/rendercv/rendercv)
  format and render it to a polished PDF.
- **rea-mobile** — the `/rea` command: reverse engineer an Android (APK)
  or iOS (IPA) phone app with [REA](https://github.com/morluto/rea) and get a
  short, evidence-backed explanation of how a feature works. See
  [its README](plugins/rea/README.md).

## Install (for your friend)

In Claude Code, add this marketplace, then install the plugin:

```
/plugin marketplace add jma47616-maker/git-init
/plugin install rendercv-resume@jma-plugins
/plugin install rea-mobile@jma-plugins
```

> The `owner/repo` shorthand pulls from the repository's **default branch**. The
> plugin currently lives on the `claude/vibrant-knuth-tolnnt` branch — either
> merge it to the default branch first, or add it from a local clone:
>
> ```
> git clone -b claude/vibrant-knuth-tolnnt https://github.com/jma47616-maker/git-init
> /plugin marketplace add ./git-init
> /plugin install rendercv-resume@jma-plugins
> ```

Verify it loaded with `/plugin` (or `/skills`) — you should see `rendercv-resume`.

## Using it

Ask Claude:

> Create a resume from this job description: *<paste JD>*.
> Here's my background: *<paste resume / LinkedIn / notes>*.

Claude analyzes the job description, maps your real experience to it, writes a
RenderCV YAML file, and runs `rendercv render` to produce a PDF in
`rendercv_output/`. Requires **Python 3.10+** (the plugin installs RenderCV with
`pip install "rendercv[full]"`).

## Use `/rea` in Claude Code on mobile / web

This repo is also set up so cloud sessions (the Claude app on your phone, or
claude.ai/code) get the whole REA toolchain automatically — no plugin install:

- `.claude/commands/rea.md` — the `/rea` slash command
- `.claude/skills/reverse-engineer-anything/` — REA's own skill (vendored, MIT)
- `.mcp.json` — starts the REA MCP server (`npx -y rea-agents@6.7.0 mcp`)
- `.claude/hooks/session-start.sh` — on session start, downloads and SHA-256
  verifies the JADX (decompiler) and Apktool (resources) jars REA needs
- `.claude/settings.json` — enables the hook and the project MCP server

On your phone: open the Claude app → Code → start a session on
`jma47616-maker/git-init`, then type e.g.
`/rea https://f-droid.org/repo/<app>.apk how does sync work?`

Cloud sessions use the repository's default branch, so merge these files into
it first. Cloud sessions have no phone attached, so give the command an
APK/IPA URL or upload; pulling apps over adb works only in local Claude Code.

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json              # this marketplace's catalog
└── plugins/
    ├── rea-mobile/                   # /rea command + REA MCP server
    └── rendercv-resume/              # the plugin
        ├── .claude-plugin/plugin.json
        ├── skills/rendercv-resume/   # the skill (SKILL.md + reference + template)
        └── README.md
```

## Updating

After pushing changes to this repo, users refresh with:

```
/plugin marketplace update jma-plugins
```
