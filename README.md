# Minecraft Server

A Dockerized vanilla Minecraft server with [playit.gg](https://playit.gg) tunnel for external access.

## Requirements

- [Docker](https://www.docker.com/) with Docker Compose

## Setup

1. Copy the example env file and fill in your secret key:

   ```bash
   cp .env.example .env
   ```

2. Open `.env` and set your `PLAY_IT_SECRET_KEY` (see below).

## Getting the Secret Key

1. Go to [playit.gg](https://playit.gg) and create an account.
2. Add a new agent/tunnel in your dashboard.
3. Copy the secret key provided and paste it into `.env`:

   ```
   PLAY_IT_SECRET_KEY=your_secret_key_here
   ```

## Running the Server

Use the start script — it pulls the latest config from the repo before starting.

**Windows (PowerShell):**
```powershell
.\scripts\start.ps1
```

**Linux/macOS:**
```bash
chmod +x scripts/start.sh  # only needed once
./scripts/start.sh
```

To stop and save the world:

**Windows (PowerShell):**
```powershell
.\scripts\shutdown.ps1
```

**Linux/macOS:**
```bash
chmod +x scripts/shutdown.sh  # only needed once
./scripts/shutdown.sh
```

This will:
1. Stop the server (`docker compose down`)
2. Commit any world changes in `.data/` to git
3. Push the latest world state to the remote

> **Note:** Always use `scripts/shutdown.sh` instead of running `docker compose down` directly — otherwise world progress won't be saved to git.

To view logs:

```bash
docker compose logs -f
```

## Maintenance

### Squashing history

Over time the repo grows large because each shutdown commits new binary world files. Run this periodically (e.g. once a month) to collapse old history into a single checkpoint, keeping the last 2 commits as individual rollback points (pass a number to change how many to keep):

**Windows (PowerShell):**
```powershell
.\scripts\squash.ps1       # keep last 2 commits
.\scripts\squash.ps1 5     # keep last 5 commits
```

**Linux/macOS:**
```bash
chmod +x scripts/squash.sh  # only needed once
./scripts/squash.sh         # keep last 2 commits
./scripts/squash.sh 5       # keep last 5 commits
```

**Warning:** this force-pushes to GitHub and permanently removes the ability to roll back to sessions before the squash checkpoint.

## Server Details

| Setting             | Value      |
|---------------------|------------|
| Version             | 26.1.2     |
| Type                | Vanilla    |
| Memory              | 4G         |
| Difficulty          | Hard       |
| View Distance       | 16 chunks  |
| Simulation Distance | 16 chunks  |

Server data is stored in the `.data/` directory.
