# RenderCV Resume Skill

This repository contains a shareable **Claude Code skill** that creates a
professional, ATS-friendly resume tailored to a job description and renders it to
a polished PDF using the open-source [RenderCV](https://github.com/rendercv/rendercv)
project.

## The skill

📁 [`.claude/skills/rendercv-resume/`](.claude/skills/rendercv-resume/) — see its
[README](.claude/skills/rendercv-resume/README.md) for full details.

## Quick start

1. Open this repo in [Claude Code](https://claude.com/claude-code) (the skill is
   auto-discovered from `.claude/skills/`).
2. Make sure Python 3.10+ is installed.
3. Ask Claude:

   > Create a resume from this job description: *<paste JD>*.
   > Here's my background: *<paste resume / LinkedIn / notes>*.

Claude analyzes the job description, maps your real experience to it, writes a
RenderCV YAML file, and runs `rendercv render` to produce a PDF in
`rendercv_output/`.

## Sharing the skill

Send someone this repo (or just the `rendercv-resume` folder) and have them drop
it into `~/.claude/skills/` (personal) or any project's `.claude/skills/` folder.
Claude Code discovers it automatically. Verify with `/skills`.
