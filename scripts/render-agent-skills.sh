#!/usr/bin/env bash
# Render the Minimal Studio skill into the format of every common coding agent.
# The one source is minimal-studio-SKILL.md at the repo root. Everything in agent-skills/ is generated from it:
# never edit those files by hand, change the source and run this script.
#
#   scripts/render-agent-skills.sh           write agent-skills/ (and its README.md and SHA256SUMS)
#   scripts/render-agent-skills.sh --check   render to a temporary folder and compare with agent-skills/;
#                                            exits 1 if they differ (a hand edit, or a source change not rendered)
#
# Environment: REPO (GitHub org/name, used for the download links; default littlebitlabs/minimal-studio) and
# BRANCH (default main). Needs bash, awk, and sha256sum or shasum.
set -euo pipefail
cd "$(dirname "$0")/.."

SRC=minimal-studio-SKILL.md
REPO=${REPO:-littlebitlabs/minimal-studio}
BRANCH=${BRANCH:-main}
RAW=https://raw.githubusercontent.com/$REPO/$BRANCH/agent-skills
die() { echo "error: $*" >&2; exit 1; }
sha256() { { sha256sum "$1" 2>/dev/null || shasum -a 256 "$1"; } | cut -d' ' -f1; }

[ -f "$SRC" ] || die "$SRC not found"
[ -f VERSION ] || die "VERSION not found"
VERSION=$(tr -d '[:space:]' < VERSION)

# A field of the source's YAML frontmatter, on one line.
field() {
  awk -v k="$1" '
    NR == 1 { if ($0 != "---") exit; next }
    $0 == "---" { exit }
    index($0, k ": ") == 1 { sub("^" k ": ", ""); print; exit }' "$SRC"
}
NAME=$(field name)
DESC=$(field description)
[ -n "$NAME" ] && [ -n "$DESC" ] || die "$SRC needs name and description in its frontmatter"
# The description goes into YAML frontmatter, where a colon followed by a space, or a space before a #, breaks the plain scalar.
case $DESC in
  *": "*|*" #"*) die "the description in $SRC must not contain ': ' or ' #': it would break YAML frontmatter" ;;
esac

# Everything after the frontmatter: the body that the plain-markdown formats carry.
body() { awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && $0 == "---" { fm = 0; next } !fm' "$SRC"; }

MARK="generated from $SRC v$VERSION by scripts/render-agent-skills.sh — do not edit by hand"

# render <folder>: write every file into the folder.
render() {
  local d=$1
  rm -rf "$d"; mkdir -p "$d"

  # Claude Code and Hermes read the source as it is.
  cp "$SRC" "$d/claude-code-SKILL.md"
  cp "$SRC" "$d/hermes-SKILL.md"

  # The plain-markdown formats: the body under a title and the description.
  local f
  for f in aider-CONVENTIONS.md antigravity-$NAME.md cline-clinerules codex-AGENTS.md \
           github-copilot-copilot-instructions.md jetbrains-junie-guidelines.md kiro-$NAME.md opencode-AGENTS.md; do
    { printf '<!-- %s -->\n\n# %s\n\n> %s\n' "$MARK" "$NAME" "$DESC"; body; } > "$d/$f"
  done

  # Cursor: a rule the agent requests by its description.
  { printf -- '---\ndescription: %s\nglobs: []\nalwaysApply: false\n---\n<!-- %s -->\n' "$DESC" "$MARK"; body; } > "$d/cursor-$NAME.mdc"
  # RooCode: a rule with a description.
  { printf -- '---\ndescription: %s\n---\n<!-- %s -->\n' "$DESC" "$MARK"; body; } > "$d/roocode-$NAME.md"
  # Windsurf: one rules file.
  { printf '# %s\n\n%s — %s\n' "$MARK" "$NAME" "$DESC"; body; } > "$d/windsurf-windsurfrules"
  # Aider reads CONVENTIONS.md through its config.
  printf '# %s\nread: CONVENTIONS.md\n' "$MARK" > "$d/aider-aider.conf.yml"

  readme > "$d/README.md"
  ( cd "$d" && for f in $(LC_ALL=C ls | LC_ALL=C sort | grep -v '^SHA256SUMS$'); do printf '%s  %s\n' "$(sha256 "$f")" "$f"; done > SHA256SUMS )
}

# The map of formats, with where each file goes.
readme() {
  cat <<EOT
<!-- $MARK -->

# Minimal Studio skill — one brief, every agent's format (v$VERSION)

Save the file for YOUR agent in the project where you work, at the path in the middle column. **Most of these paths
start with a dot — Finder and plain \`ls\` hide them** (Cmd+Shift+. in Finder, \`ls -la\` in a shell). Every file
carries the same brief, generated from [\`$SRC\`](../$SRC); the source is the one to read and the one to change.

| Agent | Save the file at | The file here |
|---|---|---|
| Claude Code | \`.claude/skills/$NAME/SKILL.md\` | \`claude-code-SKILL.md\` |
| Cursor | \`.cursor/rules/$NAME.mdc\` | \`cursor-$NAME.mdc\` |
| GitHub Copilot | \`.github/copilot-instructions.md\` | \`github-copilot-copilot-instructions.md\` |
| Windsurf / Devin Desktop | \`.windsurfrules\` | \`windsurf-windsurfrules\` |
| Cline | \`.clinerules\` | \`cline-clinerules\` |
| RooCode | \`.roo/rules/$NAME.md\` | \`roocode-$NAME.md\` |
| Aider | \`CONVENTIONS.md\` + \`.aider.conf.yml\` | \`aider-CONVENTIONS.md\` + \`aider-aider.conf.yml\` |
| OpenCode | \`AGENTS.md\` | \`opencode-AGENTS.md\` |
| Codex | \`AGENTS.md\` (also reads a CLAUDE.md if present) | \`codex-AGENTS.md\` |
| Hermes | \`SKILL.md\` | \`hermes-SKILL.md\` |
| JetBrains Junie | \`.junie/guidelines.md\` | \`jetbrains-junie-guidelines.md\` |
| Google Antigravity | \`skills/$NAME.md\` (format still evolving) | \`antigravity-$NAME.md\` |
| Kiro (AWS) | \`.kiro/steering/$NAME.md\` | \`kiro-$NAME.md\` |

If your agent is not listed, any of the plain-markdown files works as a paste-ready brief.

## Fetch one file

\`\`\`bash
mkdir -p .claude/skills/$NAME
curl -fsSL --proto '=https' --proto-redir '=https' -o .claude/skills/$NAME/SKILL.md $RAW/claude-code-SKILL.md
\`\`\`

Every other file is at \`$RAW/<name from the last column>\`. \`SHA256SUMS\` lists the sha256 of each file; check one with
\`grep ' <name>\$' SHA256SUMS | shasum -a 256 -c -\` (Linux: \`sha256sum -c -\`). The Claude Code and Hermes files are
byte-identical to [\`$SRC\`](../$SRC).

**Save into a folder your agent can read.** On macOS an agent is often not allowed to read \`~/Downloads\`, \`~/Desktop\`
or \`~/Documents\`; use your project folder instead.
EOT
}

if [ "${1:-}" = --check ]; then
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
  render "$tmp/agent-skills"
  diff -r "$tmp/agent-skills" agent-skills >/dev/null || die "agent-skills/ is not what $SRC renders to: run scripts/render-agent-skills.sh"
  echo "ok: agent-skills/ matches $SRC v$VERSION"
else
  render agent-skills
  echo "rendered $(ls agent-skills | wc -l | tr -d ' ') files into agent-skills/ from $SRC v$VERSION"
fi
