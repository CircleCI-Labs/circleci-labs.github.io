#!/usr/bin/env bash
# Build the site into docs/, the folder that GitHub Pages serves from the main branch.
# Usage: ./build.sh
set -euo pipefail

HUGO_VERSION=0.168.0

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v hugo >/dev/null 2>&1; then
  echo "hugo is not installed. Install the extended edition, version ${HUGO_VERSION}." >&2
  exit 1
fi

version="$(hugo version)"
case "${version}" in
  "hugo v${HUGO_VERSION}"*"+extended"*) ;;
  *)
    echo "Expected hugo extended ${HUGO_VERSION}, found: ${version}" >&2
    exit 1
    ;;
esac

hugo --minify --cleanDestinationDir
test -f docs/.nojekyll
echo "Built docs/. Commit it."
