#!/bin/bash
set -e

echo "Pulling latest changes..."
git pull

echo "Starting Minecraft server..."
docker compose up -d
