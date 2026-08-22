# Creative Coding 2 — proposed book structure

Working proposal for discussion. The guiding ideas, taken from `prompt.md` and from
what worked last year:

* **The DOM is the on-ramp to OOP.** Students meet objects, identity, collections,
  and events by using the browser's objects long before they write `class`.
* **CSS is learned by doing, selectors are taught.** Every chapter styles something;
  no chapter is "the CSS chapter". Selectors get real teaching time because they are
  the "query a collection of objects" idea.
* **Spiral assessment.** Like last year, the same skills come back in bigger tasks
  (bracelet → train builder → undo → hairdresser). Previous exams become exercises.
* **Three threads run through the whole book** instead of getting one chapter each:
  CSS, the project toolchain (package.json, tsconfig, Biome, scripts), and working
  with AI agents (AGENTS.md, skills). Each part has at least one chapter that moves
  each thread one step forward.
* **The book is not a reference.** It names and motivates concepts, APIs, and
  standards, and then sends students to MDN, a search engine, or their AI
  tools. When a chapter outline below lists APIs, that is what the chapter
  *names and uses*, not what it documents. Most chapters carry one
  **research task** (a `::: {.research quiz=...}` box) driven by a novedu
  research quiz: the student reads a question, answers it if they can,
  researches if they can't, and repeats until every question is answered. The
  exercise after the box needs those answers, and the book never supplies
  them. Research tasks marked 🔎 below are examples, not the final set.
* **Testing arrives in two steps.** Unit tests (Vitest) as soon as there is logic
  worth testing outside the DOM (Part 5, classes), e2e tests (Playwright) once
  students build apps with real UI flows (Part 8).

