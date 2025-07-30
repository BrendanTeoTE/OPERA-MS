#!/bin/bash
# Usage: run_sylph_sketch_and_query.sh <inter_fa_dir> <partial_sketch_dir> <partial_count> <threads> <skani_dir> <sylph_ref>

set -euo pipefail

INTER_FA_DIR="$1"
PARTIAL_SKETCH_DIR="$2"
PARTIAL_COUNT="$3"
THREADS="$4"
SKANI_DIR="$5"
SYLPH_REF="$6"

SKETCH_OUT="$SKANI_DIR/sketch_${PARTIAL_COUNT}.out"
SKETCH_ERR="$SKANI_DIR/sketch_${PARTIAL_COUNT}.err"
QUERY_OUT="$SKANI_DIR/sylph_query_${PARTIAL_COUNT}.out"
QUERY_ERR="$SKANI_DIR/sylph_query_${PARTIAL_COUNT}.err"

echo "[INFO] Running sylph sketch..."
sylph sketch -d "$PARTIAL_SKETCH_DIR/partial_sketch_$PARTIAL_COUNT" \
    -r "$INTER_FA_DIR"/* \
    -t "$THREADS" \
    > "$SKETCH_OUT" 2> "$SKETCH_ERR"

if [[ $? -ne 0 ]]; then
    echo "[ERROR] Sylph sketch failed. See $SKETCH_ERR" >&2
    exit 1
fi

echo "[INFO] Running sylph query..."
sylph query "$SYLPH_REF" "$PARTIAL_SKETCH_DIR/partial_sketch_$PARTIAL_COUNT"/*.sylsp \
    -t "$THREADS" \
    -o "$QUERY_OUT" 2> "$QUERY_ERR"

if [[ $? -ne 0 ]]; then
    echo "[ERROR] Sylph query failed. See $QUERY_ERR" >&2
    exit 1
fi

echo "[INFO] Sylph sketch + query finished for partial count $PARTIAL_COUNT"
