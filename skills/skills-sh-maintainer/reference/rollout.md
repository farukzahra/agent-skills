# Skill rollout — global vs per-repo

## Two scopes

| Scope | Command | Where it lands | When to use |
|-------|---------|----------------|-------------|
| **Global** (recommended) | `npx skills add farukzahra/agent-skills --skill <name> -g -a cursor -y` | `~/.cursor/skills/` + `~/.agents/skills/` | Skill useful in **any** project under `C:\repo` |
| **Per-repo** | `npx skills add farukzahra/agent-skills --skill <name> -a cursor -y` (no `-g`) | `<repo>/.cursor/skills/` | Skill should be **versioned with the repo** or team-shared via git |

**Global install once** = available in every Cursor workspace (all folders under `C:\repo`). No need to repeat per repo unless you want the skill committed in git.

## Classify before rollout

| Type | Examples | Agent behavior after publish |
|------|----------|------------------------------|
| **Cross-repo** | `recap`, `dont-forget` | **Ask user:** "Instalar globalmente (todos os projetos em `C:\repo`)?" |
| **Workspace-specific** | `skills-sh-maintainer` | Sync `~/.cursor/skills/` only; **do not** offer bulk `C:\repo` rollout |

Workspace-specific skills only make sense when working in `C:\repo\agent-skills` (publish workflow, skills.sh meta).

## Global install (one command)

```bash
npx skills add farukzahra/agent-skills --skill dont-forget -g -a cursor -y
```

Verify:

```bash
npx skills ls -g -a cursor
```

## Bulk per-repo install (all git repos under C:\repo)

Use only when the user explicitly wants skills **inside each repo** (committed to git).

```powershell
$skill = "dont-forget"
$repos = Get-ChildItem "C:\repo" -Directory | Where-Object {
    $_.Name -notin @('secrets', 'docker', '.idea', 'vps keys')
    Test-Path (Join-Path $_.FullName ".git")
}
foreach ($repo in $repos) {
    Write-Host "Installing $skill in $($repo.Name)..."
    Push-Location $repo.FullName
    npx skills add farukzahra/agent-skills --skill $skill -a cursor -y
    Pop-Location
}
```

Skip non-project folders: `secrets`, `docker`, `.idea`, etc.

After per-repo install, each repo gets `.cursor/skills/` (or skills-lock) — commit if the team should share it.

## Update all global skills

```bash
npx skills update -g -y
```
