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
explaining. A **research quiz** on novedu drives the task: its questions are
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

## No glossary

There is no glossary and no definitions page. Never write `[[term]]` markers or
link a term to a definition. A term gets its explanation the first time it
matters, in the sentence where it appears.

## Links

Link text is descriptive and makes sense on its own, never "click here" or a
bare URL. Quizzes, tutors, and exercise files are linked through the book's
shortcodes (`{{< quiz >}}`, `{{< tutor >}}`, `{{< exercise >}}`), never by
pasted URL.

## The coding buddy

Students use the `pi` coding agent all year, connected to the novedu coding
activity `ddp-coding-buddy.yaml`. Its instructions carry the course coding rules
and a "ladder" of book parts so generated code stays at the student's level.
When a chapter introduces a construct or changes a convention, update the
ladder or the rules in that file in the same edit, then validate it with
`npx @novedu/cli validate ddp-coding-buddy.yaml --kind coding`. The activity code
is an API key and is never printed in a chapter.

## Related skills

* `svgbob` for every diagram: edit the `.bob` file, then regenerate its sibling
  `.svg`.
* `writing-quizzes` for the quiz YAML and its golden-answer evals.
