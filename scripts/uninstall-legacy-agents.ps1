#Requires -Version 5.1
<#
.SYNOPSIS
  Remove personal AGENTS.md symlinks left by the old install (pointing at this repo's AGENTS.md,
  or at AGENTS.md in a folder named cursor-dotfiles or ai-config, so links survive a folder rename).
  Does not delete real project AGENTS.md files.
#>
$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$Dotfiles = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$AgentsInDotfiles = (Join-Path $Dotfiles "AGENTS.md")

$TechRoot = Join-Path $HOME "Tech"
$ProjectsRoot = [System.IO.Path]::GetFullPath((Join-Path $TechRoot "projects"))

function Test-UnderProjects {
  param([string]$Path)
  $full = [System.IO.Path]::GetFullPath($Path)
  if (-not (Test-Path -LiteralPath $ProjectsRoot)) { return $false }
  return $full.StartsWith($ProjectsRoot.TrimEnd('\') + '\', [System.StringComparison]::OrdinalIgnoreCase) -or
    $full.Equals($ProjectsRoot, [System.StringComparison]::OrdinalIgnoreCase)
}

function Remove-SymlinkFile {
  param([string]$Path)
  $proc = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "del", "`"$Path`"") -Wait -PassThru -NoNewWindow
  if ($proc.ExitCode -ne 0 -and (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue)) {
    throw "Could not remove $Path"
  }
}

function Test-LegacyTarget {
  param([string]$TargetFull)
  if ($TargetFull.Equals([System.IO.Path]::GetFullPath($AgentsInDotfiles), [System.StringComparison]::OrdinalIgnoreCase)) {
    return $true
  }
  $owner = Split-Path -Leaf (Split-Path -Parent $TargetFull)
  return (Split-Path -Leaf $TargetFull) -eq "AGENTS.md" -and $owner -in @("cursor-dotfiles", "ai-config")
}

$removed = 0
$skipped = 0

$repos = @(
  Get-ChildItem -Path $TechRoot -Directory -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName ".git") } |
    ForEach-Object { $_.FullName } |
    Sort-Object -Unique
)

foreach ($repo in $repos) {
  if ($repo -eq $Dotfiles) { continue }
  if (Test-UnderProjects $repo) {
    $skipped++
    continue
  }

  $dest = Join-Path $repo "AGENTS.md"
  $item = Get-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  if (-not $item -or $item.LinkType -ne "SymbolicLink") {
    continue
  }

  $target = $item.Target
  if ($target -is [System.Array]) {
    $target = [string]$target[0]
  } else {
    $target = [string]$target
  }
  $targetFull = [System.IO.Path]::GetFullPath($target)

  if (-not (Test-LegacyTarget $targetFull)) {
    Write-Host "SKIP $dest (symlink elsewhere)"
    continue
  }

  Remove-SymlinkFile -Path $dest
  Write-Host "OK   $dest"
  $removed++
}

Write-Host ""
Write-Host ("Removed: {0}  Skipped projects trees: {1}" -f $removed, $skipped)