Chapter conventions stay as in year one: goal image, AI tutor box, concept first,
then exercise steps, then "check your understanding" quiz. Exercises are no longer
playground links. Parts 1–4 start every exercise from a copy of
[`vite-ts-starter`](https://github.com/Teaching-HTL-Leonding/vite-ts-starter); from
Part 5 on, students switch to
[`vite-ts-starter-tests`](https://github.com/Teaching-HTL-Leonding/vite-ts-starter-tests),
the same template plus Vitest (`src/*.test.ts`, `npm test`) and Playwright
(`e2e/*.e2e.ts`, `npm run test:e2e`, with a `webServer` entry that starts Vite on
port 4173). Its `math.ts` / `math.test.ts` / `add.e2e.ts` trio is the smallest
possible example of both test kinds and is the worked example of 5.2 and 8.1.

Material legend: **[LY]** = last year's course repo, **[EX]** = exam from
`htl-csharp-private`, **[NEW]** = to be written.

---

## Part 1 — Welcome back to the workshop

Short. Students used VS Code and npm at the end of year one, so this part re-seats
them and then explains the parts of the project they "accepted as magic" last year.

### 1.1 From canvas to page [NEW]
* What changed: p5.js painted pixels on a canvas; now the browser builds a page
  out of elements, and TypeScript talks to the page.
* Same language, new world: a two-column "what you know / what is new" table
  (variables, loops, functions, arrays vs. elements, selectors, events, classes).
* How this book works: VS Code only, starter template, quizzes, AI tutors, and the
  exam rule "no internet, no AI, but the course material is allowed".
* The AI policy of this course (reuse last year's readme text): use agents to get
  unstuck, be able to explain every line, practise without them before exams.

### 1.2 Research is part of the job [NEW; replaces year one's "reading docs" chapters]
* Why this book stops explaining: the job is knowing how to find out, and the
  exam is about what stuck.
* The three sources and what each is good for: MDN (the truth about the web
  platform, how a reference page is organized), a search engine (error
  messages, "how do I" questions, the age of a result), an AI (explanations at
  your level, but verify against MDN; how to ask a precise question).
* How a research task in this book works: the quiz drives you. Open it, read
  a question, answer or go find out, come back, repeat until done.
* 🔎 First research task: find on MDN what `textContent` and `innerHTML` do
  differently, and ask an AI the same question; note one thing one source said
  that the other didn't.

### 1.3 The starter project, file by file [NEW, based on vite-ts-starter]
* Clone/download `vite-ts-starter`, `npm install`, `npm start`; what `node_modules`
  is and why it is not in git.
* `index.html` is the entry point and the `<script type="module">` line is the
  bridge to `src/index.ts`.
* `package.json`: name, `scripts` (what `npm start`, `build`, `check` actually
  run), `devDependencies`, and the `^` in version numbers.
* `tsconfig.json`: reading it as a list of promises the compiler makes for you.
  Explain the four strict options students will actually hit
  (`noUncheckedIndexedAccess`, `noUnusedLocals`, `noImplicitReturns`,
  `exactOptionalPropertyTypes`) with a one-liner example each.
* `biome.json`: linter vs. formatter; `npm run check` and `check:fix`; the VS Code
  extension; "format on save".
* `.vscode/`, `.gitignore`, `assets/`; the `.agents/skills` folder gets a teaser
  only (full treatment in 1.4).
* Exercise: break the project on purpose three times (remove the script tag, rename
  `index.ts`, use an unused variable) and read the three different error messages.

### 1.4 Git and your course repository [NEW]
* Last year's required repo layout (`coursework/`, `homework/`, `projects/`) and
  why a clean repo is part of the grade.
* The daily loop: `git add`, `commit`, `push`; reading `git status`; the role of
  `.gitignore` (never commit `node_modules`, `dist`).
* Exercise: create the course repo, copy the starter into
  `coursework/<date>-hello`, commit and push.

### 1.5 Your coding buddy: pi on novedu [NEW, drafted as 0010-welcome/0010-coding-buddy.qmd]
* Recap from year one: asking an AI for help vs. letting an agent edit files.
* Install `pi`, copy the book's `models.json` to `~/.pi/agent/`, put the
  activity code from the teacher into `auth.json`, first run in the starter.
* What the buddy knows (the course rules, the "ladder" of book parts) and the
  two rules that never change: you must be able to explain every line, and its
  mistakes are yours. Same novedu coding-activity mechanism as the
  harness-engineering book for the older students.
* `AGENTS.md`/`CLAUDE.md`: a file that tells the agent the rules of *this* project
  (the starter gets one; students read it and add two rules of their own, e.g.
  "no `any`", "always run `npm run check`").
* Skills: `.agents/skills/find-docs` is in the starter. What a skill is (a
  markdown file with instructions the agent loads when it fits), how the agent
  picks it, and when it is better than searching the web.
* Exercise: ask the agent, with and without the `find-docs` skill, what
  `noUncheckedIndexedAccess` does, and compare the answers.
* The buddy answers questions but points to the source; research tasks are
  still the student's.
* This chapter seeds the "harness engineering" thread; 3.6, 5.3, and 8.3 build on
  it.

---

## Part 2 — The DOM: a page full of objects

Goal of the part: students can read and change a page through its objects and can
react to events. Everything is still procedural (functions, no classes). This is
where the vocabulary of OOP gets introduced *by use*: object, property, method,
identity, reference.

### 2.1 Elements are objects [LY 10-dom, rewritten]
* HTML recap in ten lines: tags, attributes, nesting; the five elements used in
  this part (`h1`, `p`, `button`, `input`, `div`).
* The browser builds a tree of objects from the HTML: the DOM. svgbob diagram of
  `document → html → body → ...`.
* `document.getElementById` gives you *the* object, not a copy: change
  `textContent` and the page changes. Link back to year one's value vs. reference
  chapter. Object identity made visible: two variables, one element.
* The DevTools elements panel as a live view of the same tree.
* Exercise: "Hello again" — starter code's `helloWorldHeader`, then a paragraph
  that shows the current date, then a button that says how often it was clicked.

### 2.2 Events: the page talks back [LY 10-dom]
* `addEventListener("click", ...)`: the browser calls *your* function later.
  Compare with p5.js `mousePressed()`, which students know; the difference is that
  now every element can have its own handler.
* Arrow functions as handler (year one used named functions; arrow functions get a
  proper introduction here).
* The `event` object: `event.target`, `clientX/Y`, `key` for `keydown`.
* `element.style.*` and the first CSS touch: change a background color from code.
* Exercise: click counter, color box that cycles colors, keyboard echo.

### 2.3 Types for elements [NEW, merges the `as` casts LY used without explaining]
* `getElementById` returns `HTMLElement | null`: why `null` is in there and what
  to do about it (`if (!el) throw ...` vs. `!`); connects to 4.6 exceptions.
* `HTMLButtonElement`, `HTMLInputElement`, `HTMLHeadingElement`: the first time
  students see that one type can be a more special version of another. Plant the
  word *inheritance* here, as last year's selectors lesson did, without teaching it.
* `querySelector<HTMLInputElement>("#name")` instead of `as` casts.
* `input.value` is always a string; `Number()`, `parseInt`, `Number.isNaN`.
* Exercise: two-operand calculator with a `<select>` for the operator, division by
  zero error message [LY homework 10-simple-calculator].

### 2.4 Creating elements [LY 10-dom, 20-svg]
* `document.createElement`, `append`, `remove`, `innerHTML` (and why we prefer
  `textContent` for user input).
* Building a list from an array with a loop: the array-of-data → elements-on-page
  pattern that returns in every later project.
* `classList.add/remove/toggle` with a first real stylesheet: `import "./styles.css"`
  in Vite, a `.done` class, `:hover`.
* 🔎 Research: `classList` has more than `add` and `remove`; find the method
  that flips a class and the one that answers whether a class is set.
* Exercise: to-do list (add, mark done, delete). Bonus: count of open items.

### 2.5 Selectors: asking for collections [LY 30-selectors, strongest chapter of the part]
* One selector language, two users: CSS rules and `querySelector(All)`.
* `#id`, `.class`, `tag`, `tag.class`, descendant `a b` vs. `a.b`, `:hover`,
  `:nth-child`, attribute selectors `[type="checkbox"]`.
* `querySelectorAll` returns a `NodeList`: `for...of`, `forEach`, `Array.from`,
  `.length`; "a collection of objects" as the second OOP idea.
* 🔎 Research: what `querySelectorAll` returns, whether it changes when the page
  changes, and how to turn it into an array (replaces LY advanced_NodeList.md).
* Exercise: given a blog page, select and style; then from TypeScript, count and
  toggle all paragraphs with class `highlight`.

### 2.6 CSS by doing: layout with Flexbox and Grid [NEW; replaces LY's float lesson]
* The box model in one figure (content, padding, border, margin).
* Flexbox for rows and columns, `gap`, `justify-content`, `align-items`.
* Grid for boards: `grid-template-columns: repeat(8, 1fr)`.
* Units: `px`, `rem`, `%`; colors; fonts. No more theory than needed for the
  exercises of this book.
* Exercises: style the chessboard markup [LY 30-chessboard]; weather dashboard
  with condition classes and hover lift [LY 20-weather-dashboard], including the
  optional TypeScript part that cycles the weather classes.

### 2.7 Forms and validation [NEW, prepares the bubble chart exam]
* `<form>`, `<label for>`, `submit` event and `preventDefault`, `input type=number
  / color / range`, `change` vs. `input` events.
* Validating before acting; showing and clearing an error paragraph; `disabled`
  buttons.
* Exercise: "Guest list" form that refuses empty names and duplicates, renders the
  list, and keeps a counter.


---

## Part 3 — SVG: drawing by describing

Goal: students understand declarative vs. imperative drawing, can write SVG by hand
and generate it from TypeScript, and can style and animate it. It reconnects with
the "creative" part of the course after the form-heavy Part 2.

### 3.1 A picture made of text [LY 20-svg, rewritten]
* Redraw year one's Olympic rings: once with the p5.js code they wrote last year,
  once as an `.svg` file. Same picture, two mindsets: *commands in order* vs.
  *a description of what is there*.
* `<svg viewBox>`, `circle`, `rect`, `line`, `polygon`, `path` (M/L/Z only), `text`,
  `g`. Coordinate system, `fill`, `stroke`, `stroke-width`.
* SVG is a stand-alone file (open in browser, in Inkscape, as `<img>`), *and* it
  can live inside HTML where it becomes part of the DOM.
* 🔎 Research: the `path` element's `A` (arc) command on MDN; then draw the
  smiley's mouth with it.
* Exercise: draw year one's smiley and a domino tile in hand-written SVG.

### 3.2 SVG elements are DOM objects too [LY 20-svg]
* `document.createElementNS(SVG_NS, "circle")` and why the namespace is needed;
  `setAttribute` vs. properties; `SVGCircleElement` in the type hierarchy.
* Selecting and styling SVG with CSS classes, `:hover` on shapes.
* Click handlers on shapes, mouse position via `getBoundingClientRect()`.
* Exercise: shape generator (dropdown circle/rect, random size, position, color;
  clear; click to remove) [LY homework 20-svg/10].

### 3.3 Charts: scaling data to pixels [LY 20-svg/15-diagram, EX 2025-10 bubble chart]
* Mapping a value range to a pixel range, flipped y axis, named constants for
  layout (`AXIS_LENGTH`, `MARGIN`).
* Drawing axes, ticks, and labels in loops; redraw = clear and rebuild.
* Exercise A: 12-month bar chart with a threshold line and red/green bars [LY].
* Exercise B: bubble chart with color/x/y/size form and range validation
  [EX 2025-10-09].

### 3.4 Animation with requestAnimationFrame [LY 20-svg]
* The animation loop compared with p5.js `draw()`; delta time in one sentence.
* Moving an element by updating attributes; bouncing off edges (the ball from year
  one, now in SVG).
* CSS transitions and `@keyframes` as the declarative alternative for simple
  motion.
* Exercise: bouncing ball, then a clock with three hands (`transform="rotate()"`).

### 3.5 Grids, hexagons, and a small game [EX 2025-11 beehive]
* Positioning many shapes from a loop; offset rows; `<use>` and `<defs>` for
  repeated symbols.
* Keyboard control of a sprite on a grid; CSS for the control buttons.
* Exercise: the beehive game (bee moves, honey pots placed) [EX 2025-11-13].

### 3.6 Toolchain step: scripts and assets [NEW, toolchain thread]
* Putting images and `.svg` files in `assets/` and importing them from Vite.
* `npm run build`: what `dist/` is, and opening the built page with `preview`.
* Adding a script of your own to `package.json`.
* Agent thread: let the agent write a `README.md` for the project, then check it
  line by line; add "keep README current" to `AGENTS.md` (as the Paint project
  did last year).

---

## Part 4 — Your own classes

Goal: students write classes because they have already used hundreds of objects.
Each chapter introduces exactly one OOP idea and an app that needs it.

### 4.1 From object literals to classes [LY TicTacToe/Connect Four, renamed]
* Recap: year one's compound types (`type Player = {...}`) and object literals.
* `class`, constructor, fields, methods, `this`; `new`; one class = one blueprint,
  many objects. Picture: the DOM classes (`HTMLButtonElement`) were blueprints too.
* Union literal types as small enums: `type Player = "red" | "yellow"`.
* Exercise: Connect Four with a single `ConnectFourGame` class and CSS Grid board;
  win detection in four directions [LY 40-classes/TicTacToe].

### 4.2 Encapsulation [NEW chapter, concepts spread across LY projects]
* `private`, `readonly`, `protected` preview; getters and setters; parameter
  properties `constructor(private width: number)`.
* Why hide: invariants ("a score never goes below zero"), and changing the inside
  without breaking the outside.
* Exercise: `Stopwatch` class (start/stop/reset, elapsed as getter) driving a
  small UI; then `BankAccount` refactor where the balance can't be set from outside.

### 4.3 Inheritance and abstract classes [LY BouncingBalls]
* `extends`, `super`, overriding; `abstract` class and abstract members; the
  substitution idea: an array of `Ball` holds every kind of ball.
* Exercise: Bouncing Balls with `GummyBall`, `SteelBall`, `SuperBall`,
  `FragileBall` differing only in `bounciness` and `onReachedBottom()` [LY].

### 4.4 Polymorphism, without `instanceof` [LY Shapes, EX 2025-12, EX 2026-01 mileage]
* The same call, different behavior; why a `switch` over a type field is the
  thing polymorphism replaces.
* ES modules: one class per file, `export`/`import`, `index.ts` only wires the UI.
* Exercise A: Shapes calculator (`Shape` → `Rectangle` → `Square`, `Ellipse` →
  `Circle`, `Line`; total area) [EX 2025-12-19].
* Exercise B: Travel reimbursement calculator (Car/Motorcycle/Bicycle/Walk)
  [EX 2026-01-29].

### 4.5 Class diagrams and designing before typing [NEW]
* Reading and drawing a small UML/mermaid class diagram (boxes, arrows for
  `extends`, `uses`). The Aquarium diagram from last year as the worked example.
* Exercise: Aquarium (`Fish` hierarchy, `FishManager` loop, image sprites,
  `scaleX(-1)`) [LY Aquarium], starting from a diagram the student draws first.

### 4.6 Exceptions [NEW, listed in prompt as missing last year]
* `throw new Error(...)`, `try`/`catch`/`finally`, the `Error` object, `unknown` in
  catch and narrowing with `instanceof Error`.
* When to throw (impossible states, invalid input deep inside logic) and when to
  return a result or show a message (expected user mistakes in the UI).
* Custom error classes via inheritance: `class ValidationError extends Error`.
* Exercise: refactor the calculator from 2.3 so the logic throws and the UI
  catches; then add error cases to the shapes calculator (negative side length).

### 4.7 Objects talking to each other: callbacks and Maps [LY Paint]
* Callback types (`type ToolChangeCallback = (tool: ToolType) => void`), optional
  properties, `Map<K, V>` and `Set<T>` as the built-in collections students will
  need before generics are explained.
* `enum` vs. union literal types, and which one this course uses.
* Exercise: Paint, an SVG drawing tool with `Shape`/`Circle`/`Rect`,
  `ShapeManager`, `ToolSelection` [LY Paint]. Longest project of the part; can
  span two or three lessons.

### 4.8 Rules, state, and undo: the bracelet [EX 2026-03 bracelet, EX 2026-04 sandwich]
* Designing classes for a rule set (alternating pattern, one-time warning,
  remove-last) and rendering from the model, never editing the DOM directly.
* Exceptions from 4.6 in action: the model throws, the UI shows.
* Exercise: Friendship bracelet editor [EX 2026-03-11]; the sandwich stacker is
  the same skeleton and can serve as the exam.

---

## Part 5 — Testing your logic

Placed before generics and data structures so the data-structure chapters can be
written test-first. Short part, but it introduces a habit that every later chapter
uses.

### 5.1 Why test, and what can be tested [LY LinkedListWithTests README]
* Regressions, edge cases, and "break `delete` on purpose and watch it go red".
* The rule that shapes every project from here on: logic that touches `document`
  can't be unit tested, so logic and UI live in separate files.
* Exercise: split the bracelet into `bracelet.ts` (pure) and `index.ts` (DOM).

### 5.2 Vitest [LY, updated to Vitest 4 + TS 7]
* Switching to `vite-ts-starter-tests`: diff it against the old starter (two new
  dev dependencies, five new scripts, `playwright.config.ts`, `e2e/`) so the
  template stops being magic. Read `math.ts` and `math.test.ts` together.
* The `*.test.ts` convention, `npm test` (run once) vs. `npm run test:watch`.
  Playwright is in the box too but stays unused until Part 8.
* `describe`, `it`, `expect`, the matchers students need (`toBe`, `toEqual`,
  `toThrow`, `toHaveLength`), `beforeEach`, Arrange-Act-Assert, one behavior per
  test.
* Running tests in VS Code; reading a failing test's output.
* Exercise: write tests for the bracelet rules and for the mileage calculator.

### 5.3 Toolchain step: `npm run check` before every commit [NEW, toolchain thread]
* The starter's `check` only runs Biome; add a `verify` script that chains `tsc`,
  `biome check`, and `vitest run`. What CI is, and a minimal GitHub Actions
  workflow that runs it on push (copy-paste, explained line by line).
* Agent thread: add "run `npm run check` before you are done" to `AGENTS.md` and
  watch the agent obey.

---

## Part 6 — Generics

Short part. Generics appear exactly when the student feels the pain of writing the
same class twice.

### 6.1 The same container for any type [NEW]
* Motivation: a `NumberStack` and a `StringStack` side by side; `T` as a type
  parameter; `Stack<T>` as a blueprint for blueprints.
* Generic functions (`first<T>(items: T[])`), generic constraints (`T extends
  { describe(): string }`), default behavior of inference.
* The generics students have used already: `Array<T>`, `Map<K, V>`,
  `querySelector<T>`, `Promise<T>` (preview).
* Exercise: generic `Pair<A, B>` and a generic `pickRandom<T>` used in the shapes
  generator.

### 6.2 Command pattern with undo [EX 2026-05 undo]
* Abstract `Command` with `execute`/`undo`; an `UndoStack<T>` that knows nothing
  about commands. Quote last year's note: "Yes, you could do it with a signed
  delta. Don't."
* Written test-first with Vitest.
* Exercise: Counter with multi-level undo; stretch goals redo and `ResetCommand`
  [EX 2026-05-21]. (The linked-list constraint of the original exam moves to
  7.3, where the stack gets reimplemented.)

---

## Part 7 — Dynamic data structures

Goal: linked lists, stacks, and queues implemented by hand, tested, and used in an
app. Every structure is built twice: first on an array (so the interface is clear),
then with nodes (so the pointers are understood).

### 7.1 Nodes and pointers [LY LinkedList, rewritten]
* Why arrays are not the end of the story: insert in the middle, remove from the
  front. The array-vs-list cost table.
* `Node<T>` with `value` and `next`; `null` as the end; svgbob box-and-pointer
  diagrams before and after each operation (last year's README did this well).
* 🔎 Research: what a "pointer" is in C, and why TypeScript has references
  instead; one sentence on the difference.
* `find`, `insertAtBeginning`, `insertAfter`, `delete`, `toArray`, each with a test.
* Exercise: Playlist app that renders the chain as `[title – artist] → … → null`.

### 7.2 Iterating your own collection [NEW]
* `for...of` over your list: `[Symbol.iterator]` in the simplest possible form, or
  a `forEach(callback)` method as the gentler alternative. Pick one in review.
* `toArray` for rendering, `length` as a getter vs. a counter field (trade-off).

### 7.3 Stacks [EX bracelet/train revisited, EX 2026-05 undo]
* LIFO; `push`, `pop`, `peek`, `isEmpty`; stack on a linked list with only a head
  pointer.
* Exercise: replace the array in `UndoStack<T>` with nodes; all tests stay green.
  Then the Train Builder [EX 2026-03-19], whose "caboose stays last" rule is a
  nice argument for a stack with a twist.

### 7.4 Queues [EX 2026-05 hairdresser]
* FIFO; `enqueue`, `dequeue`; the tail pointer and the two edge cases
  (first insert, last remove).
* Exercise: Hairdresser waiting line for humans and dogs, with the half-written
  test file where three tests say `expect.fail("not implemented")` [EX 2026-05-28].
 

### 7.5 When to use which [NEW]
* A one-page decision table: array, list, stack, queue, Map, Set; what each is
  good at, with the apps of this book as examples.
* Exercise: browser-history simulator (back/forward = two stacks) or print-queue
  simulator, student's choice.

---

## Part 8 — End-to-end testing and shipping

The part that was missing last year. Students have apps with real UI flows now;
this part tests them through the browser and ends with a project.

### 8.1 Playwright: testing through the browser [NEW]
* Unit test vs. e2e test: what each catches. Playwright is already in
  `vite-ts-starter-tests`: `npx playwright install` once, `e2e/add.e2e.ts` as the
  worked example, `npm run test:e2e`, the HTML report, headed vs. headless, and
  what the `webServer` block in `playwright.config.ts` does.
* `page.goto`, `getByRole`, `getByLabel`, `fill`, `click`, `expect(locator)
  .toHaveText/.toBeVisible`. Locators built on roles and labels as the reason
  semantic HTML and `<label for>` mattered in 2.7.
* Exercise: three e2e tests for the to-do list from 2.4.

### 8.2 Testing the apps of this book [NEW]
* Recording a test with the Playwright codegen tool, then cleaning it up.
* Testing error states (bracelet warnings, hairdresser empty queue) and keyboard
  interaction (beehive).
* Exercise: e2e suite for the hairdresser app; run unit and e2e tests in the CI
  workflow from 5.3.

### 8.3 Skills for your project [NEW, harness-engineering thread]
* What a good `AGENTS.md` contains after a year: project layout, commands, rules,
  things the agent got wrong before.
* Writing a small skill of your own (e.g. "add a Playwright test for a feature"
  or "create a new class in its own module with a test file") in
  `.agents/skills/<name>/SKILL.md`; trying it with the agent; `skills-lock.json`
  and sharing skills between projects.
* Exercise: write one skill, use it in the final project, and show the diff of
  what the agent did with and without it.

### 8.4 Final project [NEW]
* A two-to-three-week creative project from a list (SVG game with classes and a
  queue/stack; a drawing tool; a data visualization with a form), with required
  ingredients: class hierarchy, one hand-written data structure, unit tests, two
  e2e tests, `AGENTS.md`, clean repo.
* Grading rubric in the two-tier style of last year's exams (minimum to pass,
  then completeness and code quality).
* Optional: the "last lesson before Christmas" style framework demo lives outside
  the book.

---

## Deliberately left out

* Svelte/SvelteKit starter (orphaned last year; frameworks are not the topic).
* `float` layouts; Flexbox/Grid only.
* `fetch`/async/JSON and `localStorage`: tempting, but they would compete with OOP
  and data structures for time. Could become a bonus chapter in Part 8 if the year
  runs ahead of schedule.
* A standalone CSS theory chapter (by design).

## Open questions for review

1. **Where does testing go?** Proposal puts unit tests in Part 5, before generics
   and data structures, so lists/stacks/queues are built test-first. Alternative:
   keep last year's order (testing only with linked lists) and make Part 5 shorter.
2. **Exceptions in 4.6 vs. earlier.** Students hit `| null` in 2.3; a tiny
   `throw` could already appear there, with the full chapter in Part 4.
3. **Exam reuse.** The proposal maps all seven of last year's exams to exercises
   (bubble chart, beehive, shapes, mileage, bracelet/sandwich, undo, hairdresser)
   plus train builder. If some should stay unpublished for reuse as real exams,
   say which and I'll swap in new exercises of the same shape.
4. **Iterators (7.2).** `Symbol.iterator` may be one step too far; the `forEach`
   method alternative is simpler. Decide in review.
5. **Part 1 length.** Four chapters of setup before the first real DOM code might
   be too slow after a summer break; 1.3 (git) and 1.4 (agents) could move into
   Part 2 as interleaved chapters.
6. **E2E earlier?** Because Playwright ships in the tests starter, a first
   e2e test could already appear in 5.2 next to the first unit test (the
   starter's `add.e2e.ts` invites it). I kept e2e in Part 8 so Part 5 stays
   short, but moving one Playwright chapter forward is cheap.
7. **Exercise hosting.** Year one linked to the playground. Here exercises need
   starter code for the bigger tasks (bracelet, train, hairdresser). Options: a
   companion `ddp-second-exercises` repo with one folder per exercise (my
   preference, mirrors last year's `starter/`/`solution/` pairs), or inline
   listings in the book. The `example` shortcode would then point at repo folders.
