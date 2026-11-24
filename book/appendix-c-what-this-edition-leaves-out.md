# Appendix C. What this edition leaves out

The book was written by running Studio v0.189.0 against a fresh Core. What it did not run, it does not claim. Each item names why.

## Not run

| Left out | Why | Where it shows |
|---|---|---|
| Signing in to a release build of the web page | The web run used the development build, which keeps a copy of the key in local storage; a release build was built and read, not signed in to | Chapters 2, 21 |
| Windows and Linux builds | The edition covers the Mac application and the web page | Chapter 2 |
| An update or a delete on a scoped table | Their fields open in pop-ups of the Auto API page (**Set**, **Filters**) that the run did not drive; the Core's rules are in the Book of Minimal. Chapters 28 and 29 later drove the pop-ups in the web page, and still sent no update or delete | Chapters 24, 29 |
| A **PUT** or a **DELETE** sent from the Auto API page | The tables of Acme are locked against writes (Chapter 18) and the book left them so; the panes were filled in and shown, not sent. The Core's own answers are in the Book of Minimal | Chapter 29 |
| A `uf` that changes the rows | It needs a ClickHouse table whose engine merges rows in the background; the two tables of the book are plain MergeTree | Chapter 23 |
| A `let`, `case` or `fnc` step that the Core accepts | The book wrote one `let` block and **Deploy** refused it (400, `invalid "let" block noticed`); it found no block that the Core accepts, so it did not see the refusal at run time that Studio announces, and cannot say whether the Core refuses these kinds at **Deploy** or at the call | Chapter 25 |
| A call to a promoted definition in a space that has none of its modules | The Book of Minimal says the call fails at the `require` line; the book showed only that another space lists no modules | Chapter 27 |
| The history of a module while it is deleted | Studio's **History** needs the module to be selected; the book read it after the module was made again | Chapter 27 |
| Indexing a new table on the book's local Core | It would change the counts the chapters print; Chapter 23 indexes new tables on the gateway. The one exception is the view of Chapter 24, indexed and hidden, which changes two counts that the chapter names | Chapters 19, 24 |
| Saving an insight as an app, and the Apps page | Not tried | Chapter 13, Appendix B |
| The identity provider's login page | It is the provider's page, completed by the owner, and it shows the gateway's host; the book prints no real host, so the sign-in is shown from Studio's side with the host covered | Chapter 4 |
| The dashboard inside an Insights card | It answered "HTTP 404" for its own data; the text answer is shown | Chapter 13 |
| The identity provider's pages for adding a second factor | They are the provider's, they show the gateway's host, and a QR code and a key are secrets; the steps are described | Chapter 4 |
| The Pitstop helper `mcp-token`, which makes an MCP token on a gateway | The book's Pitstop gateway no longer exists, so the helper had nothing to run against; the section describes it and claims no more | Chapter 30 |
| Claude Desktop through a bridge, and `claude mcp add` | Claude Desktop needs a bridge program and a restart, which would have ended the session that drove the run; `claude mcp add` would change the Mac's Claude Code settings, so the run used a one-off configuration file | Chapter 30 |
| Conversation answering as `john.doe` | The web session held no AI key; the exchange of Chapter 12 was run in the desktop application as `mcp:agent` | Chapter 30 |
| A `viewer` sign-in minting its own token in Studio | The token was made by calling the Core's token route; whether the Mint dialog opens for a `viewer` sign-in was not tried | Chapter 30 |
| Video | Stills only | — |

## Not in Studio

- **DeepThought** is not in the application at this version.
- Licences of the components Studio bundles are not written here.

## What was done outside the window shown

Some steps of the book's run were done outside the window that the chapter shows, and are named where they happen:

- the `mcp:` sign-in needs a server key typed by a person (Chapter 17);
- switching the MCP door on for the `prod` space is a setting of the Core that Studio does not offer (Chapter 17);
- the schema roles and the database roles are granted by a provisioner, in a second Studio (Chapter 15);
- the throwaway logins that the create and drop dialogs use were made on the book's own Postgres server, the Core was restarted once, and the results of the create and the drop were read on that server (Chapter 16);
- the authenticator of the gateway's administrator was added by its owner in the identity provider's console (Chapter 4);
- the containers of Chapter 23 were started and loaded on the gateway's server with Docker and the engines' own clients (Appendix D);
- chapter 24 read three results and deleted its test note with statements on the book's Postgres server (the one author of the 400 notes, the stored author of the test note, the count of notes), and the server key (to sign in as a second user) and the token (into the Auto API page's access token field) were pasted by a person (Chapter 24);
- the gateway's server was enlarged, from 2 CPUs and 4 GB to 8 CPUs and 16 GB, in the hosting provider's console by its owner, and the containers were started again afterwards (Chapter 23, Appendix D);
- chapters 25 to 27 were run in Studio's web page, in a browser window that a script drove, because the desktop application does not take typed text into its code editor from the tools of the run; the pages are the same application (Chapters 25 to 27);
- chapters 25 and 26 read the leave and phone data and counted the notes of `audit_note` on the book's Postgres server, and deleted the notes of the chapter there (Chapters 25, 26);
- the last section of Chapter 23 and Chapters 28 and 29 were run in Studio's web page, in a browser window that a script drove, because the operator list, the **Filters** and **Set** panels and the format list open as pop-ups that the desktop run did not drive; the pages are the same application (Chapters 23, 28, 29);
- the four extra databases of that section are containers that were already on the Mac; a read-only login `studio_demo` was made in each with the engine's own client, and its password was typed into Studio from a file, never shown (Chapter 23);
- chapter 30 was run in Studio's web page, in a browser window that a script drove (the pages are the same application), and a person pasted the server key twice; the script saved each token from the Mint dialog to a file, so that no token reached a screen or a shot; the `viewer` token was made by calling the Core's token route with the book Core's server key; and the terminal commands and the Claude Code runs were made in a terminal beside the window, the Claude Code runs on the Mac's Claude Code login (Chapter 30).

A 403 on the pages that need the roles is cleared the same way in any workspace.
