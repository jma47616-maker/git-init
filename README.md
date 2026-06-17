# jma-plugins — Claude Code Plugin Marketplace

A [Claude Code](https://claude.com/claude-code) plugin marketplace. It currently
hosts one plugin:

- **rendercv-resume** — create an ATS-friendly resume tailored to a job
  description in the exact [RenderCV](https://github.com/rendercv/rendercv)
  format and render it to a polished PDF.

## Install (for your friend)

In Claude Code, add this marketplace, then install the plugin:

```
/plugin marketplace add jma47616-maker/git-init
/plugin install rendercv-resume@jma-plugins
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

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json              # this marketplace's catalog
└── plugins/
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
