#!/bin/bash
set -e

KEEP=${1:-2}
timestamp=$(date "+%Y-%m-%d %H:%M")

echo "This will squash all history older than the last $KEEP commits."
echo "The last $KEEP commits will be kept as individual commits."
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo "Creating squash base from HEAD~$KEEP..."
TREE=$(git rev-parse "HEAD~${KEEP}^{tree}")
PARENT=$(git commit-tree "$TREE" -m "chore: squash history checkpoint $timestamp")

echo "Replaying last $KEEP commits on top..."
for hash in $(git log --format="%H" --reverse -$KEEP); do
    TREE=$(git rev-parse "${hash}^{tree}")
    MSG=$(git log -1 --format="%B" "$hash")
    NEW=$(git commit-tree "$TREE" -p "$PARENT" -m "$MSG")
    PARENT=$NEW
done

git reset --hard "$PARENT"

echo "Force pushing to GitHub..."
git push --force origin main

echo "Cleaning up local repo..."
git gc --prune=now

echo "Done. History squashed, last $KEEP commits preserved."
