$keep = if ($args.Count -gt 0) { [int]$args[0] } else { 2 }
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "This will squash all history older than the last $keep commits."
Write-Host "The last $keep commits will be kept as individual commits."
Write-Host ""
$confirm = Read-Host "Are you sure? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit 0
}

Write-Host "Creating squash base from HEAD~$keep..."
$tree = git rev-parse "HEAD~${keep}^{tree}"
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to get tree." -ForegroundColor Red; exit 1 }

$parent = git commit-tree $tree -m "chore: squash history checkpoint $timestamp"
if ($LASTEXITCODE -ne 0) { Write-Host "Failed to create base commit." -ForegroundColor Red; exit 1 }

Write-Host "Replaying last $keep commits on top..."
$commits = git log --format="%H" --reverse -n $keep
foreach ($hash in $commits) {
    $commitTree = git rev-parse "${hash}^{tree}"
    $msg = git log -1 --format="%B" $hash
    $parent = git commit-tree $commitTree -p $parent -m $msg
    if ($LASTEXITCODE -ne 0) { Write-Host "Failed to replay $hash." -ForegroundColor Red; exit 1 }
}

git reset --hard $parent
if ($LASTEXITCODE -ne 0) { Write-Host "Reset failed." -ForegroundColor Red; exit 1 }

Write-Host "Force pushing to GitHub..."
git push --force origin main
if ($LASTEXITCODE -ne 0) { Write-Host "Force push failed." -ForegroundColor Red; exit 1 }

Write-Host "Cleaning up local repo..."
git gc --prune=now

Write-Host "Done. History squashed, last $keep commits preserved." -ForegroundColor Green
