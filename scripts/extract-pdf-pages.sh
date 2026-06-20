#!/usr/bin/env sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 \"source/atow-pdf/A Time of War.pdf\"" >&2
  exit 2
fi

PDF_PATH=$1
OUT_DIR="source/atow-text"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "Error: pdftotext is required but was not found. Install Poppler and try again." >&2
  exit 1
fi

if [ ! -f "$PDF_PATH" ]; then
  echo "Error: PDF not found: $PDF_PATH" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

PAGES=$(pdfinfo "$PDF_PATH" 2>/dev/null | awk '/^Pages:/ { print $2 }')
if [ -z "${PAGES:-}" ]; then
  echo "Error: could not determine PDF page count. Is pdfinfo installed and is the file valid?" >&2
  exit 1
fi

i=1
while [ "$i" -le "$PAGES" ]; do
  page=$(printf "%04d" "$i")
  pdftotext -f "$i" -l "$i" -layout "$PDF_PATH" "$OUT_DIR/page-$page.txt"
  i=$((i + 1))
done

echo "Extracted $PAGES pages to $OUT_DIR"
