<!-- generated from minimal-studio-SKILL.md v0.1.0 by scripts/render-agent-skills.sh — do not edit by hand -->

# Minimal Studio skill — one brief, every agent's format (v0.1.0)

Save the file for YOUR agent in the project where you work, at the path in the middle column. **Most of these paths
start with a dot — Finder and plain `ls` hide them** (Cmd+Shift+. in Finder, `ls -la` in a shell). Every file
carries the same brief, generated from [`minimal-studio-SKILL.md`](../minimal-studio-SKILL.md); the source is the one to read and the one to change.

| Agent | Save the file at | The file here |
|---|---|---|
| Claude Code | `.claude/skills/minimal-studio/SKILL.md` | `claude-code-SKILL.md` |
| Cursor | `.cursor/rules/minimal-studio.mdc` | `cursor-minimal-studio.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` | `github-copilot-copilot-instructions.md` |
| Windsurf / Devin Desktop | `.windsurfrules` | `windsurf-windsurfrules` |
| Cline | `.clinerules` | `cline-clinerules` |
| RooCode | `.roo/rules/minimal-studio.md` | `roocode-minimal-studio.md` |
| Aider | `CONVENTIONS.md` + `.aider.conf.yml` | `aider-CONVENTIONS.md` + `aider-aider.conf.yml` |
| OpenCode | `AGENTS.md` | `opencode-AGENTS.md` |
| Codex | `AGENTS.md` (also reads a CLAUDE.md if present) | `codex-AGENTS.md` |
| Hermes | `SKILL.md` | `hermes-SKILL.md` |
| JetBrains Junie | `.junie/guidelines.md` | `jetbrains-junie-guidelines.md` |
| Google Antigravity | `skills/minimal-studio.md` (format still evolving) | `antigravity-minimal-studio.md` |
| Kiro (AWS) | `.kiro/steering/minimal-studio.md` | `kiro-minimal-studio.md` |

If your agent is not listed, any of the plain-markdown files works as a paste-ready brief.

## Fetch one file

```bash
mkdir -p .claude/skills/minimal-studio
curl -fsSL --proto '=https' --proto-redir '=https' -o .claude/skills/minimal-studio/SKILL.md https://raw.githubusercontent.com/littlebitlabs/minimal-studio/main/agent-skills/claude-code-SKILL.md
```

Every other file is at `https://raw.githubusercontent.com/littlebitlabs/minimal-studio/main/agent-skills/<name from the last column>`. `SHA256SUMS` lists the sha256 of each file; check one with
`grep ' <name>$' SHA256SUMS | shasum -a 256 -c -` (Linux: `sha256sum -c -`). The Claude Code and Hermes files are
byte-identical to [`minimal-studio-SKILL.md`](../minimal-studio-SKILL.md).

**Save into a folder your agent can read.** On macOS an agent is often not allowed to read `~/Downloads`, `~/Desktop`
or `~/Documents`; use your project folder instead.
