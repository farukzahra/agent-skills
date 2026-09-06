# Sync all published skills from farukzahra/agent-skills into every git repo under ../
# and refresh global Cursor copies. Re-run after adding skills to the agent-skills repo.
param(
    [switch]$GlobalOnly,
    [switch]$ProjectOnly
)

$ErrorActionPreference = "Stop"
$AgentSkillsRoot = Split-Path $PSScriptRoot -Parent
$RepoParent = Split-Path $AgentSkillsRoot -Parent
$SkipDirs = @('secrets', 'docker', '.idea', 'vps keys')

# Discover skills from repo (always picks up new folders under skills/)
$AllSkills = Get-ChildItem (Join-Path $AgentSkillsRoot "skills") -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object

$DefaultSkills = $AllSkills | Where-Object { $_ -ne 'skills-sh-maintainer' }
$MaintainerSkill = 'skills-sh-maintainer'

function Install-SkillSet {
    param([string[]]$SkillNames, [string]$Scope)  # Scope: 'project' or 'global'
    if ($SkillNames.Count -eq 0) { return }
    $args = @('skills', 'add', 'farukzahra/agent-skills', '-a', 'cursor', '-y')
    foreach ($s in $SkillNames) { $args += '--skill'; $args += $s }
    if ($Scope -eq 'global') { $args += '-g' }
    & npx @args 2>&1 | Out-Null
}

if (-not $ProjectOnly) {
    Write-Host "Global install: $($DefaultSkills.Count) skills (+ maintainer on agent-skills machine)"
    Install-SkillSet -SkillNames $DefaultSkills -Scope 'global'
    Install-SkillSet -SkillNames @($MaintainerSkill) -Scope 'global'
}

if (-not $GlobalOnly) {
    $repos = Get-ChildItem $RepoParent -Directory |
        Where-Object { $SkipDirs -notcontains $_.Name -and (Test-Path (Join-Path $_.FullName ".git")) }

    foreach ($repo in $repos) {
        $name = $repo.Name
        $skills = [string[]]$DefaultSkills
        if ($name -eq 'agent-skills') { $skills += $MaintainerSkill }
        Write-Host "Project: $name ($($skills.Count) skills)"
        Push-Location $repo.FullName
        try { Install-SkillSet -SkillNames $skills -Scope 'project' }
        finally { Pop-Location }
    }
}

# Local source-of-truth copies (dev machine)
$cursorSkills = Join-Path $env:USERPROFILE ".cursor\skills"
$agentsSkills = Join-Path $env:USERPROFILE ".agents\skills"
foreach ($s in $AllSkills) {
    $src = Join-Path $AgentSkillsRoot "skills\$s"
    Copy-Item -Recurse $src (Join-Path $cursorSkills $s) -Force -ErrorAction SilentlyContinue
    Copy-Item -Recurse $src (Join-Path $agentsSkills $s) -Force -ErrorAction SilentlyContinue
}

Write-Host "Done. Skills synced: $($AllSkills -join ', ')"
