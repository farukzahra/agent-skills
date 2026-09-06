# Copy /init and /commit-push slash commands only — does NOT run /init bootstrap.
# Full bootstrap (skills, folders, AGENTS) happens when user invokes /init in that repo.
$ErrorActionPreference = "Stop"
$Root = "C:\repo\agent-skills"
$InitSrc = Join-Path $Root "reference\commands\init.md"
$CommitPushScript = Join-Path $Root "scripts\install-commit-push.ps1"
$SkipDirs = @('secrets', 'docker', '.idea', 'vps keys')

$installed = @()
Get-ChildItem "C:\repo" -Directory | Where-Object { $SkipDirs -notcontains $_.Name } | ForEach-Object {
    $repoDir = $_.FullName
    if (-not (Test-Path (Join-Path $repoDir ".git"))) { return }

    $cmdDir = Join-Path $repoDir ".cursor\commands"
    New-Item -ItemType Directory -Force -Path $cmdDir | Out-Null
    Copy-Item $InitSrc (Join-Path $cmdDir "init.md") -Force
    $installed += $_.Name
}

& $CommitPushScript

Write-Host "Slash commands only (init + commit-push) in $($installed.Count) repos."
Write-Host "Run /init in each project when you want full Superpowers bootstrap."
