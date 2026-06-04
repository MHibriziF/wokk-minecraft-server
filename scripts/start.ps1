Write-Host "Pulling latest changes..."
git pull

if ($LASTEXITCODE -ne 0) {
    Write-Host "Git pull failed. Aborting server start." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Minecraft server..."
docker compose up -d
