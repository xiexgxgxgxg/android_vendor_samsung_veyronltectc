#!/bin/bash
# Pull the blobs listed in proprietary-files.txt from a system dump.
# Usage: ./extract-files.sh /path/to/system_root
set -e
SRC="${1:?usage: $0 <system_root>}"
DST="$(cd "$(dirname "$0")" && pwd)/proprietary"
LIST="$(cd "$(dirname "$0")" && pwd)/proprietary-files.txt"
mkdir -p "$DST"
while IFS= read -r line; do
    case "$line" in ''|'#'*) continue ;; esac
    path="${line%%|*}"
    [ -e "$SRC/$path" ] || { echo "missing: $path"; continue; }
    mkdir -p "$DST/$(dirname "$path")"
    cp -a "$SRC/$path" "$DST/$path"
done < "$LIST"
echo "done -> $DST"
