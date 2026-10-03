#Requires -Version 5.1
<#
.SYNOPSIS
  Build build/00-personal-standards.mdc from standards/*.md. Do not hand-edit the built file.
#>
$ErrorActionPreference = "Stop"

$Dotfiles = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$StandardsDir = Join-Path $Dotfiles "standards"
$OutDir = Join-Path $Dotfiles "build"
$OutFile = Join-Path $OutDir "00-personal-standards.mdc"

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
  $path = Join-Path $StandardsDir $name
  if (-not (Test-Path -LiteralPath $path)) {
    $missing += $name
  }
}
if ($missing.Count -gt 0) {
  throw ("Missing standards files: {0}" -f ($missing -join ", "))
}

if (-not (Test-Path $OutDir)) {
  New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
}

$parts = New-Object System.Collections.Generic.List[string]
foreach ($name in $Order) {
  $path = Join-Path $StandardsDir $name
  $body = (Get-Content -LiteralPath $path -Raw -Encoding UTF8).TrimEnd()
  $parts.Add($body)
}

$header = @"
---
description: Personal global standards (from ai-config)
alwaysApply: true
---

# Agent instructions
"@.TrimEnd()
$text = $header + "`n`n" + ($parts -join "`n`n") + "`n"
$text = $text -replace "`r`n", "`n" -replace "`r", "`n"
if (-not $text.EndsWith("`n")) { $text += "`n" }
[System.IO.File]::WriteAllText($OutFile, $text, [System.Text.UTF8Encoding]::new($false))

Write-Host "Built $OutFile"
