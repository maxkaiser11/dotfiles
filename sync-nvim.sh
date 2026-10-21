#!/usr/bin/env bash
# Omarchy only: refresh the repo's nvim snapshot from your live ~/.config/nvim.
# Symlinks (like Omarchy's theme file) are resolved into real files.
#
#   ./sync-nvim.sh            copy, then show what changed
#   ./sync-nvim.sh --commit   copy, commit and push
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

src="$HOME/.config/nvim"
dest="nvim/.config/nvim"

if [[ -L $src ]] && [[ "$(readlink -f "$src")" == "$PWD/$dest" ]]; then
  echo "~/.config/nvim is already linked to this repo - nothing to sync."; exit 0
fi
[[ -d $src ]] || { echo "No ~/.config/nvim found."; exit 1; }

mkdir -p "$(dirname "$dest")"
rm -rf "$dest"
cp -rL "$src" "$dest"

git status --short -- nvim
if [[ ${1:-} == --commit ]]; then
  git add nvim
  if git diff --cached --quiet; then echo "No changes."; exit 0; fi
  git commit -m "Sync nvim config"
  git push
fi
