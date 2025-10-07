#!/bin/bash
# Usage: run_skani.sh <skani_dir> <skani_sketch_dir> <threads> <inter_fa_dir>
set -euo pipefail

SKANI_DIR="$1"
SKANI_SKETCH_DIR="$2"
THREADS="$3"
INTER_FA_DIR="$4"

DB_FILE="$SKANI_DIR/db_files.txt"
SKANI_SKETCH_ERR="$SKANI_DIR/skani_sketch.err"
SKANI_DIST_OUT="$SKANI_DIR/skani_dist.out.tsv"
SKANI_DIST_ERR="$SKANI_DIR/skani_dist.err"

# lists
SKANI_LIST="$SKANI_DIR/skani_fasta.list"
SKANI_QUERY_LIST="$SKANI_DIR/skani_query.list"

# Build FASTA list for sketch
find "$INTER_FA_DIR" -maxdepth 1 -type f \( -name '*.fa' -o -name '*.fna' -o -name '*.fasta' \) > "$SKANI_LIST"

echo "[INFO] Running skani sketch..."
skani sketch -l "$SKANI_LIST" -o "$SKANI_SKETCH_DIR" -t "$THREADS" 2> "$SKANI_SKETCH_ERR"

# Build sketch list for dist
find "$SKANI_SKETCH_DIR" -maxdepth 1 -type f -name '*.sketch' > "$SKANI_QUERY_LIST"

echo "[INFO] Running skani dist..."
skani dist --ql "$SKANI_QUERY_LIST" --rl "$DB_FILE" -s 90 -t "$THREADS" > "$SKANI_DIST_OUT" 2> "$SKANI_DIST_ERR"

