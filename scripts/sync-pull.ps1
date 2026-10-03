#Requires -Version 5.1
<#
.SYNOPSIS
  Fast-forward pull for the ai-config repo. Safe to run on a schedule.
#>
$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Push-Location $RepoRoot
try {
  if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot ".git"))) {
    throw "Not a git repository: $RepoRoot"
  }

  $porcelain = git status --porcelain 2>&1
  if ($LASTEXITCODE -ne 0) { throw "git status failed" }
  if ($porcelain) {
    Write-Host "SKIP pull: working tree has local changes"
    exit 0
  }

  git fetch origin 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { throw "git fetch failed" }

  $branch = git symbolic-ref --quiet --short HEAD 2>$null
  if (-not $branch) {
    Write-Host "SKIP pull: detached HEAD"
    exit 0
  }

  $upstream = "origin/$branch"
  $mergeBase = git merge-base HEAD $upstream 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "SKIP pull: no upstream $upstream"
    exit 0
  }

  $localHead = git rev-parse HEAD
  $remoteHead = git rev-parse $upstream 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "SKIP pull: cannot resolve $upstream"
    exit 0
  }

  if ($localHead -eq $remoteHead) {
    Write-Host "Already up to date ($branch)"
    exit 0
  }

  if ($mergeBase -ne $localHead) {
    Write-Host "SKIP pull: local commits not pushed; push or rebase first"
    exit 0
  }

  git merge --ff-only $upstream 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { throw "git merge --ff-only failed" }

  & (Join-Path $PSScriptRoot "build-agents.ps1") | Out-Host
  Write-Host "Pulled and rebuilt standards ($branch)"
} finally {
  Pop-Location
}
