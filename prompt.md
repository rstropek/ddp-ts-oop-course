## Introduction

In this project, we have to create a book similar to the one in ~/github/ddp-first/ts-ddp-first. While ~/github/ddp-first/ts-ddp-first is for first-graders (approx. 15 years), the new book is for second graders (approx. 16 years). They have already learned the content of the first book, so we need to build upon that knowledge.

The course is still Creative Coding. So the idea is to teach fundamental coding concepts together with concepts of UI development, UI design (on a very basic level).

While the students used TS+p5js in the first book, we will use TS+HTML+CSS(+SVG in some cases) now. In the first book, students started with a web-based environment and switch to VSCode afterwards. In this book, we will only work with VSCode from the very beginning.

## Starter Code

The students will start all their project based on a starter code: ~/github/ts-vite-starter (https://github.com/Teaching-HTL-Leonding/vite-ts-starter.git).

## Previous Year's Repo

Last year, I did not have a book yet. I used a plain GitHub repo. You can find it at ~/github/htl-2025-26-2nd (https://github.com/rstropek/htl-2025-26-2nd/)

You can also find exercises in ~/github/htl-csharp-private (https://github.com/rstropek/htl-csharp-private). Relevant are only folders from Sept. 2025 onwards. In this repo, I create exams. Partly, I copy the exams into the course repos, but not consistently. I am perfectly fine using a previous year's exam as an exercise in the upcoming year (i.e. this book).

## Didactical concept

The central idea of the second year is to teach OOP. We do not immediately start with classes, but approach the topic by speaking about the HTML DOM. By practicing with it, they should become familiar with object identity, collections (e.g. by using selectors), manipulating objects and collections, and the concept of events. In this part of the course, students will also enhance their understanding of a typical project setup (package.json, tsconfig, biome, skills.sh, etc.); still not on a super deep level, but more that just "accept the magic" from year one.

As this is a Creative Coding course, we follow up with SVG. Students should understand the different between imperative (p5js) and declarative drawing (SVG). They should understand that SVG works stand-alone, but can also be embedded in HTML DOM (including CSS).

Speaking of CSS: The course should introduce the core idea of CSS in the very first chapters. However, we do not dedicate a chapter on CSS. The concept is more learning-by-doing. In all chapters, we are using CSS to style the HTML DOM and SVG. Students gather CSS knowledge by practicing, not by learning a lot of theory. However, CSS selectors are a different thing. With selectors, they should learn about the concept of querying objects and collections.

Based on this, our next step is creating our own classes and learning about OOP concepts like polymorphism, inheritance, and encapsulation. We start with regular classes, later also cover generics.

The last big topic of the course are dynamic data structures, in particular linked lists, stacks, and queues. When working with these data structures, we also introduce the concept of automated testing with unit tests and e2e tests.

What I did not cover last year, but I want to cover in this book hoping to make it this year:

* Exceptions
* More on harness engineering (particularly skills and AGENTS.md/CLAUDE.md)
* More on e2e testing

## Technology

I want to use latest tech, so TS 7, Vite, Vitest, Playwright, Biome. This course does NOT teach frameworks like React, Svelte, Angular (maybe I will show it ad hoc e.g. in the last lesson before Christmas, but not as a topic of the course). The course is about fundamental concepts, not about frameworks.

## Your task

1. Look at the book for the first year (~/github/ddp-first/ts-ddp-first) and copy the technical structure including skills, Quarto setup, etc. to this folder/repo. Add a dummy chapter and ensure that HTML and PDF builds.
2. Read the starter code and the material from last year (GH repo, exam repo) to get an idea of the content and the technical level. We do NOT need to take everything, you can pick-and-choose. We do not need to use the existing material as-is, we can adapt it, enhance it, or even throw it away and create new material.
3. Work out a suggestion for the book structure with bullet points for each chapter describing the content/concept. Write this structure into book-structure.md. I will review it and we can discuss it. Once we agree, we will need to work on the content of the book.
