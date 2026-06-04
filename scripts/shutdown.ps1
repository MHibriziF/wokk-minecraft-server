Write-Host "Shutting down Minecraft server..."
docker compose down

if ($LASTEXITCODE -ne 0) {
    Write-Host "docker compose down failed." -ForegroundColor Red
    exit 1
}

Write-Host "Saving world to git..."
git add .data

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "shutdown server $timestamp"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Nothing to commit, world unchanged." -ForegroundColor Yellow
    exit 0
}

Write-Host "Pushing latest world..."
git push

if ($LASTEXITCODE -ne 0) {
    Write-Host "Git push failed." -ForegroundColor Red
    exit 1
}

Write-Host "Done. Server shut down and world saved." -ForegroundColor Green
