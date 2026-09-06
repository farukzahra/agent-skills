# Install Superpowers bootstrap (/init) in all git repos under C:\repo
$ErrorActionPreference = "Stop"
$Root = "C:\repo\agent-skills"
$InitSrc = Join-Path $Root "reference\commands\init.md"
$DocsReadmeSrc = Join-Path $Root "reference\superpowers\docs-README.md"
$LockSrc = Join-Path $Root "reference\superpowers\skills-lock.core.json"
$CommitPushScript = Join-Path $Root "scripts\install-commit-push.ps1"
$RulesSrc = "C:\repo\faruk_base\.cursor\rules"
$SkipDirs = @('secrets', 'docker', '.idea', 'vps keys')
$SnippetMarker = "## Superpowers workflow"

function Ensure-Dir($path) {
    if (-not (Test-Path $path)) { New-Item -ItemType Directory -Force -Path $path | Out-Null }
}

$installed = @()
Get-ChildItem "C:\repo" -Directory | Where-Object { $SkipDirs -notcontains $_.Name } | ForEach-Object {
    $repoDir = $_.FullName
    $name = $_.Name
    if (-not (Test-Path (Join-Path $repoDir ".git"))) { return }

    # docs/superpowers
    $sp = Join-Path $repoDir "docs\superpowers"
    $specs = Join-Path $sp "specs"
    $plans = Join-Path $sp "plans"
    Ensure-Dir $specs
    Ensure-Dir $plans
    $readme = Join-Path $sp "README.md"
    if (-not (Test-Path $readme)) { Copy-Item $DocsReadmeSrc $readme -Force }

    # skills-lock.json (core only if missing)
    $lock = Join-Path $repoDir "skills-lock.json"
    $createdLock = $false
    if (-not (Test-Path $lock)) {
        Copy-Item $LockSrc $lock -Force
        $createdLock = $true
    }

    # slash commands
    $cmdDir = Join-Path $repoDir ".cursor\commands"
    Ensure-Dir $cmdDir
    Copy-Item $InitSrc (Join-Path $cmdDir "init.md") -Force

    # cursor rules (only if folder empty)
    $rulesDir = Join-Path $repoDir ".cursor\rules"
    if (-not (Test-Path $rulesDir) -or @(Get-ChildItem $rulesDir -ErrorAction SilentlyContinue).Count -eq 0) {
        Ensure-Dir $rulesDir
        if (Test-Path $RulesSrc) {
            Copy-Item (Join-Path $RulesSrc "*.mdc") $rulesDir -Force
        }
    }

    # AGENTS.md snippet
    $agents = @(
        (Join-Path $repoDir "AGENTS.md"),
        (Join-Path $repoDir "agents.md")
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($agents) {
        $content = Get-Content $agents -Raw
        if ($content -notmatch 'Superpowers workflow') {
            $snippet = @"

## Superpowers workflow

| Phase | Skill | Output |
|-------|-------|--------|
| Design | ``brainstorming`` | Approved design → ``docs/superpowers/specs/YYYY-MM-DD-*-design.md`` |
| Plan | ``writing-plans`` | ``docs/superpowers/plans/YYYY-MM-DD-*.md`` |
| Build | stack skills + ``tdd`` | Code + tests |
| Verify | ``verification-before-completion`` | Evidence before "done" |
| Debug | ``systematic-debugging`` | Root cause before fix |
| Ship | ``/commit-push`` | ``semantic-version`` + ``caveman-commit`` + push + CI |

**Gates:** no feature code before approved spec; no "done" without verification; version bump only on ``/commit-push``.

Invoke ``/init`` to (re)bootstrap skills and folders.
"@
            Add-Content -Path $agents -Value $snippet -Encoding utf8
        }
    } else {
        $minimal = @"
# AGENTS.md

## Superpowers workflow

| Phase | Skill | Output |
|-------|-------|--------|
| Design | ``brainstorming`` | ``docs/superpowers/specs/`` |
| Plan | ``writing-plans`` | ``docs/superpowers/plans/`` |
| Verify | ``verification-before-completion`` | Evidence before done |
| Ship | ``/commit-push`` | Version + push + CI |

Run ``/init`` for full bootstrap.
"@
        Set-Content (Join-Path $repoDir "AGENTS.md") $minimal -Encoding utf8
    }

    # Install skills (project-level)
    Push-Location $repoDir
    try {
        if ($createdLock -or (Test-Path ".agents\skills\brainstorming\SKILL.md") -eq $false) {
            npx skills experimental_install -y 2>&1 | Out-Null
        }
        npx skills add farukzahra/agent-skills --skill semantic-version --skill caveman-commit -a cursor -y 2>&1 | Out-Null
    } catch {
        Write-Warning "Skills install partial in ${name}: $_"
    }
    Pop-Location

    $installed += $name
}

& $CommitPushScript

Write-Host "Superpowers bootstrap in $($installed.Count) repos:"
$installed | Sort-Object | ForEach-Object { Write-Host "  - $_" }
