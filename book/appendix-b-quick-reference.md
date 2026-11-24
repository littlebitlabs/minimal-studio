# Appendix B. Quick reference

## Pages

| Page | Group | What it is for | Chapter |
|---|---|---|---|
| Home | OVERVIEW | The four steps, recent calls, the next step | 1, 5 |
| Auto API | BUILD | Every indexed table as REST, tried from the page | 8, 28, 29 |
| Browse | BUILD | Rows of a table, through the Auto API | 7 |
| Custom API | BUILD | Definitions: editor, form, history, Try, Promote | 9, 10, 25, 26 |
| Conversation | BUILD | Ask for an API in plain words | 12 |
| Apps | BUILD | HTML apps that call your APIs | — |
| Code Modules | BUILD | Shared source, per language | 11, 27 |
| Schema Explorer | DATA | Indexed tables, and the live database | 6 |
| Databases | DATA | Registered databases; add or create one | 16 |
| Table Indexing | DATA | Make tables known to Minimal | 19 |
| Schema Changes | DATA | SQL on the live database, with a safety check | 19 |
| Organizations | WORKSPACE | The organization and who may act on it | 15 |
| Projects | WORKSPACE | A project, its connections and its roles | 15 |
| Spaces | WORKSPACE | dev, staging, prod | 15 |
| Features | WORKSPACE | Units that scope a project's definitions | 19 |
| Access Tokens | GOVERNANCE | Mint, use and revoke tokens | 17 |
| Permission Templates | GOVERNANCE | Roles per channel and verb | 18 |
| Table Governance | GOVERNANCE | Template, locks, visibility and scope per table | 18 |
| Readiness | GOVERNANCE | Advice on what is not yet safe | 16 |
| Provisioning | SYSTEM | The operator's page | 15 |
| Activity | SYSTEM | Every call, newest first | 20 |
| MCP | SYSTEM | The door's tools | 17, 30 |
| Settings | SYSTEM | Connection, profile, assistant, MCP, look | 20, 21 |
| Insights | `⌘6` | Questions through a persona | 13 |

**Apps** has no chapter in this edition.

## Keyboard

