# Custom skills inventory (Faruk repos)

Skills worth **publishing** on `farukzahra/agent-skills` (cross-repo):

| Skill | Status | Purpose |
|-------|--------|---------|
| `recap` | Published | Session HTML recap |
| `dont-forget` | Published | Obligation → CI/hooks automation |
| `semantic-version` | **Added** | `docs/release-history.json` → `/sobre` changelog |
| `caveman-commit` | **Added** | Terse Conventional Commits for `/commit-push` |
| `skills-sh-maintainer` | Published | Publish skills to skills.sh |

## Project-specific (keep in repo, do not globalize)

| Skill | Repo | Notes |
|-------|------|-------|
| `crud-ui` | terapia | TerapIA CRUD slide-over patterns |
| `article-from-repo` | blog | Generate articles from repo analysis |
| `blog-article` | blog | Blog writing workflow |
| `linkedin-push` | blog | Slash command, not a skill package |
| `code-analyzer` | faruk_base | Codebase analysis |
| `complexity-optimizer` | faruk_base | Performance / complexity audit |
| `azure-*` | ms-poc | Azure deploy POC only |

## Duplicated across many repos (third-party or template)

These live in `.agents/skills/` per project — install via `npx skills add` when needed, not copied to agent-skills:

- `hallmark`, `brainstorming`, `find-skills`, `prisma-*`, `playwright-best-practices`, Matt Pocock harness skills (`ask-matt`, `codebase-design`, …), job-ops design skills (`bolder`, `critique`, …), Flutter/Dart skills in `sounds`, etc.

## Slash commands (standardized separately)

| Command | Where | Notes |
|---------|-------|-------|
| `/commit-push` | All git repos under `C:\repo` | Canonical: `reference/commands/commit-push.md` |
| `/skills-sh` | agent-skills | Publish skills |
| `/recap` | consumer projects | e.g. terapia |
| `/linkedin-push` | blog | After article publish |
| `/enviar-celular` | fumei | Android device deploy |

## `/commit-push` pairing

```
semantic-version  →  BEFORE commit  (updates release-history.json)
caveman-commit    →  message
git commit
link SHA          →  AFTER commit
git push
GitHub Actions    →  if .github/workflows/
prod verify       →  docs/commit-push.json
```
