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
* **Experiments before theory.** Every chapter opens with something to type
  and watch, and names the concept afterwards. Setup, git, research, and the
  coding buddy appear as short chapters exactly where an experiment first
  needs them, not as a block at the front.
* **Exercises ship as files to copy.** Exercises that need more than the bare
  starter (HTML, CSS, base classes, half-written tests) live in this repo's
  `exercises/<name>/` folder. The student creates a fresh app from the general
  starter and copies those files in, so every exercise starts the same way and
  the book never hosts a second project template.
* **The book is not a reference.** It names and motivates concepts, APIs, and
  standards, and then sends students to MDN, a search engine, or their AI
  tools. When a chapter outline below lists APIs, that is what the chapter
  *names and uses*, not what it documents. Most chapters carry one
  **research task** (a `::: {.research}` box listing two to four questions):
  the student finds the answers before going on, the exercise after the box
  needs them, and the book never supplies them. The one quiz at the end of
  each chapter asks every research question again. Research tasks marked 🔎
  below are examples, not the final set.
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

## Part 1 — Welcome back

One short chapter, then straight into the DOM. Setup, git, research, and the
coding buddy are not a block of theory at the front; each gets its own chapter
inside Part 2, placed right after the experiment that makes it necessary.

### 1.1 From canvas to page [NEW]
* What changed in three sentences: p5.js painted pixels on a canvas; now the
  browser builds a page out of elements, and TypeScript talks to the page.
* Same language, new world: a short "what you know / what is new" table.
* How this book works: experiments first, concepts named afterwards; research
  tasks; quizzes; the exam rule "no internet, no AI, but the course material
  is allowed"; the AI policy (use agents to get unstuck, explain every line).
* Exercise, on page one: unzip or clone `vite-ts-starter`, `npm install`,
  `npm start`, change the heading text in `src/index.ts`, watch the page
  reload. Nothing is explained yet; that is the point.

---

## Part 2 — The DOM: a page full of objects

Goal of the part: students can read and change a page through its objects and
can react to events. Everything is still procedural (functions, no classes).
This is where the vocabulary of OOP gets introduced *by use*: object,
property, method, identity, reference. Every chapter opens with an experiment
and names the concept afterwards.

### 2.1 Elements are objects [LY 10-dom, rewritten]
* Experiment: two variables, one `getElementById`; change `textContent` through
  one, read it through the other. Then the DevTools elements panel as a live
  view of the same tree.
* Concepts named afterwards: HTML tags, attributes, nesting; the DOM tree
  (svgbob diagram); *object*, *property*, *identity*; link back to year one's
  value vs. reference chapter.
* Exercise: "Hello again" — a paragraph with today's date, a second heading,
  a button that says how often it was clicked (no events yet: count with
  `onclick` in HTML, to be replaced in 2.2).

### 2.2 Events: the page talks back [LY 10-dom]
* Experiment: `addEventListener("click", ...)` on a button; log the `event`
  object and look inside it.
* Concepts: the browser calls *your* function later (compare p5.js
  `mousePressed()`); arrow functions as handlers; `event.target`,
  `clientX/Y`, `key` for `keydown`; `element.style.*` as the first CSS touch.
* 🔎 Research: which events besides `click` exist for a button and an input.
* Exercise: click counter, color box that cycles colors, keyboard echo.

### 2.3 The starter project, file by file [NEW, based on vite-ts-starter]
* Students have used the starter twice now; this chapter opens the box.
* `index.html` and the `<script type="module">` bridge; `package.json`
  (`scripts`, `devDependencies`, `^`); `tsconfig.json` as a list of promises,
  with the four strict options they will actually hit; `biome.json`, `npm run
  check` / `check:fix`, format on save; `.vscode/`, `.gitignore`, `assets/`;
  the `.agents/skills` folder gets a teaser only.
* Exercise: break the project on purpose three times (remove the script tag,
  rename `index.ts`, leave a variable unused) and read the three errors.

### 2.4 Types for elements [NEW, merges the `as` casts LY used without explaining]
* Experiment: `getElementById` of an id that does not exist; read the error.
* Concepts: `HTMLElement | null` and what to do about it (`if (!el) throw`
  vs. `!`; connects to 4.6); `HTMLButtonElement`, `HTMLInputElement` as more
  special versions of `HTMLElement` (plant the word *inheritance*);
  `querySelector<HTMLInputElement>("#name")` instead of `as`; `input.value` is
  a string, `Number()`, `Number.isNaN`.
* Exercise: two-operand calculator with a `<select>` for the operator,
  division-by-zero error message [LY homework 10-simple-calculator].

### 2.5 Research is part of the job [NEW; replaces year one's "reading docs" chapters]
* Why this book stops explaining: the job is knowing how to find out, and the
  exam is about what stuck.
* The three sources and what each is good for: MDN (the truth about the web
  platform, how a reference page is organized), a search engine (error
  messages, "how do I" questions, the age of a result), an AI (explanations at
  your level, but verify against MDN; how to ask a precise question).
* How a research task in this book works: the box lists the questions, you
  find out now, and the chapter quiz asks the same questions at the end.
* 🔎 First research task: what `textContent` and `innerHTML` do differently;
  ask an AI the same question and note one thing one source said that the
  other didn't.

### 2.6 Creating elements [LY 10-dom, 20-svg]
* Experiment: `createElement` + `append` in a loop over an array of strings.
* Concepts: the array-of-data → elements-on-page pattern that returns in every
  later project; `remove`; `textContent` over `innerHTML` for user input;
  `classList` with a first real stylesheet (`import "./styles.css"`, a `.done`
  class, `:hover`).
