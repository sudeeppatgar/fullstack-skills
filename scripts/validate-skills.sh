#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
errors=0
count=0

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "ERROR: Missing skills/ directory"
  exit 1
fi

while IFS= read -r -d '' file; do
  count=$((count + 1))
  dir="$(basename "$(dirname "$file")")"

  if ! grep -q '^---[[:space:]]*$' "$file"; then
    echo "ERROR: $file is missing YAML frontmatter delimiters"
    errors=$((errors + 1))
    continue
  fi

  if ! grep -q '^name:[[:space:]]*' "$file"; then
    echo "ERROR: $file is missing name frontmatter"
    errors=$((errors + 1))
  fi

  if ! grep -q '^description:[[:space:]]*' "$file"; then
    echo "ERROR: $file is missing description frontmatter"
    errors=$((errors + 1))
  fi

  if ! grep -q '^# ' "$file"; then
    echo "ERROR: $file is missing a top-level Markdown heading"
    errors=$((errors + 1))
  fi

  name="$(sed -n 's/^name:[[:space:]]*//p' "$file" | head -n 1 | tr -d '"' | tr -d "'")"
  if [[ -n "$name" && "$name" != "$dir" ]]; then
    echo "WARNING: directory '$dir' differs from frontmatter name '$name' ($file)"
  fi
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if [[ "$count" -eq 0 ]]; then
  echo "ERROR: No skills/*/SKILL.md files found"
  exit 1
fi

if [[ "$errors" -gt 0 ]]; then
  echo "Validation failed: $errors error(s) across $count skill(s)."
  exit 1
fi

echo "Basic validation passed for $count skill(s)."
echo "Note: this script checks basic structure only, not technical correctness or licensing."
