# rendercv-resume — Claude Code Plugin

A [Claude Code](https://claude.com/claude-code) plugin that builds a professional,
ATS-friendly resume **tailored to a specific job description** and renders it to a
polished PDF using [RenderCV](https://github.com/rendercv/rendercv).

It produces output in RenderCV's exact YAML format and runs `rendercv render`
to generate the final PDF (plus HTML/Markdown/PNG).

## What's in this plugin

```
rendercv-resume/
├── .claude-plugin/
│   └── plugin.json                       # plugin manifest
├── skills/
│   └── rendercv-resume/
│       ├── SKILL.md                      # the workflow Claude follows
│       ├── reference/yaml_schema.md      # full RenderCV YAML schema + entry types
│       └── assets/template_CV.yaml       # starter template (engineeringresumes)
└── README.md                             # this file
```

## Install

From the marketplace that hosts it:

```
/plugin marketplace add jma47616-maker/git-init
/plugin install rendercv-resume@jma-plugins
```

(If the plugin is on a non-default branch, add it from a local clone instead —
see the repository root [README](../../README.md).)

## Use it

Ask Claude:

> Create a resume from this job description: *<paste JD>*.
> Here's my background: *<paste resume / LinkedIn / notes>*.

Claude will:
1. Analyze the job description for required skills and keywords.
2. Map your real experience to the role and write achievement-focused bullets.
3. Generate a RenderCV YAML file.
4. Run RenderCV to produce a PDF in `rendercv_output/`.

You need **Python 3.10+**. The skill installs RenderCV with:

```bash
pip install "rendercv[full]"
```

## Credit

Built on top of the open-source [RenderCV](https://github.com/rendercv/rendercv)
project, which does the actual typesetting.
