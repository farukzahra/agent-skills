---
name: skills-sh-maintainer
description: >-
  Create, update, publish, and sync Cursor agent skills on skills.sh
  (farukzahra/agent-skills) and the local environment (~/.cursor/skills,
  ~/.agents/skills). Use when the user asks to create or change a skill,
  publish to skills.sh, install skills globally, or sync skill copies.
disable-model-invocation: false
---

# Skills.sh maintainer — create & publish agent skills

You maintain **Faruk's published agent skills** on [skills.sh](https://skills.sh/farukzahra/agent-skills) and keep local copies in sync.

## Source of truth

| What | Path / URL |
|------|------------|
| **Git repo (edit here first)** | `C:\repo\agent-skills` |
| **GitHub** | https://github.com/farukzahra/agent-skills |
| **skills.sh listing** | https://skills.sh/farukzahra/agent-skills |
| **Local Cursor skills** | `C:\Users\T-GAMER\.cursor\skills\<name>\` |
| **Local agents skills** | `C:\Users\T-GAMER\.agents\skills\<name>\` |
| **GitHub PAT** | `C:\repo\secrets\github\pat.txt` (line `ghp_...`) |

**Never** consider a skill change done if you only edited `~/.cursor/skills/` without commit + push in `C:\repo\agent-skills`.

## When to use this skill

- User asks to **create a new skill**
- User asks to **change** an existing published skill (e.g. `recap`)
- User asks to **publish** or **push** skills to skills.sh
- User asks to **install** or **sync** skills in the local environment
- User says "skill no skills.sh", "agent-skills repo", "publicar skill"

## Create a new skill (workflow)

1. **Choose kebab-case name** (English): e.g. `recap`, `skills-sh-maintainer`.
2. **Create folder** in repo:
   ```
   C:\repo\agent-skills/skills/<skill-name>/
     SKILL.md          # required — YAML frontmatter + body (English)
     reference/        # optional snippets, templates
   ```
3. **SKILL.md rules** (see also Cursor `create-skill` skill):
   - `name` and `description` in frontmatter (English)
   - `description` must say **when** to invoke the skill (discovery)
   - Body: workflow steps, templates, quality bar
   - User-facing HTML/copy may be PT-BR when the skill targets a PT project
4. **Update** `README.md` in repo root — list the new skill + install one-liner.
5. **Commit + push** `main` (Conventional Commits, English message).
6. **Sync local copies**:
   ```powershell
   Copy-Item -Recurse "C:\repo\agent-skills\skills\<skill-name>" "C:\Users\T-GAMER\.cursor\skills\<skill-name>" -Force
   Copy-Item -Recurse "C:\repo\agent-skills\skills\<skill-name>" "C:\Users\T-GAMER\.agents\skills\<skill-name>" -Force
   ```
7. **Rollout** — see [reference/rollout.md](reference/rollout.md):
   - **Cross-repo skills** (`recap`, `dont-forget`, …): before closing, **ask the user** whether to install globally (`-g`) for all projects under `C:\repo`. If they already said yes (or "install everywhere"), run without asking again.
   - **Workspace-specific skills** (`skills-sh-maintainer`): sync step 6 only; **do not** offer bulk `C:\repo` rollout.
   ```bash
   npx skills add farukzahra/agent-skills --skill <skill-name> -g -a cursor -y
   ```
8. **Project slash commands** (if needed) live in **consumer repos**, e.g. `sessao-gravador/.cursor/commands/recap.md` — not in the skills.sh package.

## Update an existing skill

1. Edit under `C:\repo\agent-skills/skills/<skill-name>/`.
2. Sync to `~/.cursor/skills/` and `~/.agents/skills/` (same folder name).
3. `git add` → `git commit` → `git push origin main`.
4. Report commit hash + skills.sh URL to the user.

### Push when `gh` is unavailable

```powershell
cd C:\repo\agent-skills
$pat = (Get-Content "C:\repo\secrets\github\pat.txt" -Raw).Trim() -split "`n" | Where-Object { $_ -match '^ghp_' } | Select-Object -First 1
git push "https://${pat}@github.com/farukzahra/agent-skills.git" main
```

## Quality bar for published skills

- **Concise** SKILL.md (< 500 lines); split heavy reference into `reference/`.
- **Actionable** steps — no vague advice.
- **No secrets** in skill files or examples.
- **English** for skill metadata and instructions; UI copy in target project language when relevant.
- **Test** the skill once in a real project before telling the user it's ready.

## Skills currently in this repo

| Skill | Purpose |
|-------|---------|
| `recap` | Session delivery recap → self-contained HTML |
| `dont-forget` | Encode recurring obligations as CI/hooks/codegen, not prose |
| `semantic-version` | Bump `docs/release-history.json` on `/commit-push` (feeds `/sobre`) |
| `caveman-commit` | Terse Conventional Commits for `/commit-push` |
| `project-init` | Bootstrap Superpowers workflow (`/init`) in a project |
| `skills-sh-maintainer` | This skill — create/publish/sync skills (workspace-specific rollout) |

## Do not

- Commit PATs, `.env`, or credentials.
- Edit only `~/.cursor/skills/` without pushing `agent-skills`.
- Put project-specific slash commands inside the skills.sh package.
- Use `~/.cursor/skills-cursor/` (reserved for Cursor built-ins).
