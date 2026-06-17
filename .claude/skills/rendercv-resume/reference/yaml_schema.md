# RenderCV YAML Schema Reference

This is the structure RenderCV expects. The file has four top-level keys:
`cv`, `design`, `locale`, and `settings`. Only `cv` and `design` are usually
needed; `locale` and `settings` can be omitted to use defaults.

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/rendercv/rendercv/refs/tags/v2.8/schema.json
cv:
  name: Full Name
  headline:                      # optional, e.g. "Software Engineer"
  location: City, Country
  email: name@email.com
  phone: tel:+1-555-555-5555     # optional, must start with tel:
  website: https://example.com   # optional
  photo:                         # optional path to an image
  social_networks:               # optional
    - network: LinkedIn          # LinkedIn, GitHub, GitLab, Instagram, ORCID,
      username: handle           #   Mastodon, StackOverflow, ResearchGate,
    - network: GitHub            #   YouTube, Google Scholar, Telegram, X
      username: handle
  sections:
    <Any Section Title>:         # title is arbitrary; becomes the heading
      - <entries of ONE type>    # all entries in a section share one type

design:
  theme: engineeringresumes      # see themes list below
```

## Critical rules

- **Each section holds exactly ONE entry type.** Mixing types in a section is an
  error.
- Section titles are free text (`experience`, `Work History`, `Selected Honors`…).
  They are shown verbatim as the heading (with theme-defined capitalization).
- Dates: `YYYY-MM-DD`, `YYYY-MM`, `YYYY`, or `present`. Omit `start_date`/`end_date`
  to hide the date.
- Markdown is supported in every text field: `**bold**`, `*italic*`,
  `[text](https://url)`.

## Themes

`classic`, `engineeringresumes`, `sb2nov`, `moderncv`, `engineeringclassic`,
`harvard`, `ink`, `opal`, `ember`. Default for engineers: **engineeringresumes**.

---

## Entry types

### EducationEntry
For schools/degrees.

```yaml
education:
  - institution: Princeton University
    area: Computer Science
    degree: PhD                  # optional, short (BS, MS, PhD)
    location: Princeton, NJ      # optional
    start_date: 2018-09          # optional
    end_date: 2023-05            # optional ('present' allowed)
    highlights:                  # optional, list of bullets
      - 'GPA: 3.9/4.0'
      - 'Thesis: ...'
```

### ExperienceEntry
For jobs/roles.

```yaml
experience:
  - company: Nexus AI
    position: Senior Software Engineer
    location: San Francisco, CA  # optional
    start_date: 2023-06          # optional
    end_date: present            # optional
    highlights:                  # optional, list of achievement bullets
      - Built X serving 2M+ requests/month at 99.97% uptime
      - Reduced latency by 73% via inference optimization
```

### NormalEntry
For projects, awards, or anything with a name + summary + highlights.

```yaml
projects:
  - name: '[FlashInfer](https://github.com/...)'   # markdown link allowed
    location: Remote             # optional
    start_date: 2023-01          # optional
    end_date: present            # optional
    summary: High-performance LLM inference kernels   # optional
    highlights:                  # optional
      - 2.8x speedup over baseline on A100 GPUs
      - 8,500+ GitHub stars, 200+ contributors
```

### OneLineEntry
For skills or anything that is "label: details" on one line.

```yaml
skills:
  - label: Languages
    details: Python, C++, Go, Rust
  - label: Frameworks
    details: PyTorch, React, Django
```

### BulletEntry
A simple bullet list.

```yaml
selected_honors:
  - bullet: Forbes 30 Under 30 (2024)
  - bullet: Best Paper Award, ICLR 2021
```

### NumberedEntry
A numbered (1. 2. 3.) list.

```yaml
key_results:
  - number: Shipped feature used by 1M+ users
  - number: Cut build times by 40%
```

### ReversedNumberedEntry
A reverse-numbered list (useful for talks/publications counted from newest).

```yaml
invited_talks:
  - reversed_number: Scaling Laws for Inference — Stanford HAI (2024)
  - reversed_number: Building AI Infrastructure — TechCrunch Disrupt (2024)
```

### PublicationEntry
For academic publications.

```yaml
publications:
  - title: 'Sparse Mixture-of-Experts at Scale'
    authors:
      - '*John Doe*'             # *italic* to emphasize the candidate
      - Sarah Williams
    doi: 10.1234/neurips.2023.1234   # optional (or use 'url:')
    journal: NeurIPS 2023            # optional
    date: 2023-07                    # optional
```

### TextEntry
Plain free-text paragraphs (e.g. a summary section). Just a list of strings.

```yaml
Summary:
  - "Senior engineer with 8 years building distributed systems..."
  - "Markdown **works** here too."
```

---

## Optional: locale and settings

```yaml
locale:
  language: english

settings:
  current_date: today
  bold_keywords: []
  pdf_title: NAME - CV
```

## Optional: design customization

Most users only set `theme`. For finer control, the `design` block accepts
theme-specific options (page size, margins, colors, fonts, section spacing).
Start from the theme defaults and only override what the user asks for. The full
authoritative schema is the JSON Schema referenced at the top of every YAML file
and the docs at https://docs.rendercv.com/.
