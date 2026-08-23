---
name: test-exercises
description: Let a cheap subagent work through a chapter's experiments and exercises as a student, in a real browser, and turn its report into chapter fixes. Usage: /test-exercises 2.4 (or 2.4 2.5).
disable-model-invocation: true
---

# Test a chapter's exercises

AGENTS.md promises that every exercise is fully specified from the chapter and
its `exercises/<name>/` files alone, "tested by letting a smaller LLM work
through it". This skill is that test. A Sonnet subagent plays the student,
builds each project in a workspace outside the repo, checks every promise the
chapter makes ("it reads `Clicks: 3`") in headless Chrome through
`playwright-cli`, and writes one report per chapter. You are the coordinator
and the skeptic: the student is cheap and literal, which is what makes it a
useful proxy for a beginner, and also what makes its report a draft, never a
verdict.

Chapters are run in order and the workspace persists, because later chapters
reopen earlier projects ("Open your `hello-page` project from Part 1").

## 1. Stage

```bash
.agents/skills/test-exercises/scripts/setup.sh
.agents/skills/test-exercises/scripts/stage.sh 2.4
```

`setup.sh` is idempotent: it creates `~/.cache/creative-coding-2-exercise-tests`
(override with `EXERCISE_TEST_WORKSPACE`), clones both starters, installs
`@playwright/cli` with its skill, and prints the path. `--fresh` wipes the
projects and reports for a restart at 1.1. `stage.sh` resolves a chapter
number positionally (part N is the Nth `NNNN-*/` folder, chapter M its Mth
`.qmd`), copies it to `book/ch-N-M.qmd`, and copies every `{{< exercise >}}`
folder it references into `book/exercises/`. Stage every chapter of the run;
run one or two chapters at a time, so a report stays short enough to judge.

Check `reports/` before launching: a chapter whose predecessor has no report
needs that predecessor first, or the project the chapter reopens does not
exist.

## 2. Launch the student

Spawn one `Agent` with `model: "sonnet"` and wait for it (`run_in_background:
false`; a chapter takes about ten minutes and ~100k tokens). The prompt:

```
Read the file <repo>/.agents/skills/test-exercises/assets/brief.md and follow
it exactly. WORKSPACE = <workspace path from setup.sh>

This run: work through `book/ch-2-4.qmd` (Types for elements) [and then
`book/ch-2-5.qmd` (...)], in that order. Earlier chapters were done in a
previous run; their projects are in `work/`. Write `reports/ch-2-4.md`
[and `reports/ch-2-5.md`].

Before any command, prepend the tool path: run commands as
`export PATH=<workspace>/tooling/node_modules/.bin:$PATH && cd <project folder> && <command>`
(shell state does not persist between commands, so repeat the export every
time). Kill every dev server you started before you finish.

Do not read anything under <repo>. Your whole world is the WORKSPACE folder.
```

The brief is the student's whole contract: persona with the year-one
knowledge list, linear reading, mandatory browser checks, the research-box
rule, and the report format. Change the brief, not the prompt, when a run
shows the student needs a different rule.

## 3. Judge the report

Read the report and the code the student left in `work/<project>/`. The
report is correct about what the student *did* and unreliable about what it
*means*. Sort every finding into one of these before touching a chapter:

* **By design.** "The chapter does not explain X" where X is a research-box
  question, or a construct year one taught. The research box exists to stop
  explaining; see the contract in AGENTS.md. Drop the finding.
* **Tooling artifact.** A "wrong promise" about the page, the console, or the
  terminal from a student that never loaded the page. Check the subagent
  transcript (`~/.claude/projects/<project>/<session>/subagents/agent-<id>.jsonl`)
  for how often `playwright-cli` ran and whether it hit an error page. A
  student that skipped the browser turns its own gap into a chapter finding.
* **Factual claim.** "The terminal does not print the line the chapter
  quotes." Reproduce it yourself in the workspace (start the server, do the
  step, load the page with `playwright-cli`, read `server.log`) before you
  edit. One run so far had exactly such a claim, and the chapter was right.
* **Real gap.** An `invented` step, a leap the chapter did not prepare, a
  file the shortcode does not list, wording two readings fit. These are the
  bugs the test exists for.

Three things a student model is bad at: it under-reports (a clean "yes" on a
chapter you know is hard means the reporter missed it, not that the chapter
is fine), it drifts into praise, and it rates a step `done` that it never
verified. The `transfer` column is its most honest signal: `invented` rows
mark where a real student has to think.

Sonnet is the default worker because of how the two behaved on
neighboring chapters of Part 2: Haiku (~80k tokens, six minutes) skipped the browser almost
entirely and reported only research-box questions as gaps; Sonnet (~105k
tokens, ten minutes) ran 80 browser commands, reproduced a compiler error in
an isolated file before reporting it, and found the one real gap (a
`switch` that needs a `default` branch). The 25 % extra cost buys the
report you can act on. Haiku remains the cheaper proxy when the question is
only "can a weak reader follow the steps", not "is the chapter complete".

## 4. Fix and record

Edit the chapter for every real gap, following the `student-technical-writing`
skill and the rules in AGENTS.md (research boxes ask what the book never
answers; no micro-management). Render the chapter, commit. The workspace keeps
the student's projects for the next chapter; the reports are the record of
what was tested, so leave them in place until a `--fresh` restart.

A run can also find a hole in the brief. Two examples already fixed: the
student skipped browser checks and had to be told that `not-verified` is a
status; it treated research boxes as missing explanations and had to be told
what the box is. Fold such lessons into `assets/brief.md`, not into the
prompt of a single run.
