# Minimal Studio — agent skill

[Minimal Studio](https://littlebitlabs.com) is the desktop and web client of a Minimal Core: the screens where you sign in, explore tables, call and build APIs, manage access tokens and table governance, add databases and promote between spaces. This repository holds one file that teaches an AI coding agent to use it: what Studio is, how to choose between its screens and the Core's own MCP and REST interfaces, how each common task goes, what every refusal means, and what the agent must never do on its own.

It is the short, agent-facing version of the [Book of Minimal Studio](book/00-preface.md), which shows a screenshot for every step. Every rule in it was run in Minimal Studio v0.189.0 or comes from Littlebit Labs' published guides; what was not run is listed in the skill under "Not verified" and the agent is told to ask you.

## What the skill covers

- Signing in (a server key on **Direct to Core**, or a **Gateway** login), identities (`sys:` provisioners, `mcp:` agents), and the workspace: organization, project, space, feature.
- Reading and writing tables through the Auto API: the address, the query grammar, the refusals.
- Custom APIs: the definition, its SQL, Lua, Starlark and Expr steps, the script contract, Code Modules, versions and promotion; and the mistakes that Studio's **Validate** does not catch.
- Access tokens, permission templates, table locks, hiding a table and row-level security.
- Databases: adding one, indexing its tables, schema changes, and the drop wizard.
- Activity, settings, and the AI pages (Conversation, Insights, the Assistant).

## Let your AI agent use Minimal Studio

Use an agent that runs on your machine: Claude Code, Cursor, Codex, GitHub Copilot, Windsurf, Cline, RooCode, Aider, OpenCode, Hermes, JetBrains Junie, Antigravity or Kiro.

1. Copy your agent's file from [`agent-skills/`](agent-skills/README.md) to where that agent loads it, inside your project folder (the README there gives the path for each agent and direct downloads). On a Mac keep that folder out of Downloads, Desktop and Documents, which agents often cannot read. Any other agent: paste [minimal-studio-SKILL.md](minimal-studio-SKILL.md) as its brief.
2. Ask for what you want: "Use Minimal Studio to add a Custom API that …", "Why does my definition answer 424?", "Open the `note` table to my MCP agent for reads, then put it back."
3. The agent asks for the Core's address, how you sign in, and which space it may write to (it starts read-only and asks before it changes anything). **You enter the server key, passwords and tokens in Studio yourself. The agent is told never to ask for them in the chat.**
4. It stops and asks before it deletes anything, opens a write lock, changes roles, runs SQL on a live database, drops a database or promotes beyond `dev`, and it hands you a list of what it created and removed.

## Download Minimal Studio

The desktop and web app itself (not the agent skill) is under [`releases/v0.192.0-2026-11-23/`](releases/v0.192.0-2026-11-23/): macOS (Apple Silicon and Intel), Windows, Linux and a static web build, each checked against `SHA256SUMS.txt` and its GPG signature `SHA256SUMS.txt.asc`. The same files are also attached to the [GitHub release](../../releases/tag/v0.192.0-2026-11-23) and published on the [Littlebit Labs artifacts registry](https://artifacts.littlebitlabs.com/littlebitlabs/-/packages/generic/minimal-studio), which also serves a one-line installer for the Mac build (no Apple signature needed):

```bash
curl -fsSL --proto '=https' --proto-redir '=https' \
  https://artifacts.littlebitlabs.com/api/packages/littlebitlabs/generic/minimal-studio/latest/install-mac.sh | sh
```

### Verify a download

`SHA256SUMS.txt` lists the SHA-256 of every file in a release, and `SHA256SUMS.txt.asc` is its GPG signature, made with the Littlebit Labs releases key ([`littlebit-labs-releases.asc`](littlebit-labs-releases.asc)). The key's fingerprint:

```text
879C 474D DA68 F63F AFE3  4D39 8683 CD6A C10E 1012
```

Put `SHA256SUMS.txt`, `SHA256SUMS.txt.asc` and the file you downloaded in one folder, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/littlebitlabs/minimal-studio/main/littlebit-labs-releases.asc | gpg --import
gpg --verify SHA256SUMS.txt.asc SHA256SUMS.txt   # must say "Good signature" and show the fingerprint above
sha256sum -c --ignore-missing SHA256SUMS.txt     # on a Mac: shasum -a 256 -c --ignore-missing SHA256SUMS.txt
```

`gpg` also warns that the key is "not certified with a trusted signature". That is normal for a key you have not signed yourself: compare the fingerprint it shows. If it differs, or a check says FAILED, do not open the file and [report it](SECURITY.md). v0.190.0 and v0.191.0 were published without `SHA256SUMS.txt.asc`; for those only the checksum can be checked.

## Read the Book of Minimal Studio

[`book/`](book/) holds the full, screenshot-by-screenshot guide this skill is distilled from — 35 chapters and appendices, run against a real Core on Minimal Studio v0.189.0.

- [Preface](book/00-preface.md)
- [1. What Studio is](book/01-what-studio-is.md)
- [2. Install and launch](book/02-install-and-launch.md)
- [3. Connect to your Core](book/03-connect-to-your-core.md)
- [4. Identities](book/04-identities.md)
- [5. The workspace](book/05-the-workspace.md)
- [6. The Schema Explorer](book/06-schema-explorer.md)
- [7. Browse](book/07-browse.md)
- [8. The Auto API page](book/08-the-auto-api.md)
- [9. The Custom API editor](book/09-the-custom-api-editor.md)
- [10. Promotion](book/10-promotion.md)
- [11. Code Modules and Personas](book/11-code-modules-and-personas.md)
- [12. Conversation](book/12-conversation.md)
- [13. Insights](book/13-insights.md)
- [14. The AI Assistant](book/14-the-ai-assistant.md)
- [15. Organizations, projects and spaces](book/15-organizations-projects-spaces.md)
- [16. Databases and readiness](book/16-databases-and-readiness.md)
- [17. Access tokens and the MCP page](book/17-access-tokens-and-mcp.md)
- [18. Permission templates and table governance](book/18-permission-templates-and-table-governance.md)
- [19. Features, table indexing and schema changes](book/19-features-indexing-and-schema-changes.md)
- [20. Activity and Settings](book/20-activity-and-settings.md)
- [21. Where the key lives](book/21-where-the-key-lives.md)
- [22. When Core is unreachable](book/22-when-core-is-unreachable.md)
- [23. Many databases, one project](book/23-many-databases-one-project.md)
- [24. Row-level security in depth](book/24-row-level-security-in-depth.md)
- [25. Custom APIs with several steps](book/25-custom-apis-with-several-steps.md)
- [26. Script steps: Lua, Starlark and Expr](book/26-script-steps-lua-starlark-and-expr.md)
- [27. Code Modules in practice](book/27-code-modules-in-practice.md)
- [28. Auto API filters and operators](book/28-auto-api-filters-and-operators.md)
- [29. Auto API keywords, formats and limits](book/29-auto-api-keywords-formats-and-limits.md)
- [30. The MCP door beyond Studio](book/30-the-mcp-door-beyond-studio.md)
- [Appendix A. The Acme data](book/appendix-a-acme-data.md)
- [Appendix B. Quick reference](book/appendix-b-quick-reference.md)
- [Appendix C. What this edition leaves out](book/appendix-c-what-this-edition-leaves-out.md)
- [Appendix D. The demo databases](book/appendix-d-the-demo-databases.md)

## Good to know

- The skill and the book describe Minimal Studio v0.189.0 (the Mac app and the web build, run against a local Core; Windows, Linux and a release web build were not run). The downloads above are the current release, v0.192.0: its release notes list what changed since.
- The agent prefers the Core's MCP door or REST once you have set an access token up for it (in your own MCP client, or a headers file only you can read: it never sees or mints one in the chat), and drives Studio's screen only when it has to. Studio's code editor takes no typed text from automation on the desktop app, so for editing it uses the web build.
- Codex reads at most 32 KiB of AGENTS.md files in all and cuts the rest without a warning, and this brief is about 30 KB: keep it in a folder of its own, or raise `project_doc_max_bytes` in `~/.codex/config.toml`.
- To install a Minimal stack first, use the [Minimal Pitstop](https://github.com/littlebitlabs/minimal-pitstop) setup skill.
- The files in `agent-skills/` are generated from `minimal-studio-SKILL.md` by `scripts/render-agent-skills.sh`: do not edit them by hand. See [MAINTAINING.md](MAINTAINING.md).
- Problems: GitHub issues. Security problems: [SECURITY.md](SECURITY.md).
