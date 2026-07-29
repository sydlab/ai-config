#Requires -Version 5.1
<#
.SYNOPSIS
  Build AGENTS.md from rules/, then link/copy it into every git repo under ~/Tech/repos.
  Prefers symlink (cmd mklink); falls back to copy.
  Adds AGENTS.md to each repo's local .git/info/exclude (not committed).
#>
$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$Dotfiles = (Resolve-Path (Join-Path $ScriptDir "..")).Path

& (Join-Path $ScriptDir "build-agents.ps1")
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
  throw "build-agents.ps1 failed"
}

$AgentsSrc = Join-Path $Dotfiles "AGENTS.md"
$AgentsSrcFull = (Resolve-Path -LiteralPath $AgentsSrc).Path

$ReposRoot = Join-Path $HOME "Tech\repos"
if (-not (Test-Path $ReposRoot)) {
  throw "Repos root not found: $ReposRoot"
}

$linked = 0
$skipped = 0
$failed = 0

function Ensure-Exclude {
  param([string]$Repo)
  $exclude = Join-Path $Repo ".git\info\exclude"
  $excludeDir = Split-Path $exclude -Parent
  if (-not (Test-Path $excludeDir)) {
    New-Item -ItemType Directory -Path $excludeDir -Force | Out-Null
  }
  $existing = @()
  if (Test-Path $exclude) {
    $existing = Get-Content -LiteralPath $exclude -ErrorAction SilentlyContinue
  }
  if ($existing -notcontains "AGENTS.md") {
    Add-Content -LiteralPath $exclude -Value "AGENTS.md"
  }
}

function New-AgentsLink {
  param(
    [string]$Dest,
    [string]$Target
  )
  if (Test-Path -LiteralPath $Dest) {
    Remove-Item -LiteralPath $Dest -Force
  }
  $p = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "mklink", "`"$Dest`"", "`"$Target`"") -Wait -PassThru -NoNewWindow
  if ($p.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $Dest)) {
    throw "mklink failed (exit $($p.ExitCode))"
  }
  $item = Get-Item -LiteralPath $Dest -Force
  if ($item.LinkType -ne "SymbolicLink") {
    throw "created path is not a SymbolicLink"
  }
}

Get-ChildItem -Path $ReposRoot -Directory | ForEach-Object {
  $repo = $_.FullName
  if (-not (Test-Path (Join-Path $repo ".git"))) {
    $script:skipped++
    return
  }

  $dest = Join-Path $repo "AGENTS.md"
  try {
    if ($repo -eq $Dotfiles) {
      Ensure-Exclude $repo
      Write-Host "OK  $repo (source)"
      $script:linked++
      return
    }

    $mode = "link"
    try {
      New-AgentsLink -Dest $dest -Target $AgentsSrcFull
    } catch {
      $mode = "copy"
      if (Test-Path -LiteralPath $dest) {
        Remove-Item -LiteralPath $dest -Force
      }
      Copy-Item -LiteralPath $AgentsSrcFull -Destination $dest -Force
    }

    Ensure-Exclude $repo
    if ($mode -eq "link") {
      Write-Host "OK  $repo"
    } else {
      Write-Host "COPY $repo"
    }
    $script:linked++
  } catch {
    Write-Host ("FAIL {0} - {1}" -f $repo, $_.Exception.Message)
    $script:failed++
  }
}

Write-Host ""
Write-Host ("Done: {0}  Skipped: {1}  Failed: {2}" -f $linked, $skipped, $failed)
Write-Host "Edit rules/*.md only. Re-run install after changes (symlinks pick up rebuilt AGENTS.md)."
if ($failed -gt 0) { exit 1 }
