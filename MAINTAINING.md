# Maintaining this repository

This repository holds ONE source, [`minimal-studio-SKILL.md`](minimal-studio-SKILL.md), and what is generated from it. The files in `agent-skills/` are never edited by hand: change the source, then render.

## What a change must satisfy

- **Every rule is sourced.** A rule in the skill came from a run of Minimal Studio, from Littlebit Labs' published guides, or from the Book of Minimal. If you cannot name where it came from, it does not belong in the skill. What was not run is marked "unverified: ask the person", never stated as fact.
- **Self-contained.** An agent holding only the skill file must be able to do the whole job. Links to the book and the guides add depth; nothing the agent needs to be safe may sit behind a link.
- **Short.** The skill stays under about 30 KB: several agents load their rules file in every conversation, and Codex reads at most 32 KiB of AGENTS.md files in all and cuts the rest silently. Safety rules stay near the top, so a cut takes the tail. Cut before you add.
- **No secrets, no real hosts.** Examples use `acme`, `api.localhost`, `<core address>` and placeholders. Never a real address, key, token, email or personal name.
- **Discipline lines stay.** The skill's rules about secrets, destructive actions and the `dev` space are not softened by a release.

## Update steps (a new Studio release, or a corrected claim)

1. **Re-check the claims** that the release touches: run the task in Studio, or read the release notes, and compare with the skill. Change only what differs; add the date and the Studio version to a changed claim's note. Then run the prompts of [`evals/prompts.md`](evals/prompts.md) with and without the skill against a test Core.
2. **Branch.** `git switch main && git pull && git switch -c chore/skill-X.Y.Z`
3. **Edit the source** `minimal-studio-SKILL.md`. Keep the frontmatter `name` and `description`: agents choose the skill by the description.
4. **Bump `VERSION`** (the skill's own version) and the line under the title that names the Studio version the skill was verified on.
5. **Render.** `scripts/render-agent-skills.sh` rewrites `agent-skills/` (the formats, the map and `SHA256SUMS`). `scripts/render-agent-skills.sh --check` must then print `ok`; run it in CI too.
6. **Scan for leaks** in the tree and in the new commits: real hostnames, IP addresses, local paths, personal names and emails, keys and tokens.
7. **Merge.** `git push -u origin chore/skill-X.Y.Z`, then merge into `main` with `--no-ff`, tag `vX.Y.Z`, push, and delete the branch.

## Rules

- Commit messages follow `<type>(<scope>): <summary>`, for example `chore(skill): verify against Studio 0.190.0`.
- Published versions are immutable. A wrong claim is fixed in a new version, never by rewriting a tag.
- The `REPO` and `BRANCH` environment variables of the render script set the download links in `agent-skills/README.md`; the defaults are `littlebitlabs/minimal-studio` and `main`.
- The releases key in `littlebit-labs-releases.asc` expires on 2028-11-10. Before then extend it (the fingerprint stays) or issue a new one, and re-export the file with `gpg --armor --export <fingerprint>`; a new key also changes the fingerprint in the README.
