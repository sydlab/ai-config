#Requires -Version 5.1
<#
.SYNOPSIS
  Install post-commit push hook and a scheduled task to fast-forward pull this repo.
#>
$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$HookSrc = Join-Path $ScriptDir "git-hooks\post-commit"
$HookDest = Join-Path $RepoRoot ".git\hooks\post-commit"
$PullScript = Join-Path $ScriptDir "sync-pull.ps1"
$TaskName = "ai-config-sync-pull"

if (-not (Test-Path -LiteralPath $HookSrc)) {
  throw "Missing hook template: $HookSrc"
}

$hooksDir = Split-Path $HookDest -Parent
if (-not (Test-Path $hooksDir)) {
  New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
}

$hookBody = Get-Content -LiteralPath $HookSrc -Raw -Encoding UTF8
$hookBody = $hookBody -replace "`r`n", "`n" -replace "`r", "`n"
if (-not $hookBody.EndsWith("`n")) { $hookBody += "`n" }
[System.IO.File]::WriteAllText($HookDest, $hookBody, [System.Text.UTF8Encoding]::new($false))
Write-Host "Hook $HookDest"

$action = New-ScheduledTaskAction `
  -Execute "powershell.exe" `
  -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PullScript`""

$triggerLogon = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$triggerHourly = New-ScheduledTaskTrigger -Once -At (Get-Date).Date.AddMinutes(5) `
  -RepetitionInterval (New-TimeSpan -Hours 1) `
  -RepetitionDuration (New-TimeSpan -Days 3650)

$settings = New-ScheduledTaskSettingsSet `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -StartWhenAvailable `
  -MultipleInstances IgnoreNew

Register-ScheduledTask `
  -TaskName $TaskName `
  -Action $action `
  -Trigger @($triggerLogon, $triggerHourly) `
  -Settings $settings `
  -Force | Out-Null

Write-Host "Task  $TaskName (logon + hourly)"
Write-Host ""
Write-Host "Sync: commit pushes via post-commit hook; pull runs on login and every hour when the tree is clean."
