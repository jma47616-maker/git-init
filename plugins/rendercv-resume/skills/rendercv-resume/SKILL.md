---
name: rendercv-resume
description: >-
  Create a professional, ATS-friendly resume/CV tailored to a specific job
  description, producing output in the exact RenderCV format
  (https://github.com/rendercv/rendercv) and rendering it to a polished PDF.
  Use this whenever the user wants to build, tailor, or generate a resume or CV
  from a job posting/description, or asks for a "rendercv" resume.
---

# RenderCV Resume Builder

Generate a job-tailored resume in the **exact RenderCV YAML format** and render it
to a typeset PDF. RenderCV (https://github.com/rendercv/rendercv) reads a CV
written in YAML and produces a PDF with professional typography.

## What you produce

1. A valid RenderCV YAML file (`<Name>_CV.yaml`) tailored to the target job.
2. A rendered PDF (plus HTML/Markdown/PNG) in `rendercv_output/`.

## Workflow

Follow these steps in order.

### 1. Gather inputs

You need two things. Ask for whatever is missing — do not invent facts about the
candidate.

- **Job description** (required): the posting the resume targets.
- **Candidate background** (required): an existing resume, LinkedIn export, or
  free-form notes covering name, contact info, education, work history (with
  dates, companies, titles, locations), projects, skills, and achievements.

If the candidate background is thin, ask targeted follow-up questions rather than
fabricating experience, dates, employers, or metrics. **Never invent credentials.**

### 2. Analyze the job description

Extract and write down (briefly, for your own use):

- The role title and seniority.
- Must-have hard skills, tools, and technologies (exact keywords).
- Key responsibilities and the outcomes the employer cares about.
- Soft skills / domain context.

These keywords drive tailoring and ATS (applicant tracking system) matching.

### 3. Map and tailor

- Match the candidate's real experience to the job's requirements.
- Rewrite `highlights` as **achievement bullets**: start with a strong verb,
  quantify impact where the candidate has real numbers (%, $, scale, latency,
  users), and naturally include the JD's keywords.
- Order sections and bullets so the most relevant content appears first.
- Keep it truthful: only reframe real experience, never manufacture it.
- Default to a one-page resume for early/mid-career, two pages for senior unless
  the user says otherwise.

### 4. Write the YAML

- Copy `assets/template_CV.yaml` as a starting point and fill it with the
  candidate's tailored content.
- **Default theme: `engineeringresumes`** (clean, ATS-friendly, ideal for
  engineers). Other valid themes: `classic`, `sb2nov`, `moderncv`,
  `engineeringclassic`, `harvard`, `ink`, `opal`, `ember`. Ask only if the user
  has a preference.
- Pick the correct entry type per section. The full schema and every entry type
  (EducationEntry, ExperienceEntry, NormalEntry, OneLineEntry, BulletEntry,
  PublicationEntry, NumberedEntry, ReversedNumberedEntry, TextEntry) is in
  `reference/yaml_schema.md` — read it before writing.
- **A section may contain only ONE entry type.** Do not mix (e.g. you cannot put
  ExperienceEntry and EducationEntry in the same section).
- Dates use `YYYY-MM`, `YYYY`, or `present`. Markdown (`**bold**`, `*italic*`,
  `[link](url)`) works in any text field.
- Keep the `# yaml-language-server: $schema=...` line at the top for editor
  validation.

### 5. Render to PDF

RenderCV requires **Python 3.10+**. Install if needed, then render:

```bash
pip install "rendercv[full]"
rendercv render "<Name>_CV.yaml"
```

Outputs land in `rendercv_output/` (`.pdf`, `.html`, `.md`, `.png`, `.typ`).

To scaffold a brand-new starter file instead of using the template:

```bash
rendercv new "Full Name"
```

### 6. Deliver

- Report the path to the generated PDF.
- Summarize how the resume was tailored to the job (which keywords/skills you
  emphasized) so the user can sanity-check it.
- Offer to adjust theme, length, or emphasis.

## Notes

- If `rendercv render` fails, the error almost always points to a YAML schema
  issue (wrong entry type in a section, bad date format, mismatched fields).
  Re-check against `reference/yaml_schema.md`.
- The first PDF render downloads Typst font packages (e.g. `fontawesome`) from
  `packages.typst.org`. If you see `failed to download package ... status code
  403/timeout`, the environment is blocking that host — validation and the
  `.typ` file still succeed, so deliver the YAML and have the user run
  `rendercv render` on a machine with normal network access (it caches packages
  after the first successful run).
- If network/PDF rendering is unavailable in the environment, still deliver the
  complete, valid YAML file and give the exact `rendercv render` command to run
  locally.
