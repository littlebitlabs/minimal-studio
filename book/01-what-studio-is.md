# 1. What Studio is

Minimal Studio is the screens of Minimal Core. Core is a server: it holds organizations, projects and spaces, serves each table of a registered database over REST and as tools for AI agents, decides who may do what, and records every call. Core has no pages of its own, and Studio is a client that reads Core and gives each of its powers a page.

## One connection, served three ways

The home page of a connected workspace says it in a line: "One connection, served three ways — REST for people, MCP for AI agents, M2M for systems." Under it, four steps that the rest of the book follows in order:

| Step | What happens | Chapters |
|---|---|---|
| **Connect** | Core is given a database: its host, login and pool | 3, 5, 16 |
| **Index** | Core reads the database's tables and knows them | 6, 19 |
| **Govern** | Templates, locks and visibility decide who may read or write each table | 18 |
| **Serve** | The tables answer over REST, to agents over MCP, and to systems with tokens | 8, 9, 17 |

## What lives where

Studio keeps almost nothing. Core keeps the data that matters, and Studio keeps what it needs to reach it.

| In Core | In Studio |
|---|---|
| Organizations, projects, spaces, features | The address of the Core and your choice of workspace |
| The registered databases and their index | Your sign-in, as the user ID and roles you chose |
| Definitions, their versions and their history | Settings: theme, font size, the assistant's model |
| Templates, locks, tokens | The server key, in the system keychain on a Mac and in the tab in a browser |
| The record of every call | A token you chose to keep for the MCP page |

The practical rule: close Studio and nothing is lost that was in Core, and anyone with the address and a key can open the same workspace in another Studio. Chapter 21 says where the key lives.

## Desktop and browser

Studio is one application that runs in two ways: as a desktop application, and as a page in a browser. The pages are the same. What differs is where the server key is kept, and a few controls that save files or open a system dialog. This edition of the book shows the desktop application on a Mac; Chapter 2 says how to start either.

## The pages

The sidebar groups Studio's pages by what you do with them:

| Group | Pages |
|---|---|
| **OVERVIEW** | Home |
| **BUILD** | Auto API, Browse, Custom API, Conversation, Apps, Code Modules |
| **DATA** | Schema Explorer, Databases, Table Indexing, Schema Changes |
| **WORKSPACE** | Organizations, Projects, Spaces, Features |
| **GOVERNANCE** | Access Tokens, Permission Templates, Table Governance, Readiness |
| **SYSTEM** | Provisioning, Activity, MCP, Settings |

Insights, which asks a model about your data through a persona, opens with `⌘6`, and Personas opens from it (Chapter 11); Appendix B lists the shortcuts.

## Two kinds of refusal

A page that shows an empty list or a red panel has not always failed. Core decides, with roles, who may read a thing, and Studio shows its answer in the Core's own words, with the fix beside it. Three answers recur through the book: a 403 says the role is missing, a 401 says the token did not resolve, and a 417 says a definition was not found. Appendix B lists them. When a page is refused, read the panel first.

## Exercises

1. Open Studio and read the four steps of **Home**. Say which is not yet done in a workspace you know.
2. Open the sidebar and count the pages of each group. Check the count against the table of this chapter.
3. Look at the status at the top right of any page. Say which address it names, and what you would change to point Studio at another Core.
