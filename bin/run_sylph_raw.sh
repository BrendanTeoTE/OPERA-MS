#!/bin/bash
# Usage: run_sylph_sketch_and_query.sh <inter_fa_dir> <partial_sketch_dir> <partial_count> <threads> <skani_dir> <sylph_ref>

set -euo pipefail

INTER_FA_DIR="$1"
SYLPH_SKETCH_DIR="$2"
THREADS="$3"
SKANI_DIR="$4"
SYLPH_REF="$5"
SR1="$6"
SR2="$7"

SKETCH_OUT="$SKANI_DIR/sylph_sketch.out"
SKETCH_ERR="$SKANI_DIR/sylph_sketch.err"
QUERY_OUT="$SKANI_DIR/sylph_query.out"
QUERY_ERR="$SKANI_DIR/sylph_query.err"

echo "[INFO] Running sylph sketch..."

sylph sketch -1 $SR1 -2 $SR2 -d $SYLPH_SKETCH_DIR/sylph_sketch -t $THREADS \
    > "$SKETCH_OUT" 2> "$SKETCH_ERR"

if [[ $? -ne 0 ]]; then
    echo "[ERROR] Sylph sketch failed. See $SKETCH_ERR" >&2
    exit 1
fi

echo "[INFO] Running sylph query..."
sylph query "$SYLPH_REF" "$SYLPH_SKETCH_DIR/sylph_sketch"/*.sylsp \
    -t "$THREADS" \
    -o "$QUERY_OUT" 2> "$QUERY_ERR"


if [[ $? -ne 0 ]]; then
    echo "[ERROR] Sylph query failed. See $QUERY_ERR" >&2
    exit 1
fi

echo "[INFO] Sylph ran successfully."

