# Creative Coding 2: course book

The source of **Creative Coding 2**, the second-year course that follows
[Creative Coding](https://github.com/rstropek/ddp-ts-p5-beginner-course). Year one
taught TypeScript with p5.js. This year teaches TypeScript with HTML, CSS, and SVG in
VS Code, and uses the browser's DOM as the on-ramp to object-oriented programming,
generics, dynamic data structures, and automated testing. Audience: students aged 16
to 17 in Austrian schools (English book, German-speaking students).

One `quarto render` produces two outputs from the same sources:

* an HTML book (chapter sidebar, prev/next navigation) in `_output/`
* one combined PDF handout, `_output/Creative-Coding-2.pdf`, laid out for print

The technical setup (Quarto book, shortcodes, Novedu activity registry, authoring
skills, CI) is inherited unchanged from the first-year book. Its README documents the
mechanics in detail; this one only lists what is here.

## Repository layout

| Path | What it is |
| --- | --- |
| `book-structure.md` | The planned outline of parts and chapters |
| `_quarto.yml` | Book definition: chapter order, output formats, Novedu and exercises base URLs |
| `index.qmd` | The preface |
| `AGENTS.md` | The writing contract for anyone (human or agent) who edits a chapter: audience, research-box rules, exercise rules, coding-buddy rules. `CLAUDE.md` is a symlink to it |
| `0010-welcome/`, `0020-dom/`, ... | Book parts. Numbered folders and files: a chapter `.qmd` next to its `<chapter>-quiz.yaml` (the chapter's one quiz, research questions first) and `<chapter>-quiz.eval.yaml` (golden-answer regression cases, teacher-only), a `<chapter>-writing.yaml` where a chapter has a writing activity, and svgbob diagrams as `.bob` plus rendered `.svg` |
| `exercises/<name>/` | Files an exercise needs beyond the general starter (HTML, CSS, base classes, tests). `{{< exercise <name> >}}` lists them; students copy them into a fresh starter-based app |
| `_extensions/` | Quarto extensions: the `quiz`, `tutor`, `writing`, `exercise`, and `coding` shortcodes, and the `research` filter that renders `::: {.research}` divs as "Research task" callouts |
| `ddp-activities.yaml` | The Novedu activity registry: every quiz, writing activity, and coding activity under a stable key (the `tutors` group is empty; this book has no chapter tutors). Hand-written |
| `ddp-activities.lock.yaml` | Generated key → activity code map. Regenerate with `npx @novedu/cli codes sync ddp-activities.yaml`; do not edit |
| `ddp-quiz-fragments.yaml` | Shared Novedu prompt fragments used by every chapter quiz |
| `ddp-tutor-fragments.yaml` | Novedu prompt fragments shared by two or more AI activities, mostly the text the seven coding buddies have in common |
| `ddp-coding-buddy-<part>.yaml` | One Novedu **coding activity** per part (`-dom`, `-svg`, `-classes`, `-tests`, `-generics`, `-data-structures`, `-e2e`): the endpoint students point the `pi` agent at. Each names what its part has taught and forbids what comes later. Validate with `npx @novedu/cli validate <file> --kind coding` |
| `models.json` | The `pi` provider config students copy to `~/.pi/agent/models.json`; included verbatim in the setup chapter. It carries the base URL and the model id, never a key |
| `emoji-pdf.lua`, `pdf-compact.tex`, `styles.css` | PDF emoji substitution, compact print layout, HTML tweaks |
| `.agents/skills/` | Skills for AI agents: `student-technical-writing`, `writing-quizzes`, `svgbob`, `test-exercises` (a small model works through a chapter as a student in a real browser and reports gaps), `delegate-to-pi`, `writing-for-agents`, `skill-creator`. `.claude` is a symlink to it |
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
  template, they live in `exercises/<name>/` here and `{{< exercise <name> >}}` renders
  the copy instructions. The playground-era `example` shortcode is gone.
* The book is tested by letting a smaller LLM work through it, so every exercise
  must be fully specified from the chapter text and its `exercises/` files alone.
* The `base-url` in `ddp-activities.yaml` must point at this repository's public URL
  before the first Novedu activity is minted: `codes sync` fetches each activity file
  from that URL and fails with `FETCH_FAILED` until the repo is pushed.
* There are no chapter tutors. Each chapter has one quiz, and the first questions of
  that quiz are the chapter's research-box questions, so the quiz drives the research
  task. One chapter (the research guide) has a `writing` activity instead: the student
  drafts a text next to an AI coach that reads but never edits.
* One coding activity per part (`ddp-coding-buddy-<part>.yaml`) replaces the
  single tutor endpoint, so generated code never runs ahead of the book. Year one
  has one buddy and prints its code once; here the chapter that opens a part prints
  that part's code, and the student swaps the key behind it into
  `~/.pi/agent/auth.json`. The book ships the rest of the setup (`models.json` and
  the shape of `auth.json`), which year one leaves to the Novedu page.
* `.agents/skills/test-exercises/` is the "smaller LLM" test from the point above,
  packaged: `/test-exercises 4.3` stages the chapter and its exercise files into a
  workspace outside the repo, lets a Sonnet agent build it as a student with
  `playwright-cli`, and returns a report per chapter.

## The coding buddies

Seven Novedu **coding activities**, one per part, sit in `ddp-coding-buddy-<part>.yaml`.
Each is an OpenAI-compatible endpoint that the student's `pi` agent talks to, with that
part's guidelines injected server-side, so the buddy for Part 3 will not write a class
and the buddy for Part 5 will. Everything two or more of them share lives in
`ddp-tutor-fragments.yaml`.

The chapter that opens a part links its buddy by registry key:

```markdown
{{< coding coding-buddy-svg >}}
```

The **code is not an API key**. A student opens `novedu.at/<code>`, signs in with their
school account, and that page mints them a personal `nvk-…` key, stable across visits
and devices, which goes into `~/.pi/agent/auth.json`. That is why a code can be printed
in the book at all, and why the box's fixed body text says the code alone opens nothing:
a code pasted into a coding agent earns an opaque 401 with no hint. That text, and the
notice that requesting a key is recorded with the student's name, live in
`_extensions/coding/coding.lua` rather than in seven chapters.

Access ends when a code's availability window closes, which kills every key issued for
it on the next request. There is no per-student revocation, so the window is the control
a teacher actually has.
