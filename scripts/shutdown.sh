#!/bin/bash
set -e

echo "Shutting down Minecraft server..."
docker compose down

echo "Saving world to git..."
git add .data

timestamp=$(date "+%Y-%m-%d %H:%M")
if git commit -m "shutdown server $timestamp"; then
    echo "Pushing latest world..."
    git push
    echo "Done. Server shut down and world saved."
else
    echo "Nothing to commit, world unchanged."
fi
