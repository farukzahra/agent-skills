# Install standardized /commit-push to all git repos under C:\repo
$ErrorActionPreference = "Stop"
$Root = "C:\repo\agent-skills"
$CommandSrc = Join-Path $Root "reference\commands\commit-push.md"
$ManifestPath = Join-Path $Root "reference\commands\deploy-manifest.json"
$SkipDirs = @('secrets', 'docker', '.idea', 'vps keys')
$manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json

function Get-GitHubFromRemote($remote) {
    if (-not $remote) { return $null }
    if ($remote -match 'github\.com[:/]([^/]+)/([^/.]+)') {
        return @{ owner = $Matches[1]; repo = $Matches[2].Replace('.git', '') }
    }
    return $null
}

$installed = @()
Get-ChildItem "C:\repo" -Directory | Where-Object { $SkipDirs -notcontains $_.Name } | ForEach-Object {
    $repoDir = $_.FullName
    $name = $_.Name
    if (-not (Test-Path (Join-Path $repoDir ".git"))) { return }

    $cmdDir = Join-Path $repoDir ".cursor\commands"
    New-Item -ItemType Directory -Force -Path $cmdDir | Out-Null
    Copy-Item $CommandSrc (Join-Path $cmdDir "commit-push.md") -Force

    $docsDir = Join-Path $repoDir "docs"
    $cfgPath = Join-Path $docsDir "commit-push.json"
    $entry = $manifest.$name
    if ($entry) {
        New-Item -ItemType Directory -Force -Path $docsDir | Out-Null
        $entry | ConvertTo-Json -Depth 6 | Set-Content $cfgPath -Encoding utf8
    } elseif (Test-Path (Join-Path $repoDir ".github\workflows")) {
        Push-Location $repoDir
        $remote = git remote get-url origin 2>$null
        Pop-Location
        $gh = Get-GitHubFromRemote $remote
        if ($gh) {
            New-Item -ItemType Directory -Force -Path $docsDir | Out-Null
            @{
                github = $gh
                verify = $null
            } | ConvertTo-Json -Depth 4 | Set-Content $cfgPath -Encoding utf8
        }
    }

    $installed += $name
}

Write-Host "Installed commit-push in $($installed.Count) repos:"
$installed | Sort-Object | ForEach-Object { Write-Host "  - $_" }
