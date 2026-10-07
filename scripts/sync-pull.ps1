#Requires -Version 5.1
<#
.SYNOPSIS
  Fast-forward pull for the ai-config repo. Safe to run on a schedule.
  Each run appends to %LOCALAPPDATA%\ai-config\sync-pull.log.
#>
$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$LogFile = Join-Path $env:LOCALAPPDATA "ai-config\sync-pull.log"

function Write-Log {
  param([string]$Message)
  Write-Host $Message
  $dir = Split-Path -Parent $LogFile
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  Add-Content -LiteralPath $LogFile -Value ("{0} {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message)
}

function Invoke-Git {
  # Windows PowerShell 5.1 turns any native stderr line into a terminating error under Stop,
  # and git fetch writes progress to stderr whenever there is something to fetch.
  $ErrorActionPreference = "Continue"
  $all = & git @args 2>&1
  $code = $LASTEXITCODE
  [pscustomobject]@{
    ExitCode = $code
    Output   = @($all | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | ForEach-Object { "$_" })
    Errors   = @($all | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] } | ForEach-Object { "$_" })
  }
}

function Assert-Git {
  param($Result, [string]$What)
  if ($Result.ExitCode -ne 0) { throw ("{0} failed: {1}" -f $What, ($Result.Errors -join " ")) }
}

Push-Location $RepoRoot
try {
  if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot ".git"))) {
    throw "Not a git repository: $RepoRoot"
  }

  $status = Invoke-Git status --porcelain
  Assert-Git $status "git status"
  if ($status.Output.Count -gt 0) {
    Write-Log "SKIP pull: working tree has local changes"
    exit 0
  }

  Assert-Git (Invoke-Git fetch origin) "git fetch"

  $branch = (Invoke-Git symbolic-ref --quiet --short HEAD).Output | Select-Object -First 1
  if (-not $branch) {
    Write-Log "SKIP pull: detached HEAD"
    exit 0
  }

  $upstream = "origin/$branch"
  $remote = Invoke-Git rev-parse --verify --quiet $upstream
  if ($remote.ExitCode -ne 0) {
    Write-Log "SKIP pull: no upstream $upstream"
    exit 0
  }
  $remoteHead = $remote.Output | Select-Object -First 1

  $local = Invoke-Git rev-parse HEAD
  Assert-Git $local "git rev-parse HEAD"
  $localHead = $local.Output | Select-Object -First 1

  if ($localHead -eq $remoteHead) {
    Write-Log "Already up to date ($branch)"
    exit 0
  }

  $base = Invoke-Git merge-base HEAD $upstream
  Assert-Git $base "git merge-base"
  if (($base.Output | Select-Object -First 1) -ne $localHead) {
    Write-Log "SKIP pull: local commits not pushed; push or rebase first"
    exit 0
  }

  Assert-Git (Invoke-Git merge --ff-only $upstream) "git merge --ff-only"

  & (Join-Path $PSScriptRoot "build-agents.ps1") | Out-Host
  Write-Log "Pulled and rebuilt standards ($branch)"
} catch {
  Write-Log ("ERROR " + $_.Exception.Message)
  exit 1
} finally {
  Pop-Location
}
