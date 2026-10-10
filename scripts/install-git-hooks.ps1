#Requires -Version 5.1
<#
.SYNOPSIS
  Copy the global commit-policy hooks to ~/.githooks and point core.hooksPath at them.
#>
$ErrorActionPreference = "Stop"

$HooksSrc = Join-Path $PSScriptRoot "git-hooks\global"
$HooksDest = Join-Path $HOME ".githooks"
$Hooks = @("prepare-commit-msg", "commit-msg", "pre-push", "post-commit")

if (-not (Get-Command python3 -ErrorAction SilentlyContinue)) {
  throw "python3 is required by the commit-msg, prepare-commit-msg, and pre-push hooks."
}

if (-not (Test-Path $HooksDest)) {
  New-Item -ItemType Directory -Path $HooksDest -Force | Out-Null
}

foreach ($hook in $Hooks) {
  $src = Join-Path $HooksSrc $hook
  if (-not (Test-Path -LiteralPath $src)) {
    throw "Missing hook: $src"
  }
  $dest = Join-Path $HooksDest $hook
  $body = Get-Content -LiteralPath $src -Raw -Encoding UTF8
  $body = $body -replace "`r`n", "`n" -replace "`r", "`n"
  if (-not $body.EndsWith("`n")) { $body += "`n" }
  [System.IO.File]::WriteAllText($dest, $body, [System.Text.UTF8Encoding]::new($false))
  Write-Host "Hook  $dest"
}

$hooksPath = $HooksDest -replace "\\", "/"
$current = git config --global core.hooksPath
if ($current -ne $hooksPath) {
  git config --global core.hooksPath $hooksPath
}
Write-Host "core.hooksPath=$(git config --global core.hooksPath)"
Write-Host ""
Write-Host "Done. Edit scripts/git-hooks/global/, then re-run this script."
