# dont-forget skill update — handoff for Skills.sh Maintainer

**Date:** 2026-09-07  
**Repo:** `C:\repo\agent-skills`  
**Skill path:** `skills/dont-forget/`  
**Trigger:** Blog article rewrite + user feedback (article felt like AI slop; core idea was under-documented)

## Goal

Align `dont-forget` with the **actual product intent**: when a recurring obligation must survive session handoff, the agent **chooses** what executable enforcement fits the repo, **proposes it to the user before editing files**, and only implements after approval.

## What is correct today (keep)

- Obligation → automation, not prose reminders
- Enforcement ladder (tiers 1–9) as decision aid
- When to use / when NOT to use
- Decision checklist (concrete event, visible failure, discoverable in repo)
- Domain patterns in `reference/examples.md`
- Anti-patterns table (useful for the agent; blog article should not copy it verbatim)
- `Report to user` after implementation (what / where / what fails / no memory reliance)

## Gaps to fix (required)

### 1. Add **proposal-before-implementation** gate (core)

**Problem:** Workflow jumps from step 3 (choose tier) to step 4 (implement). User must approve the plan first.

**Insert new step 3b** between “Choose enforcement tier” and “Implement the smallest hard gate”:

```markdown
3b. **Propose to user (before any file edits)** — Present in plain language:
   - The obligation (one sentence, observable)
   - The trigger (deploy, commit, PR, schedule, etc.)
   - Chosen mechanism and tier (e.g. “GitHub Actions step after deploy — tier 1”)
   - Files to create or change
   - What fails or blocks if the obligation is skipped
   - Optional: one-line `AGENTS.md` pointer you will add after implementation

   **Wait for user approval or adjustment.** Do not implement until the user confirms.
```

**Update step 4** intro: “After user approval, implement…”

**Update “Report to user”** section: clarify this is **post-implementation confirmation**, not a substitute for the pre-implementation proposal.

**Update decision checklist** — add:

```markdown
- [ ] User saw and approved the enforcement proposal before code changed
```

### 2. Clarify **agent chooses mechanism at runtime**

Add a short paragraph near the top (after Default):

> The agent picks the **highest tier that fits this repo** — CI step, hook, failing test, codegen diff, npm script chain, etc. The “software” is whatever executable gate matches the obligation and trigger; not a fixed recipe.

### 3. Terminology: **enforcement**, not “guardrails”

**Problem:** “guardrails” reads like LLM safety / output filtering. This skill is **obligation enforcement** or **verification gates**.

**Changes:**

| Location | Action |
|----------|--------|
| Line ~21 “guardrail must survive” | → “enforcement must survive” or “check must survive” |
| Section “Agent-specific guardrails” | Rename → **“Agent-specific enforcement”** |
| Anywhere else | Prefer *enforcement*, *hard gate*, *verification* |

Optional one-liner in skill body:

> Not “AI safety guardrails” — **enforcement**: repo machinery that fails when an obligation was skipped.

### 4. Documentation pointer: **AGENTS.md first**

Step 7 currently says “README or AGENTS.md”. Refine:

```markdown
7. **Document briefly** — one line pointing at the automation:
   - **AGENTS.md** (preferred in Cursor/agent repos): e.g. `Deploy counter: auto-incremented in .github/workflows/deploy.yml`
   - **README.md** when operators without agents need it
   - Never a paragraph asking future agents to remember
```

Update deploy counter example item 4: `AGENTS.md` (not README only).

### 5. Expand deploy counter example with **proposal sample**

After “User: Increment a counter every deploy — you forgot three times.” add:

```markdown
**Propose (before coding):**

> **Obligation:** `deploy-count.json` increments on every successful production deploy.
> **Trigger:** GitHub Actions deploy workflow, after health check passes.
> **Mechanism:** Tier 1 — workflow step runs `scripts/increment-deploy-count.sh` and commits or updates the counter file.
> **Files:** `.github/workflows/deploy.yml`, `scripts/increment-deploy-count.sh`, `deploy-count.json`
> **If skipped:** deploy job fails (or counter stays stale — prefer failing the step).
> **AGENTS.md line:** `Deploy count: see .github/workflows/deploy.yml`

Approve to implement?
```

Then keep existing **Do:** / **Don't:** lists.

## Files to touch

| File | Changes |
|------|---------|
| `skills/dont-forget/SKILL.md` | Steps 3b, 4, 7, terminology, deploy example, checklist |
| `skills/dont-forget/reference/examples.md` | Optional: add “propose first” note in intro |
| `README.md` | If one-liner description changes, sync (optional) |

## Out of scope (do not add to skill)

- Separate “verification software” product / future app — blog may mention as vision; skill stays repo-local enforcement
- Mandatory global rollout — still ask per `rollout.md` after publish

## Verification before push

1. Read full `SKILL.md` — workflow reads: obligation → trigger → tier → **propose → approve** → implement → verify → document
2. No standalone “I’ll remember” path without proposal step
3. `npx skills` / skills.sh listing unchanged unless description field updated
4. Commit: `fix(dont-forget): require user approval before enforcement implementation`
5. Push `main`, sync `~/.cursor/skills/dont-forget` and `~/.agents/skills/dont-forget`
6. Report commit hash + skills.sh URL

## Blog alignment (separate repo)

Blog article `dont-forget-obligation-as-automation` is being rewritten to match this spec. After skill push, blog should cite behavior that exists in `main` of `farukzahra/agent-skills`.
