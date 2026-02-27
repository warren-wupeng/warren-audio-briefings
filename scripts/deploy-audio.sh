#!/bin/bash
# deploy-audio.sh - Deploy new audio briefing to GitHub Pages
# Usage: ./scripts/deploy-audio.sh <mp3-file> [title] [category]
#
# Examples:
#   ./scripts/deploy-audio.sh ~/morning-brief-20260228.mp3 "早间简报 2026-02-28" briefing
#   ./scripts/deploy-audio.sh ~/interview-prep.mp3 "面试准备" interview

set -e

MP3_FILE="$1"
TITLE="${2:-$(basename "$MP3_FILE" .mp3 | tr '-_' '  ')}"
CATEGORY="${3:-briefing}"
DATE=$(date +%Y-%m-%d)

if [ -z "$MP3_FILE" ] || [ ! -f "$MP3_FILE" ]; then
  echo "Usage: $0 <mp3-file> [title] [category]"
  echo "  category: briefing | interview | Other"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
FILENAME="$(basename "$MP3_FILE")"

echo "=== Deploying Audio ==="
echo "File:     $MP3_FILE"
echo "Title:    $TITLE"
echo "Category: $CATEGORY"
echo "Date:     $DATE"
echo ""

# Copy file
cp "$MP3_FILE" "$REPO_DIR/audio/$FILENAME"
echo "[OK] Copied to audio/$FILENAME"

# Update manifest
cd "$REPO_DIR"
python3 -c "
import json
with open('audio/manifest.json','r') as f:
    m = json.load(f)
entry = {
    'file': '$FILENAME',
    'title': '$TITLE',
    'category': '$CATEGORY',
    'date': '$DATE',
    'duration': '--'
}
# Remove existing entry with same file
m = [x for x in m if x['file'] != '$FILENAME']
# Add new entry at beginning
m.insert(0, entry)
with open('audio/manifest.json','w') as f:
    json.dump(m, f, ensure_ascii=False, indent=2)
print('[OK] Updated manifest.json')
"

# Git commit and push
git add "audio/$FILENAME" audio/manifest.json
git commit -m "Add audio: $TITLE ($DATE)"
git push

echo ""
echo "=== Deployed ==="
echo "URL: https://warren-wupeng.github.io/warren-audio-briefings/"
