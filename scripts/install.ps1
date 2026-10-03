#Requires -Version 5.1
<#
.SYNOPSIS
  Build the Cursor standards rule from standards/, then symlink it and the git-workflow skill into the home directory.
  Does not copy AGENTS.md into other repositories.
#>
$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$Dotfiles = (Resolve-Path (Join-Path $ScriptDir "..")).Path

& (Join-Path $ScriptDir "build-agents.ps1")
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
  throw "build-agents.ps1 failed"
}

$BuiltMdc = (Resolve-Path -LiteralPath (Join-Path $Dotfiles "build\00-personal-standards.mdc")).Path
$SkillSrc = (Resolve-Path -LiteralPath (Join-Path $Dotfiles "skills\git-workflow")).Path

$CursorRulesDir = Join-Path $HOME ".cursor\rules"
$MdcPath = Join-Path $CursorRulesDir "00-personal-standards.mdc"
$OldWorkflowMdc = Join-Path $CursorRulesDir "10-git-workflow.mdc"
$AgentsSkillsDir = Join-Path $HOME ".agents\skills"
$SkillDest = Join-Path $AgentsSkillsDir "git-workflow"

function Remove-ExistingLinkTarget {
  param(
    [string]$Path,
    [switch]$AllowFile
  )
  if (-not (Test-Path -LiteralPath $Path)) { return }

  $item = Get-Item -LiteralPath $Path -Force
  $isLink = $item.Attributes -band [IO.FileAttributes]::ReparsePoint
  if ($isLink) {
    if ($item.PSIsContainer) {
      $proc = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "rmdir", "`"$Path`"") -Wait -PassThru -NoNewWindow
    } else {
      $proc = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "del", "`"$Path`"") -Wait -PassThru -NoNewWindow
    }
    if ($proc.ExitCode -ne 0 -or (Test-Path -LiteralPath $Path)) {
      throw "Could not remove existing symlink: $Path"
    }
    return
  }

  if ($AllowFile -and -not $item.PSIsContainer) {
    Remove-Item -LiteralPath $Path -Force
    return
  }

  throw "Refusing to replace $Path because it is not a symlink. Move it aside, then re-run install."
}

function New-Symlink {
  param(
    [string]$Dest,
    [string]$Target,
    [switch]$Directory
  )
  $linkArgs = @("/c", "mklink")
  if ($Directory) { $linkArgs += "/D" }
  $linkArgs += @("`"$Dest`"", "`"$Target`"")
  $proc = Start-Process -FilePath "cmd.exe" -ArgumentList $linkArgs -Wait -PassThru -NoNewWindow
  if ($proc.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $Dest)) {
    throw "Could not create symlink $Dest -> $Target. Enable Windows Developer Mode (Settings, System, For developers), then re-run install. No copy was made."
  }
  $item = Get-Item -LiteralPath $Dest -Force
  if ($item.LinkType -ne "SymbolicLink") {
    if ($item.PSIsContainer) {
      Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "rmdir", "`"$Dest`"") -Wait -NoNewWindow | Out-Null
    } else {
      Remove-Item -LiteralPath $Dest -Force -ErrorAction SilentlyContinue
    }
    throw "Created path is not a symlink: $Dest. Enable Windows Developer Mode, then re-run install. No copy was left in place."
  }
}

if (-not (Test-Path $CursorRulesDir)) {
  New-Item -ItemType Directory -Path $CursorRulesDir -Force | Out-Null
}
if (-not (Test-Path $AgentsSkillsDir)) {
  New-Item -ItemType Directory -Path $AgentsSkillsDir -Force | Out-Null
}

if (Test-Path -LiteralPath $OldWorkflowMdc) {
  Remove-ExistingLinkTarget -Path $OldWorkflowMdc -AllowFile
  Write-Host "Removed $OldWorkflowMdc"
}

Remove-ExistingLinkTarget -Path $MdcPath -AllowFile
New-Symlink -Dest $MdcPath -Target $BuiltMdc
Write-Host "IDE  $MdcPath -> $BuiltMdc"

Remove-ExistingLinkTarget -Path $SkillDest
New-Symlink -Dest $SkillDest -Target $SkillSrc -Directory
Write-Host "SKILL $SkillDest -> $SkillSrc"

Write-Host ""
Write-Host "Done. Edit standards/*.md and skills/, then re-run install."
