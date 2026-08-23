#Requires -Version 5.1
<#
.SYNOPSIS
  Build AGENTS.md from rules/, link/copy into git repos under ~/Tech (skip projects),
  and write ~/.cursor/rules/00-personal-standards.mdc for IDE Agent.
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

$TechRoot = Join-Path $HOME "Tech"
if (-not (Test-Path $TechRoot)) {
  throw "Tech root not found: $TechRoot"
}

$ProjectsRoot = [System.IO.Path]::GetFullPath((Join-Path $TechRoot "projects"))
$CursorRulesDir = Join-Path $HOME ".cursor\rules"
$MdcPath = Join-Path $CursorRulesDir "00-personal-standards.mdc"
$GitWorkflowSrc = Join-Path $Dotfiles "rules\git-workflow.md"
$GitWorkflowMdc = Join-Path $CursorRulesDir "10-git-workflow.mdc"

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

function Test-UnderProjects {
  param([string]$Path)
  $full = [System.IO.Path]::GetFullPath($Path)
  if (-not (Test-Path -LiteralPath $ProjectsRoot)) { return $false }
  return $full.StartsWith($ProjectsRoot.TrimEnd('\') + '\', [System.StringComparison]::OrdinalIgnoreCase) -or
    $full.Equals($ProjectsRoot, [System.StringComparison]::OrdinalIgnoreCase)
}

function Write-IdeRules {
  if (-not (Test-Path $CursorRulesDir)) {
    New-Item -ItemType Directory -Path $CursorRulesDir -Force | Out-Null
  }

  $raw = Get-Content -LiteralPath $AgentsSrcFull -Raw -Encoding UTF8
  $idx = $raw.IndexOf("# Security")
  if ($idx -lt 0) { throw "AGENTS.md missing # Security section" }
  $body = $raw.Substring($idx).TrimEnd() + "`n"
  $mdc = @"
---
description: Personal global standards (from cursor-dotfiles)
alwaysApply: true
---

# Agent instructions

$body
"@
  $mdc = $mdc -replace "`r`n", "`n" -replace "`r", "`n"
  if (-not $mdc.EndsWith("`n")) { $mdc += "`n" }
  [System.IO.File]::WriteAllText($MdcPath, $mdc, [System.Text.UTF8Encoding]::new($false))
  Write-Host "IDE  $MdcPath"

  if (-not (Test-Path -LiteralPath $GitWorkflowSrc)) {
    throw "Missing $GitWorkflowSrc"
  }
  $wfBody = (Get-Content -LiteralPath $GitWorkflowSrc -Raw -Encoding UTF8).TrimEnd() + "`n"
  $wfMdc = @"
---
description: Git commit, PR, and post-merge cleanup procedures - use when committing, opening a PR, merging, or cleaning up branches
alwaysApply: false
---

$wfBody
"@
  $wfMdc = $wfMdc -replace "`r`n", "`n" -replace "`r", "`n"
  if (-not $wfMdc.EndsWith("`n")) { $wfMdc += "`n" }
  [System.IO.File]::WriteAllText($GitWorkflowMdc, $wfMdc, [System.Text.UTF8Encoding]::new($false))
  Write-Host "IDE  $GitWorkflowMdc (agent-requested)"
}

Write-IdeRules

$repos = @(
  Get-ChildItem -Path $TechRoot -Directory -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".git") } |
    ForEach-Object { $_.FullName }
) | Sort-Object -Unique

foreach ($repo in $repos) {
  if (Test-UnderProjects $repo) {
    Write-Host "SKIP $repo (projects)"
    $skipped++
    continue
  }

  $dest = Join-Path $repo "AGENTS.md"
  try {
    if ($repo -eq $Dotfiles) {
      Ensure-Exclude $repo
      Write-Host "OK  $repo (source)"
      $linked++
      continue
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
    $linked++
  } catch {
    Write-Host ("FAIL {0} - {1}" -f $repo, $_.Exception.Message)
    $failed++
  }
}

Write-Host ""
Write-Host ("Done: {0}  Skipped: {1}  Failed: {2}" -f $linked, $skipped, $failed)
Write-Host "Edit rules/*.md only. Re-run install after changes."
if ($failed -gt 0) { exit 1 }
