# Creative Coding 2 book

This repository holds the source of **Creative Coding 2**, the second-year
sequel to the Creative Coding course (`~/github/ddp-first/ts-ddp-first`). The
first year taught TypeScript with p5.js; this year teaches TypeScript with
HTML, CSS, and SVG, and uses the browser's DOM as the on-ramp to
object-oriented programming. Chapters are Quarto Markdown (`*.qmd`) in the
numbered part folders, and `quarto render` turns them into an HTML book and one
PDF handout. The planned outline is `book-structure.md`.

Students work in VS Code from day one, starting every project from the
[vite-ts-starter](https://github.com/Teaching-HTL-Leonding/vite-ts-starter)
template; from the testing part on they use its sibling
[vite-ts-starter-tests](https://github.com/Teaching-HTL-Leonding/vite-ts-starter-tests),
which adds Vitest and Playwright. Tooling is TypeScript 7, Vite, Vitest,
Playwright, and Biome. The
course teaches fundamentals, not frameworks.

## Writing student-facing prose

Every chapter, and every quiz question and tutor prompt next to it, follows the
`student-technical-writing` skill. Load it before drafting or reviewing any of
them. It calibrates against the audience below.

## Audience

Students age 16 to 17 at Austrian schools who completed the first-year book.

What they bring:

* One year of programming in TypeScript with p5.js: variables and types,
  `if`/`switch`, `for`/`while` loops, arrays, functions with parameters and
  return values, simple object literals and compound types, value vs.
  reference semantics. They have used VS Code, npm, and the Vite starter in the
  last part of year one.
* No HTML, CSS, SVG, or DOM knowledge beyond what the first book touched. No
  classes, no inheritance, no generics, no data structures, no testing.
* English is their second language. Short sentences and common words keep them
  reading; an idiom or a cultural joke costs more than it gives.
* Their school teaches British English, which is exactly why American spelling
  needs an explicit pass in every draft.

What that means for the text:

* **Build on year one, teach everything new.** A loop or a function needs no
  re-teaching, a short reminder is enough. An element, a selector, an event, a
  class, or a test is new and gets taught as its own idea, one at a time.
* **Encourage.** Tell them what to do, not only what to avoid.

## Not a reference

The book names concepts, APIs, technologies, and standards (a "pointer", the
DOM, `querySelectorAll`, SVG `viewBox`, `describe`/`it`) and explains the
*idea* behind them. It never becomes a reference for them: no parameter lists,
no method tables, no "the complete list of events". Students are sixteen and
old enough to research, and learning to research is a course goal. Whenever a
chapter would start listing what MDN already lists, it stops and points the
reader to MDN, a search engine, or their AI tutor or coding buddy instead.

The `::: {.research quiz="<key>" title="..."}` div (extension
`_extensions/research`) marks the spots where the book deliberately stops
explaining. A **research quiz** on Novedu drives the task: its questions are
exactly what the book leaves out, and the student answers what they know,
researches what they don't, and returns until every question is answered.
The contract:

* The exercise that follows **needs** what the quiz asks, and the prose after
  the box never supplies it. A research box whose answers appear two
  paragraphs later trains skipping.
* The box's body is framing only: why the next step needs this, and which
  part must stick for the exam (no internet, no AI). The questions live in the
  quiz YAML (`<chapter>-research-quiz.yaml`, registered under `quizzes:` in
  `ddp-activities.yaml`), written to the `writing-quizzes` skill with one
  twist: each question's evaluation rewards naming the source, and its
  feedback points to where on MDN (or in which docs) the answer lives.
* Three to five questions, each answerable from one MDN page or one focused
  search.

Aim for one research box in most chapters, never more than two.

## Experiments before theory

Every chapter opens with something to type and watch, and names the concept
afterwards. Setup, tooling, git, research, and the coding buddy are short
chapters placed exactly where an experiment first needs them, never a block of
theory at the front of a part.

## Exercises and linear reading

Students meet an exercise's starter code only when an exercise step tells them
to create or open it. A chapter runs the experiment first, names the concept,
and the exercise steps then point back to it. Never ask the reader to look at,
change, or judge code that is not in front of them at that point.

Every exercise starts from a fresh copy of the general starter. Exercises that
need more (HTML, CSS, base classes, half-written tests) keep those files in
`exercises/<name>/` in this repo, and the chapter places `{{< exercise <name> >}}`
(`tests=true` for the tests starter) where the student should create the app;
the shortcode lists the files and their target paths itself, so never write
that instruction by hand. Each exercise must be fully specified from the chapter and those
files alone: the book is tested by letting a smaller LLM work through it, so an
exercise that needs unstated knowledge, a file that is not there, or a teacher
in the room is a bug.

## No micro-management

Students are sixteen and in their second year; the book trusts them with the
routine.

* Creating a project is explained once, in chapter 1.1 (link, ZIP, `npm
  install`, `npm start`), and repeated in one short form with the link in
  2.1. From then on every chapter says "Create a new app from our template"
  (plus a folder name or `coursework/`/`homework/` when later steps refer to
  it) and nothing more: no link, no `npm install`, no `npm start`. "Run `npm
  start`" appears only where the step is about looking at the result.
* Never tell students to write a prediction or an observation "on paper" or
  to "write down" what they see. "Predict what the console shows" or "compare
  what the paragraph shows now" is enough. Writing something down is asked
  for only when the written text *is* the deliverable (explaining an agent's
  code line by line, the research guide).

## No glossary

There is no glossary and no definitions page. Never write `[[term]]` markers or
link a term to a definition. A term gets its explanation the first time it
matters, in the sentence where it appears.

## Links

Link text is descriptive and makes sense on its own, never "click here" or a
bare URL. Quizzes, tutors, exercise files, and the coding buddies are linked
through the book's shortcodes (`{{< quiz >}}`, `{{< tutor >}}`,
`{{< writing >}}`, `{{< exercise >}}`, `{{< coding >}}`), never by pasted URL.
A `writing` activity (extension `_extensions/writing`, registry group
`writing`) is a reflection the student drafts next to an AI coach that reads
but never edits; it is not anonymous.

## The coding buddy

Students use the `pi` coding agent all year, connected to one Novedu coding
activity **per part**, so generated code never runs ahead of the book:
`ddp-coding-buddy-dom.yaml` (Part 2), `-svg` (Part 3), `-classes` (Part 4),
`-tests` (Part 5), `-generics` (Part 6), `-data-structures` (Part 7), and `-e2e`
(Part 8). Text that two or more of them share lives in
`ddp-tutor-fragments.yaml`. Each level file names the cumulative toolbox the
student has and an explicit "not yet" list of what the later parts teach; the
model never detects the level and never asks which part the student is in.

When a chapter introduces a construct or changes a convention, update that
part's level file in the same edit (the fragment instead, when the rule is
shared), then validate with `npx @novedu/cli validate <file> --kind coding`.

Every chapter that opens a part from Part 3 on carries two or three sentences
of framing right after the intro paragraph, followed by that part's box:
`{{< coding coding-buddy-svg >}}` and its siblings. The setup procedure itself
stays in 1.2, and so does the file the student edits, so the framing points at
`@sec-buddy-setup-new-part` instead of repeating it. Chapter 1.2 is the only
place that covers the agent setup: it points students to pi.dev for the
installation (the book never prints install commands, because they age fast)
and shows `models.json` and `auth.json`; other agents such as little-coder or
opencode are allowed there, but every command the book shows is a `pi` command.

The activity code is **not** an API key. It opens the buddy's page on Novedu,
where the student signs in with their school account and the page mints them a
personal `nvk-` key for their tool. That is why a code is printed in the book at
all, through the shortcode and never as a pasted URL. The key is personal and
never printed anywhere. Two standing rules travel with every box, so they live
in `_extensions/coding/coding.lua` as fixed body text and no chapter repeats
them: a code pasted into a coding agent earns an opaque 401 with no hint, and
asking for a key is recorded with the student's name (the conversations
themselves are never stored). Access ends when the code's availability window
closes; there is no per-student revocation.

## Related skills

* `svgbob` for every diagram: edit the `.bob` file, then regenerate its sibling
  `.svg`.
* `writing-quizzes` for the quiz YAML and its golden-answer evals.
