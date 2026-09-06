# /skills-sh

Create, update, or publish a Cursor agent skill on **skills.sh** and sync the local environment.

## Preconditions

- User invoked **`/skills-sh`** or asked to create/change/publish a skill on skills.sh.
- Open workspace **`C:\repo\agent-skills`** when possible.
- Read and follow **`skills-sh-maintainer`** at `skills/skills-sh-maintainer/SKILL.md` (or `~/.cursor/skills/skills-sh-maintainer/SKILL.md`).

## Steps

1. Clarify skill name, purpose, and trigger scenarios.
2. Create or edit `skills/<skill-name>/SKILL.md` (+ `reference/` if needed).
3. Update root `README.md` for new skills.
4. Sync copies to `~/.cursor/skills/` and `~/.agents/skills/`.
5. **Commit + push** `main` on `farukzahra/agent-skills`.
6. **Rollout** (`skills/skills-sh-maintainer/reference/rollout.md`):
   - Cross-repo skill → **ask user** whether to install globally (`-g`) for all `C:\repo` projects.
   - Workspace-specific skill (`skills-sh-maintainer`) → sync only; no bulk offer.
7. If the skill needs a project slash command, add `.cursor/commands/<name>.md` in the **consumer repo** (not here).

## Output language

- Skill files: **English** (metadata + instructions).
- Reply to user: **Portuguese** unless they write in English.

## Do not

- Finish without `git push` to GitHub.
- Store secrets in skill files.
- Edit only `~/.cursor/skills/` without updating this repo.
