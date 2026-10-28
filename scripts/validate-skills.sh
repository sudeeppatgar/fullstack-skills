#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${1:-$ROOT/skills}"

if [[ ! -d "$SKILLS_DIR" ]]; then
  printf 'ERROR: Skills directory does not exist: %s\n' "$SKILLS_DIR" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1 || ! python3 -c 'import yaml' >/dev/null 2>&1; then
  printf 'ERROR: Python 3 and PyYAML are required to parse YAML frontmatter.\n' >&2
  exit 1
fi

errors=0
count=0
directory_count=0

while IFS= read -r -d '' skill_dir; do
  directory_count=$((directory_count + 1))
  file="$skill_dir/SKILL.md"
  if [[ ! -f "$file" || -L "$file" ]]; then
    printf 'ERROR: Required regular file is missing: %s\n' "$file" >&2
    errors=$((errors + 1))
    continue
  fi

  count=$((count + 1))
  if python3 - "$file" <<'PY'
import pathlib
import re
import sys

import yaml

class DuplicateKeyError(Exception):
    pass


class UniqueKeyLoader(yaml.SafeLoader):
    def construct_mapping(self, node, deep=False):
        self.flatten_mapping(node)
        mapping = {}
        for key_node, value_node in node.value:
            key = self.construct_object(key_node, deep=deep)
            if key in mapping:
                raise DuplicateKeyError(str(key))
            mapping[key] = self.construct_object(value_node, deep=deep)
        return mapping


path = pathlib.Path(sys.argv[1])
expected_name = path.parent.name
content = path.read_text(encoding="utf-8")

if not content.startswith("---\n") and not content.startswith("---\r\n"):
    sys.exit(f"ERROR: {path}: YAML frontmatter must start at the beginning of the file with ---")

lines = content.splitlines(keepends=True)
closing_index = next(
    (index for index in range(1, len(lines)) if re.fullmatch(r"---\s*\r?\n?", lines[index])),
    None,
)
if closing_index is None:
    sys.exit(f"ERROR: {path}: YAML frontmatter is missing its closing --- delimiter")

try:
    metadata = yaml.load("".join(lines[1:closing_index]), Loader=UniqueKeyLoader)
except DuplicateKeyError as error:
    sys.exit(f"ERROR: {path}: duplicate YAML key '{error}' in frontmatter")
except yaml.YAMLError as error:
    detail = str(error).splitlines()[0]
    sys.exit(f"ERROR: {path}: malformed YAML frontmatter: {detail}")

if not isinstance(metadata, dict):
    sys.exit(f"ERROR: {path}: YAML frontmatter must be a mapping")

for field in ("name", "description"):
    if field not in metadata:
        sys.exit(f"ERROR: {path}: missing required {field} field in YAML frontmatter")
    value = metadata[field]
    if not isinstance(value, str) or not value.strip():
        sys.exit(f"ERROR: {path}: {field} must be a non-empty string")

name = metadata["name"]
if len(name) > 64 or not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
    sys.exit(
        f"ERROR: {path}: name must be 1-64 lowercase letters, digits, or single hyphen-separated segments, "
        "with no leading, trailing, or consecutive hyphens"
    )
if name != expected_name:
    sys.exit(f"ERROR: {path}: name '{name}' must match parent directory '{expected_name}' exactly")

if len(metadata["description"]) > 1024:
    sys.exit(f"ERROR: {path}: description must be at most 1024 characters")

# This is intentionally a basic structural check, not a Markdown parser: a
# post-frontmatter line starting with an ATX-style H1 marker is sufficient.
if not any(re.match(r"^#\s+\S", line) for line in lines[closing_index + 1 :]):
    sys.exit(f"ERROR: {path}: missing a top-level Markdown heading after frontmatter (expected a line starting with '# ')")
PY
  then
    :
  else
    errors=$((errors + 1))
  fi
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ "$directory_count" -eq 0 ]]; then
  printf 'ERROR: No skill directories found under %s\n' "$SKILLS_DIR" >&2
  exit 1
fi

if [[ "$errors" -gt 0 ]]; then
  printf 'Validation failed: %s error(s) across %s skill(s).\n' "$errors" "$count" >&2
  exit 1
fi

printf 'Metadata validation passed for %s skill(s).\n' "$count"
printf 'Note: this checks selected Agent Skills metadata constraints, not the full specification or technical correctness/licensing.\n'
