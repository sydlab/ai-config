#Requires -Version 5.1
<#
.SYNOPSIS
  Build AGENTS.md from rules/*.md (source of truth). Do not hand-edit AGENTS.md.
#>
$ErrorActionPreference = "Stop"

$Dotfiles = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$RulesDir = Join-Path $Dotfiles "rules"
$OutFile = Join-Path $Dotfiles "AGENTS.md"

# Stable order — not filesystem sort
$Order = @(
  "security.md",
  "git.md",
  "code.md",
  "environment.md",
  "behavior.md",
  "decision-authority.md"
)

$missing = @()
foreach ($name in $Order) {
  $path = Join-Path $RulesDir $name
  if (-not (Test-Path -LiteralPath $path)) {
    $missing += $name
  }
}
if ($missing.Count -gt 0) {
  throw ("Missing rule files: {0}" -f ($missing -join ", "))
}

$parts = New-Object System.Collections.Generic.List[string]
$parts.Add(@"
<!-- GENERATED from rules/*.md - do not edit by hand. Run: .\scripts\install.ps1 (or .\scripts\build-agents.ps1) -->

# Agent instructions

Personal global standards for Cursor CLI (and any tool that reads ``AGENTS.md``).
Edit files under ``rules/``, then rebuild. Source of truth is ``rules/``, not this file.
"@)

foreach ($name in $Order) {
  $path = Join-Path $RulesDir $name
  $body = (Get-Content -LiteralPath $path -Raw).TrimEnd()
  $parts.Add("")
  $parts.Add($body)
}

$text = ($parts -join "`n") + "`n"
# Normalize to LF for stable diffs across machines
$text = $text -replace "`r`n", "`n" -replace "`r", "`n"
[System.IO.File]::WriteAllText($OutFile, $text, [System.Text.UTF8Encoding]::new($false))

Write-Host "Built $OutFile"
