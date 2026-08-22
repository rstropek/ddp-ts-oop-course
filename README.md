# Creative Coding 2 — course book

The source of **Creative Coding 2**, the second-year course that follows
[Creative Coding](https://github.com/rstropek/ddp-ts-p5-beginner-course). Year one
taught TypeScript with p5.js. This year teaches TypeScript with HTML, CSS, and SVG in
VS Code, and uses the browser's DOM as the on-ramp to object-oriented programming,
generics, dynamic data structures, and automated testing. Audience: students aged 16
to 17 in Austrian schools (English book, German-speaking students).

One `quarto render` produces two outputs from the same sources:

* an HTML book (chapter sidebar, prev/next navigation) in `_output/`
* one combined PDF handout, `_output/Creative-Coding-2.pdf`, laid out for print

The technical setup (Quarto book, shortcodes, novedu activity registry, authoring
skills, CI) is inherited unchanged from the first-year book. Its README documents the
mechanics in detail; this one only lists what is here.

## Repository layout

| Path | What it is |
| --- | --- |
| `book-structure.md` | The planned outline of parts and chapters |
| `_quarto.yml` | Book definition: chapter order, output formats, novedu base URL |
| `index.qmd` | The preface |
| `0010-welcome/`, `0020-dom/`, ... | Book parts. Numbered folders and files: a chapter `.qmd` next to its `<chapter>-quiz.yaml` and images, plus the part's `*-tutor.yaml` |
| `exercises/<name>/` | Files an exercise needs beyond the general starter (HTML, CSS, base classes, tests). Students copy them into a fresh starter-based app |
| `_extensions/` | Quarto extensions: the `example`, `playground`, `quiz`, and `tutor` shortcodes, and the `research` filter that renders `::: {.research quiz="<key>"}` divs as "Research task" callouts linking to the research quiz that drives the task |
| `ddp-activities.yaml` | The novedu activity registry: every quiz and tutor under a stable key. Hand-written |
| `ddp-activities.lock.yaml` | Generated key → activity code map. Regenerate with `npx @novedu/cli codes sync ddp-activities.yaml`; do not edit |
| `ddp-quiz-fragments.yaml` | Shared novedu prompt fragments used by every chapter quiz |
| `ddp-tutor-fragments.yaml` | Novedu prompt fragments shared by two or more tutors or the coding buddy (today: the teenager-safety rule) |
| `ddp-coding-buddy.yaml` | The one novedu **coding activity** of the year: the endpoint students point the `pi` agent at. Validate with `npx @novedu/cli validate ddp-coding-buddy.yaml --kind coding` |
| `models.json` | The `pi` provider config students copy to `~/.pi/agent/models.json`; included verbatim in the coding-buddy chapter |
| `emoji-pdf.lua`, `pdf-compact.tex`, `styles.css` | PDF emoji substitution, compact print layout, HTML tweaks |
| `.agents/skills/` | Authoring skills for AI agents (`student-technical-writing`, `writing-quizzes`, `svgbob`, ...). `.claude` is a symlink to it |
| `.github/workflows/` | CI: renders the book and uploads the PDF and the zipped website |
| `_output/`, `.quarto/` | Build output. Git-ignored |

Chapters are ordered by the `book.chapters` list in `_quarto.yml`, not by file name.

## Building the book

```bash
quarto render          # both formats into _output/
quarto preview         # live-reloading HTML while writing
```

You need Quarto (CI pins the version), a LaTeX distribution (TinyTeX is fine) for the
PDF, and `rsvg-convert` so SVG diagrams survive the LaTeX pass.

## Differences to year one

* Exercises are not hosted in the web playground. Students clone the
  [vite-ts-starter](https://github.com/Teaching-HTL-Leonding/vite-ts-starter) and work in
  VS Code; from the testing part on, the
  [vite-ts-starter-tests](https://github.com/Teaching-HTL-Leonding/vite-ts-starter-tests)
  variant with Vitest and Playwright. Where an exercise needs files beyond the
  template, they live in `exercises/<name>/` here and the chapter says which to copy.
  The `example`/`playground` shortcodes are kept for now but may be replaced.
* The book is tested by letting a smaller LLM work through it, so every exercise
  must be fully specified from the chapter text and its `exercises/` files alone.
* The `base-url` in `ddp-activities.yaml` must point at this repository's public URL
  before the first novedu activity is minted: `codes sync` fetches each activity file
  from that URL and fails with `FETCH_FAILED` until the repo is pushed.
* One coding activity (`ddp-coding-buddy.yaml`) serves the whole year. Its code is an
  API key, so the book ships the setup (`models.json`, the shape of `auth.json`) and the
  teacher hands the code out in class; the code never appears in a chapter.
