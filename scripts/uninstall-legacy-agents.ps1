#Requires -Version 5.1
<#
.SYNOPSIS
  Remove personal AGENTS.md symlinks left by the old install (pointing at this repo's AGENTS.md).
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
  if ($proc.ExitCode -ne 0 -and (Test-Path -LiteralPath $Path)) {
    throw "Could not remove $Path"
  }
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
  if (-not (Test-Path -LiteralPath $dest)) { continue }

  $item = Get-Item -LiteralPath $dest -Force
  if ($item.LinkType -ne "SymbolicLink") {
    continue
  }

  $target = $item.Target
  if ($target -is [System.Array]) {
    $target = [string]$target[0]
  } else {
    $target = [string]$target
  }
  $targetFull = [System.IO.Path]::GetFullPath($target)
  $expected = [System.IO.Path]::GetFullPath($AgentsInDotfiles)

  if (-not $targetFull.Equals($expected, [System.StringComparison]::OrdinalIgnoreCase)) {
    Write-Host "SKIP $dest (symlink elsewhere)"
    continue
  }

  Remove-SymlinkFile -Path $dest
  Write-Host "OK   $dest"
  $removed++
}

Write-Host ""
Write-Host ("Removed: {0}  Skipped projects trees: {1}" -f $removed, $skipped)
