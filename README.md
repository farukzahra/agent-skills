# Agent Skills — Skills.sh Maintainer

Repositório **oficial** das skills publicadas em [skills.sh/farukzahra/agent-skills](https://skills.sh/farukzahra/agent-skills).

**Agente deste workspace:** Skills.sh Maintainer — ver `AGENTS.md` e skill `skills-sh-maintainer`.

[![skills.sh](https://skills.sh/b/farukzahra/agent-skills)](https://skills.sh/farukzahra/agent-skills)

## Skills

### skills-sh-maintainer

Meta-skill: criar, atualizar, publicar e sincronizar skills no skills.sh e no ambiente local (`~/.cursor/skills`, `~/.agents/skills`).

**Use when:** criar skill nova, alterar skill publicada, push para GitHub/skills.sh, instalar globalmente.

### recap

Summarize all user requests from the current AI chat session and produce a concise rich HTML recap (requested vs delivered). Dark mode, product tokens, **clickable topic cards** (mark as seen, `localStorage`). Invoke with `/recap` or ask for a session handoff.

**Use when:**

- End of a long agent session
- User wants "what was asked vs what was delivered"
- Handoff document before closing a chat

### dont-forget

Turn recurring obligations into **executable automation** (CI, hooks, codegen, lint) instead of prose reminders agents skip. Agent proposes the enforcement plan before editing files; prefer failing builds over "remember to do X."

**Use when:**

- User says always, every time, never forget, on each deploy, before commit
- Same instruction was forgotten in prior sessions
- An enforcement check must survive session handoff (counters, sync checks, schema drift)

### semantic-version

Maintains `docs/release-history.json` (semver, changelog entries for `/sobre`). **Only** bump on `/commit-push` when the delivery is user-visible.

### caveman-commit

Ultra-compressed Conventional Commits (≤50 char subject). Pair with `semantic-version` inside `/commit-push`.

### project-init

Bootstrap Superpowers workflow in a project (`/init`): folders, mandatory skills, slash commands, AGENTS gates. **Only when user invokes `/init`**.

### automate-before-manual

Try PAT, SSH, APIs, Azure CLI before manual user steps. Secrets vault at **`../secrets/`** (relative only — never absolute paths in skills).

### dont-be-lazy

When the user is lazy or says **"you do it"**, the agent must not be lazier: discover **API/MCP** first, store credentials in **`../secrets/`** (never commit), then drive the **Cursor browser** to finish the task. User only unblocks OAuth/2FA/captcha.

**Use when:**

- User refuses manual steps or you were about to send a checklist
- No official API yet — still try vault + browser before delegating

### validate-before-share

Verify URLs and previews (HTTP 200 + content) before sending links to the user.

### finish-with-dev-server

After coding tasks: start dev servers on **documented ports**; if port busy, kill **own** process or use **next documented fallback**; report test URLs.

### ask-before-architecture

Do not choose stack/framework alone — ask with 2–4 options and a recommendation.

### diagrams-mermaid

Mermaid for diagrams; **validate syntax** (`mermaid-cli`) before showing the user. No ASCII art.

### ui-change-e2e

E2E required on UI create/change/bugfix; mock writes; run `test:e2e` before done.

### find-job

Search **LinkedIn Jobs** in the Cursor browser from the user's resume: remote / worldwide filters, match scoring, suspicious-employer heuristics, **automatic Easy Apply submission**, HTML report. Invoke with **`/find-job`**. If no CV path is given, ask; default resume lives in **`../faruk`**.

**Use when:**

- User wants LinkedIn job search driven by their CV
- Remote roles abroad with fake-company triage
- User will log in to LinkedIn manually in the browser tab (once)

## Install

```bash
# All skills (global) — re-run after new skills are published
npx skills add farukzahra/agent-skills -g -a cursor -y

# Sync global + every git repo under ../ (reads skills/ folder automatically)
../agent-skills/scripts/sync-faruk-skills.ps1
```

Or on Windows:

```cmd
..\agent-skills\scripts\sync-faruk-skills.cmd
```

## `/commit-push` (all repos)

Canonical command: `reference/commands/commit-push.md`. Install slash commands:

```powershell
../agent-skills/scripts/install-commit-push.ps1
```

In **`agent-skills`**, `/commit-push` also runs `scripts/sync-faruk-skills.ps1` after push (global + every git repo under `C:\repo`).

Per-repo production URL: `docs/commit-push.json` (from `reference/commands/deploy-manifest.json` for known deploys).

## Superpowers + `/init`

**`/init` runs only when you invoke it** in a project chat — it installs mandatory skills, creates `docs/superpowers/`, and merges AGENTS workflow.

Copy slash commands to all repos (no bootstrap):

```powershell
C:\repo\agent-skills\scripts\install-superpowers.ps1
```

Mandatory skills after `/init`: Superpowers + all `farukzahra/agent-skills` (see `scripts/sync-faruk-skills.ps1`).

## Local clone

```text
../agent-skills   ← source of truth; commit + push here
```

## Cursor slash commands

| Command | Repo | Notes |
|---------|------|-------|
| `/skills-sh` | **this repo** | `.cursor/commands/skills-sh.md` |
| `/commit-push` | **all git repos** | `scripts/install-commit-push.ps1` |
| `/init` | **all git repos** | `scripts/install-superpowers.ps1` |
| `/recap` | consumer project | e.g. `terapia/.cursor/commands/recap.md` |
| `/find-job` | **this repo** (+ optional consumer) | `.cursor/commands/find-job.md` |

## License

MIT