* 🔎 Research: `classList` has more than `add` and `remove`; find the method
  that flips a class and the one that answers whether a class is set.
* Exercise: to-do list (add, mark done, delete). Bonus: count of open items.

### 2.7 Your coding buddy: pi on novedu [NEW, drafted as 0020-dom/0070-coding-buddy.qmd]
* Placed here because the to-do list is the first app big enough that an
  agent helps and can also mislead.
* Install `pi`, copy the book's `models.json` to `~/.pi/agent/`, put the
  activity code from the teacher into `auth.json`, first run in the to-do
  project.
* What the buddy knows (the course rules, the "ladder" of book parts) and the
  two rules that never change: you must be able to explain every line, and its
  mistakes are yours. The buddy answers questions but points to the source;
  research tasks are still the student's.
* Exercise: ask the buddy to add the open-items counter, read its diff, then
  delete it and write it yourself.
* Seeds the "harness engineering" thread; 3.6, 5.3, and 8.3 build on it.

### 2.8 Selectors: asking for collections [LY 30-selectors, strongest chapter of the part]
* Experiment: `querySelectorAll("p")`, change every element in a loop; then
  the same selector in `styles.css`.
* Concepts: one selector language, two users; `#id`, `.class`, `tag`,
  `tag.class`, descendant `a b` vs. `a.b`, `:hover`, `:nth-child`, attribute
  selectors; *a collection of objects* as the second OOP idea; `for...of`,
  `forEach`, `Array.from`, `.length`.
* 🔎 Research: what `querySelectorAll` returns, whether it changes when the page
  changes, and how to turn it into an array (the placeholder chapter's
  research quiz is the first draft of this).
* Exercise: given a blog page, select and style; then from TypeScript, count
  and toggle all paragraphs with class `highlight`.

### 2.9 Git and your course repository [NEW]
* Placed here because students now have four small projects worth keeping.
* The required repo layout (`coursework/`, `homework/`, `projects/`) and why
  a clean repo is part of the grade; the daily loop `add`, `commit`, `push`;
  reading `git status`; `.gitignore` (never `node_modules`, `dist`).
* 🔎 Research: what a commit message should look like; find two conventions
  and pick one.
* Exercise: create the course repo, move the projects so far into it, commit
  and push.

### 2.10 CSS by doing: layout with Flexbox and Grid [NEW; replaces LY's float lesson]
* Experiment: eight `div`s, `display: grid`, `repeat(8, 1fr)`; watch them snap
  into a board.
* Concepts: the box model in one figure; Flexbox for rows and columns (`gap`,
  `justify-content`, `align-items`); Grid for boards; units `px`, `rem`, `%`;
  colors; fonts. No more theory than the exercises need.
* 🔎 Research: how to center something horizontally and vertically with
  Flexbox; find the two properties and the MDN page that explains them.
* Exercises: style the chessboard markup [LY 30-chessboard]; weather dashboard
  with condition classes and hover lift [LY 20-weather-dashboard], including
  the optional TypeScript part that cycles the weather classes.

### 2.11 Forms and validation [NEW, prepares the bubble chart exam]
* Experiment: a `<form>` with a submit button; watch the page reload; add
  `preventDefault`.
* Concepts: `<label for>`, the `submit` event, `input type=number / color /
  range`, `change` vs. `input`; validating before acting; showing and clearing
  an error paragraph; `disabled` buttons.
* 🔎 Research: which `input` types exist and which three the next part's chart
  needs (number, color, range); what `valueAsNumber` does.
* Exercise: "Guest list" form that refuses empty names and duplicates, renders
  the list, and keeps a counter.

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
* Exercise: refactor the calculator from 2.4 so the logic throws and the UI
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
then with nodes (so the pointers are understood). Every structure is built
**test-first**: the tests from the array version stay green when the nodes replace
the array.

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
* A `forEach(callback: (value: T) => void)` method on the list: the callback
  idea from 4.7 applied to your own collection. `Symbol.iterator` is
  deliberately left out; a research task may point curious students to it.
* `toArray` for rendering, `length` as a getter vs. a counter field (trade-off).
* Written test-first, like everything in this part.

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
  semantic HTML and `<label for>` mattered in 2.11.
* Exercise: three e2e tests for the to-do list from 2.6.

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

## Decisions taken in review (2026-08-22)

1. **Testing before data structures.** Unit tests arrive in Part 5; every
   structure in Part 7 is built test-first.
2. **Exceptions** stay a full chapter in 4.6; 2.4 only plants the `throw` for a
   missing element.
3. **All of last year's exams** become exercises.
4. **Iteration (7.2)** uses a `forEach` method. No `Symbol.iterator`.
5. **Part 1 is one chapter.** Setup, research, buddy, and git are interleaved
   into Part 2 where an experiment first needs them. Experiments first,
   concepts named afterwards, everywhere.
6. **E2E stays in Part 8.**
7. **Exercise files live in `exercises/<name>/` in this repo.** Students create
   a fresh app from the general starter and copy the files in.

8. **One quiz per chapter**, at the end, where a quiz makes sense; it must
   cover the chapter's research questions.
9. **Exercise files via `{{< exercise <folder> >}}`**, a shortcode that lists
   `exercises/<folder>/` with target paths and GitHub links; the playground
   `example` shortcode is removed.

## Still open

* Exact set of research questions per chapter (the 🔎 lines are first drafts).
