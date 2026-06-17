# rendercv-resume — Claude Code Skill

A shareable [Claude Code](https://claude.com/claude-code) skill that builds a
professional, ATS-friendly resume **tailored to a specific job description** and
renders it to a polished PDF using [RenderCV](https://github.com/rendercv/rendercv).

It produces output in RenderCV's exact YAML format and runs `rendercv render`
to generate the final PDF (plus HTML/Markdown/PNG).

## What's in this skill

```
rendercv-resume/
├── SKILL.md                    # the skill: workflow Claude follows
├── reference/
│   └── yaml_schema.md          # full RenderCV YAML schema + every entry type
├── assets/
│   └── template_CV.yaml        # starter template (engineeringresumes theme)
└── README.md                   # this file
```

## How to use it (for your friend)

Once installed (see below), just ask Claude Code something like:

> "Create a resume from this job description: <paste JD>. Here's my background: <paste resume / LinkedIn / notes>."

Claude will:
1. Analyze the job description for required skills and keywords.
2. Map your real experience to the role and write achievement-focused bullets.
3. Generate a RenderCV YAML file.
4. Run RenderCV to produce a PDF in `rendercv_output/`.

You need **Python 3.10+**. The skill installs RenderCV with:

```bash
pip install "rendercv[full]"
```

## Installing / sharing this skill

This is a **project skill** — it lives in `.claude/skills/` inside this repo, so
anyone who clones the repo gets it automatically when they run Claude Code here.

To use it in **another project** or globally, copy the folder:

```bash
# Personal (available in every project for that user):
cp -r .claude/skills/rendercv-resume ~/.claude/skills/

# Or into another project:
cp -r .claude/skills/rendercv-resume /path/to/other-project/.claude/skills/
```

To share with a friend, send them this repo (or just the `rendercv-resume`
folder) and have them drop it into one of the `.claude/skills/` locations above.
Claude Code auto-discovers any skill in those directories.

## Verifying it's loaded

In Claude Code, run `/skills` (or ask "what skills do you have?"). You should see
`rendercv-resume` listed. Then describe a job and your background to start.

## Credit

Built on top of the open-source [RenderCV](https://github.com/rendercv/rendercv)
project, which does the actual typesetting.
