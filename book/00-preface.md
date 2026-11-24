# Preface

A database already holds most of an API. Minimal Core serves every table of it over REST and as tools for AI agents, decides on each table who may do what, and records every call. Core has no screens of its own. Minimal Studio is its screens: one application, on the desktop and in the browser, that turns each thing Core does into a page you can read and work in.

This book takes you from a fresh install of Studio to a connected, governed workspace, and on to the APIs you build in it. Followed step by step, it teaches all of Studio; read in parts, each part stands on its own.

## Who it is for

Two readers, two tracks.

- **Builders** explore data and author APIs. Parts 1 to 4 are theirs: connecting, exploring a schema, reading it through the Auto API, building Custom API definitions, and asking questions of the data in plain words. Part 8 takes the definitions further: several steps, scripts, and shared modules. It also works through the Auto API's filters, keywords and formats, and ends with the MCP door seen from outside Studio: from another person's Studio, from a terminal and from another AI client.
- **Administrators** run the workspace: its organizations, projects and spaces, its databases, its access tokens, and who may read or change each table. Part 5 is theirs. It opens with a setup box that stands up a connected workspace without the builder's chapters.

Part 6, on operating Studio, belongs to both.

## The running example

One company runs through the book: Acme Corporation, a fictional firm, and its HR database of eight tables, 120 employees and 1,515 leave requests. It is the database of the Book of Minimal, so a reader of both books meets the same rows. Appendix A prints its schema and the facts the chapters check against.

Acme's workspace is the organization **Acme Corporation**, its project **People**, and the project's spaces. Two people sign in: John Doe, who administers it, and Jane Doe, who builds on it. The builder's thread ends in a Custom API that lists the leave requests awaiting approval, written in the `dev` space and promoted to `prod`.

## How the book is written

- **Labels.** Names on screen, such as the **Schema Explorer** page, are bold and exactly as Studio shows them. Steps are numbered, and each says where it happens.
- **Shots.** Every page you are sent to has a picture of it, and so does every step that changes what is on the screen. The pictures are of the desktop app on a Mac, at one window size; where the web app differs, the chapter says so and shows it.
- **Placeholders.** `<your-server-key>`, `<your-access-token>` and other words in angle brackets stand for values that are yours. A secret is never printed; where a screen shows one, a solid bar covers it.
- **Addresses.** The book's Core runs on the same Mac as Studio, at `http://127.0.0.1:13145`. A gateway is written `https://api.minimal.example`.
- **Replies.** Where Studio asks a model, the wording of the answer changes from one run to the next. A reply is introduced as "a reply such as", and what the book asserts are the labels, the counts and the statuses around it.
- **The wire.** Where a step sends a request worth seeing, the book shows it as three blocks: the request, the head of the response, and its body. The Book of Minimal teaches that contract in full; this book points to it rather than teaching it twice.
- **Exercises.** Each chapter ends with three. They need only what the chapter taught, and they check stable facts, never a model's wording.

## The version

The book describes Minimal Studio v0.189.0, the version printed at the foot of its sign-in page and in its sidebar. Another version may differ in its labels.

## The chapters

| Part | Chapters |
|---|---|
| 1. Getting started | 1 What Studio is · 2 Install and launch · 3 Connect to your Core · 4 Identities · 5 The workspace |
| 2. Explore | 6 The Schema Explorer · 7 Browse |
| 3. Build | 8 The Auto API page · 9 The Custom API editor · 10 Promotion · 11 Code Modules and Personas |
| 4. Converse | 12 Conversation · 13 Insights · 14 The AI Assistant |
| 5. Administer | 15 Organizations, projects and spaces · 16 Databases and readiness · 17 Access tokens and the MCP page · 18 Permission templates and table governance · 19 Features, table indexing and schema changes |
| 6. Operate | 20 Activity and Settings · 21 Where the key lives · 22 When Core is unreachable |
| 7. Many engines | 23 Many databases, one project |
| 8. In depth | 24 Row-level security in depth · 25 Custom APIs with several steps · 26 Script steps: Lua, Starlark and Expr · 27 Code Modules in practice · 28 Auto API filters and operators · 29 Auto API keywords, formats and limits · 30 The MCP door beyond Studio |
| Appendices | A The Acme data · B Quick reference · C What this edition leaves out · D The demo databases |

Appendix C says which steps this edition shows and which it only describes.