| Keys | Action |
|---|---|
| `⌘1` to `⌘8` | Home, Schema Explorer, Auto API, Custom API, Apps, Insights, Activity, Settings |
| `⌘\` | Show or hide the sidebar |
| `⌘.` | The AI Assistant |
| `⌘⇧O` | The Operations drawer |
| `?` | The shortcuts overlay (outside a text field) |
| `Esc` | Close the overlay or a dialog |

## Answers the book meets

| Status | Where | Meaning |
|---|---|---|
| 200 | Auto API, Custom API | Served; a Custom API step that answers a text or a number from an Expr is served as `{}` (Chapter 26) |
| 200 with `isError` | MCP door | A session problem: no `X-Session-Id`, a session that does not exist, or a role that may not write sessions. The text of the result says which, and the tool did not run (Chapter 30) |
| 201 | Auto API insert, Custom API POST | The row was inserted; the answer is `rows_affected` (Chapter 24), or the result of the steps (Chapter 25) |
| 400 | Schema Changes, Deploy and Update of a definition | The statement is refused before it runs, for example `DROP DATABASE` (Chapter 19); or the definition does not compile: "ERROR COMPILING DEFINITION YAML", with two statements in a SQL step, a Lua or Starlark source that does not compile, or a `let` block (Chapters 25, 26) |
| 401 | MCP door | The token does not resolve to an active, unexpired grant: it was deleted or has expired, or the URL names a door of another Core, so check the URL first (Chapters 17, 30); or no token was sent, or its key type lacks Create (Chapter 30) |
| 403 | Databases, Schema Explorer, Table Indexing, MCP door | A role is missing: the project's schema roles, the token's owner, or the space is not open to MCP (Chapters 6, 15, 16, 17) |
| 406 | Auto API read | The page number is too large: a read cannot skip past row 10,000,000, so filter on the last key seen (Chapter 29) |
| 417 | Custom API, Auto API read and insert | The definition or its version was not found (Chapter 9); the inserted row does not name `id`, so put `"id": null` (Chapter 24); a read names a column the table does not have, such as `count(*)` (Chapter 29) |
| 424 | New project, Auto API insert, Custom API call | The Core could not open the connection; the engine's own message follows, for example that a password is missing (Chapter 5); or a date was sent without a zone (Chapter 24); or a call failed: "could not execute URI", and `details` names the step, the field that was not sent, the script's error or the database's (Chapters 25 to 27) |
| 502 | Create database, Table Indexing | The engine refused or lacks what the Core asked; its own message follows, for example a refused login (Chapter 16) or a catalog function the engine does not have (Chapter 23) |
| Unreachable | Sign-in, Home | Nothing answered at the address (Chapters 3, 22) |

## Engines, types and codes

| **Type** in Add database | Code in the Auto API path | Engines the book registered (Chapter 23) |
|---|---|---|
| PostgreSQL | `pg` | PostgreSQL, TimescaleDB, Citus, CockroachDB, YugabyteDB, RisingWave |
| MySQL | `ms` | MySQL, Percona Server, Vitess, TiDB, StarRocks, SingleStore |
| MariaDB | `ma` | MariaDB |
| ClickHouse | `ch` | ClickHouse |

The path is `/minimal/api/rest/auto/v1/<organization>/<project>/<code>/<database>/<table>`.

## Steps of a definition

| Key | Kind | Reads | Answers | Chapter |
|---|---|---|---|---|
| `sql` | One SQL statement | `?:name`, from the caller or from a field a script returned | rows; or `rows_affected`; or the rows of a `RETURNING` | 9, 25 |
| `lua` | Lua script, `code` holds `min_main` | `step_N` (from 1), `input`, modules by `require("name")` | a map | 25 to 27 |
| `lark` | Starlark script, `code` holds `min_main` | `step_N` (from 0), `input["name"]`, modules by `load("name", "symbol")` | a map | 26, 27 |
| `expr` | One expression, `code` holds it | `step_N` (from 0), `input.name` | a map; a text or a number answers `{}` | 26 |
| `let`, `case`, `fnc` | In the grammar, not implemented | | | 25 |

| Step field | Meaning |
|---|---|
| `omit: true` | The result feeds the next steps and is left out of the answer |
| One result left | The answer is that result alone; with several, an object with a key `step_N` for each |
| Name after `lua:`, `lark:`, `expr:` | The step's name; in a Lua or Starlark error it shows as a file name, `name.lua` or `name.star` |

## What is refused, and when

| What is wrong | Validate | Deploy or Update | The call |
|---|---|---|---|
| Two statements in a SQL step | passes | 400 | |
| A Lua or Starlark source that does not compile | passes | 400 | |
| A `let`, `case` or `fnc` block | passes (a yellow line shows in the editor, before Validate) | 400 (the book's `let` block) | |
| A placeholder in quotes, `'?:id'` | passes | takes it | 424 |
| An Expr that does not parse | passes | takes it | 424 |
| A script that returns text, or has no `min_main` | passes | takes it | 424 |
| A step that reads a missing row, a name that is not defined, or an index out of range | passes | takes it | 424 |
| A field a body or a query does not send | passes | takes it | 424 |
| A module that does not compile | | refused when it is created or saved | |
| A module that fails when run, or is deleted while a definition loads it | | saved or deleted | 424 |

## Names to know

| Name | Meaning |
|---|---|
| Server key | The secret that lets Studio call Core as an operator; kept in the keychain on a Mac |
| `sys:` user ID | A provisioner: creates organizations, nothing inside them |
| `mcp:` user ID | The identity that must own a token for the MCP door to accept it |
| Session | What an MCP caller opens with `start_ai_session`: every call under it is recorded, and its id travels in the header `X-Session-Id` (Chapter 30) |
| Template | A named matrix of roles per channel and verb |
| Lock | A per-verb closure on a table, above the template |
| Row scope | A rule on a table: a text column must equal a header of the caller (Chapter 18) |
| Step | One item of a definition's `logic`; its result is `step_N` for the steps after it (Chapter 25) |
| Module | Lua or Starlark source stored once per space and loaded by name; Lua and Starlark keep separate stores (Chapter 27) |
| Space | dev, staging or prod: where a definition is written, proved or served |
