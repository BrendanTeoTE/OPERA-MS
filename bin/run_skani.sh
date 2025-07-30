#!/bin/bash
# Usage: run_skani.sh <skani_dir> <skani_sketch_dir> <threads>

set -euo pipefail

SKANI_DIR="$1"
SKANI_SKETCH_DIR="$2"
THREADS="$3"

SAMPLE_FILE="$SKANI_DIR/sample_files.txt"
DB_FILE="$SKANI_DIR/db_files.txt"
SKANI_QUERY_ERR="$SKANI_DIR/skani_query.err"
SKANI_DIST_OUT="$SKANI_DIR/skani_dist.out.tsv"
SKANI_DIST_ERR="$SKANI_DIR/skani_dist.err"

# Run skani sketch
echo "[INFO] Running skani sketch..."
skani sketch -l "$SAMPLE_FILE" -o "$SKANI_SKETCH_DIR" -t "$THREADS" 2> "$SKANI_QUERY_ERR"

# Run skani dist
echo "[INFO] Running skani dist..."
skani dist -q "$SKANI_SKETCH_DIR"/* --rl "$DB_FILE" -t "$THREADS" > "$SKANI_DIST_OUT" 2> "$SKANI_DIST_ERR"
