#!/usr/bin/env bash
# Copy one chapter and the exercise folders it references into the workspace.
#
#   stage.sh 2.4        -> book/ch-2-4.qmd, book/exercises/<name>/ for each
#                          {{< exercise <name> >}} in the chapter
#
# Chapter numbers are positional: part N is the Nth folder matching
# NNNN-*/ in the repo root, chapter M its Mth *.qmd in sort order, which is
# the order _quarto.yml lists them in. Prints the staged paths.
set -euo pipefail

[[ $# -eq 1 && "$1" =~ ^[0-9]+\.[0-9]+$ ]] || { echo "usage: stage.sh <part>.<chapter>, e.g. 2.4" >&2; exit 2; }
REPO="$(cd "$(dirname "$0")/../../../.." && pwd)"
WORKSPACE="${EXERCISE_TEST_WORKSPACE:-$HOME/.cache/creative-coding-2-exercise-tests}"
[[ -d "$WORKSPACE/book" ]] || { echo "run setup.sh first" >&2; exit 1; }

part="${1%%.*}"; chapter="${1##*.}"
mapfile -t parts < <(cd "$REPO" && ls -d [0-9][0-9][0-9][0-9]-*/ | sort)
part_dir="${parts[$((part-1))]:-}"
[[ -n "$part_dir" ]] || { echo "no part $part" >&2; exit 1; }
mapfile -t chapters < <(cd "$REPO/$part_dir" && ls *.qmd | sort)
chapter_file="${chapters[$((chapter-1))]:-}"
[[ -n "$chapter_file" ]] || { echo "no chapter $1 in $part_dir" >&2; exit 1; }

src="$REPO/$part_dir$chapter_file"
dst="$WORKSPACE/book/ch-$part-$chapter.qmd"
cp "$src" "$dst"
echo "$dst  <- $part_dir$chapter_file"

for name in $(grep -oE '\{\{< exercise [A-Za-z0-9_-]+' "$src" | awk '{print $3}' | sort -u); do
  [[ -d "$REPO/exercises/$name" ]] || { echo "chapter references exercises/$name, which does not exist" >&2; exit 1; }
  rm -rf "$WORKSPACE/book/exercises/$name"
  mkdir -p "$WORKSPACE/book/exercises"
  cp -r "$REPO/exercises/$name" "$WORKSPACE/book/exercises/$name"
  echo "$WORKSPACE/book/exercises/$name/"
done
