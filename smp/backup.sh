#!/bin/bash
# === Nomonom SMP Auto-Backup (fast + safe, on Hetzner volume) ===
# Backs up World-3, world, and plugins to your 200GB volume.
# Uses pigz if available (parallel gzip). Low I/O priority so players don’t feel it.

set -euo pipefail

# --- CONFIG ---
SESSION="smp"                                # tmux session for the SMP server (NOT proxy)
WORLDS=("World-3" "world")                   # add/remove worlds here
BACKUP_DIR="/mnt/HC_Volume_103709862/backups"
SLEEP_AFTER_FLUSH=20
RETENTION_DAYS=2
DISK_SKIP_PCT=90
# -------------

# Prevent overlapping runs (lockfile, timed to avoid permanent deadlocks)
LOCK="/tmp/backup.lock"
exec 9>"$LOCK"
if ! flock -w 3 9; then
  echo "[Backup] Skipped: another run is in progress."
  exit 0
fi

mkdir -p "$BACKUP_DIR"

# Skip if backup volume is getting full
USED=$(df --output=pcent "$BACKUP_DIR" | tail -1 | tr -dc '0-9')
if [ "$USED" -ge "$DISK_SKIP_PCT" ]; then
  echo "[Backup] Skipped: $USED% used at $BACKUP_DIR (>= ${DISK_SKIP_PCT}%)."
  exit 0
fi

# Choose compressor: pigz if present, else gzip
if command -v pigz >/dev/null 2>&1; then
  TAR_COMP_ARGS=(-I 'pigz -1' -cf)  # fast, multi-core
  EXT="tar.gz"
else
  TAR_COMP_ARGS=(-czf)
  EXT="tar.gz"
fi

# Silence harmless “file changed as we read it”
TAR_WARN_ARGS=(--warning=no-file-changed)

TIMESTAMP=$(date +'%Y-%m-%d_%H-%M')

echo "[Backup] Starting backup at $TIMESTAMP"

# === SAFE WORLD FLUSH (only if SMP session exists) ===
echo "[Backup] Attempting world flush..."
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux send-keys -t "$SESSION" "/save-all flush" Enter
  sleep "$SLEEP_AFTER_FLUSH"
  echo "[Backup] ✅ World flush complete."
else
  echo "[Backup] ⚠ SMP not running in tmux — skipping flush."
fi

# --- WORLD BACKUPS ---
for WORLD in "${WORLDS[@]}"; do
  SRC="$WORLD"
  DEST="$BACKUP_DIR/${WORLD}_${TIMESTAMP}.${EXT}"
  echo "[Backup] Compressing $SRC -> $DEST"
  ionice -c2 -n7 nice -n10 tar "${TAR_WARN_ARGS[@]}" "${TAR_COMP_ARGS[@]}" "$DEST" "$SRC"
  echo "[Backup] ✅ $WORLD done."
done

# --- PLUGIN BACKUP ---
PLUGINS_ARCHIVE="$BACKUP_DIR/plugins_${TIMESTAMP}.${EXT}"
echo "[Backup] Compressing plugins -> $PLUGINS_ARCHIVE"
ionice -c2 -n7 nice -n10 tar "${TAR_WARN_ARGS[@]}" "${TAR_COMP_ARGS[@]}" "$PLUGINS_ARCHIVE" plugins
echo "[Backup] ✅ plugins done."

# Cleanup old backups
echo "[Backup] Cleaning backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -type f -mtime +"$RETENTION_DAYS" -name "*.tar.gz" -delete

echo "[Backup] ✅ All backups complete ($TIMESTAMP). Stored in $BACKUP_DIR"
