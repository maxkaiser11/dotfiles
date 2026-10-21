#!/usr/bin/env bash
# Symlink dotfiles into $HOME with GNU Stow.
#
#   ./install.sh            portable set (nvim, git, starship) - WSL / other Linux / macOS
#   ./install.sh --all      every package - Omarchy machines (nvim skipped there)
#   ./install.sh nvim git   just the packages you name
#
# Existing real files/folders in the way are renamed to *.bak.<timestamp>.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

PORTABLE=(nvim git starship)

is_omarchy() { [[ -d $HOME/.local/share/omarchy || -d /usr/share/omarchy ]]; }

if [[ ${1:-} == --all ]]; then
  pkgs=()
  for d in */; do
    d="${d%/}"
    # On Omarchy, nvim stays Omarchy-managed (follows theme switches);
    # the repo copy is only a snapshot - refresh it with ./sync-nvim.sh
    if [[ $d == nvim ]] && is_omarchy; then
      echo "skip nvim (Omarchy machine - your live config is kept)"; continue
    fi
    pkgs+=("$d")
  done
elif [[ $# -gt 0 ]]; then
  pkgs=("$@")
else
  pkgs=("${PORTABLE[@]}")
fi

if ! command -v stow >/dev/null; then
  if   command -v pacman  >/dev/null; then sudo pacman -S --needed --noconfirm stow
  elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y stow
  elif command -v brew    >/dev/null; then brew install stow
  else echo "Please install GNU Stow first."; exit 1; fi
fi

# Move aside anything in $HOME that would block the symlink
backup_conflicts() {
  local pkg=$1 rel t
  while IFS= read -r rel; do
    t="$HOME/$rel"
    if [[ -e $t && ! -L $t ]]; then
      mv "$t" "$t.bak.$(date +%s)"
      echo "  backed up existing ~/$rel"
    fi
  done < <(cd "$pkg" && {
    find . -mindepth 1 -maxdepth 1 ! -name .config
    [[ -d .config ]] && find ./.config -mindepth 1 -maxdepth 1
  } | sed 's|^\./||')
}

for pkg in "${pkgs[@]}"; do
  if [[ ! -d $pkg ]]; then echo "skip $pkg (not in repo)"; continue; fi
  backup_conflicts "$pkg"
  stow --restow --target="$HOME" "$pkg"
  echo "linked $pkg"
done
