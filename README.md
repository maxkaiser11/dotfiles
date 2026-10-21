# dotfiles

My configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder is a "package" that mirrors `$HOME`, e.g.
`git/.gitconfig` → `~/.gitconfig`.

| Package | What | Where it's used |
|---|---|---|
| nvim | LazyVim + Kanagawa (snapshot) | WSL / Windows / other Linux |
| git | `.gitconfig` | everywhere |
| starship | prompt | everywhere |
| bash | `.bashrc` (sources Omarchy defaults) | Omarchy only |
| hypr, waybar, ghostty, alacritty | desktop | Omarchy only |

## nvim on Omarchy

On Omarchy, `~/.config/nvim` is **not** linked to this repo — it stays
Omarchy-managed so the theme follows Omarchy's theme switcher. The `nvim/`
folder here is a snapshot with the theme symlink resolved to a real file,
so it works anywhere. After changing your nvim config on Omarchy:

```bash
~/dotfiles/sync-nvim.sh --commit
```

## New machine

**Omarchy**
```bash
git clone https://github.com/maxkaiser11/dotfiles ~/dotfiles
~/dotfiles/install.sh --all      # nvim is skipped automatically
```

**WSL / other Linux / macOS**
```bash
git clone https://github.com/maxkaiser11/dotfiles ~/dotfiles
~/dotfiles/install.sh            # nvim, git, starship
```
On Ubuntu, `apt`'s Neovim is too old for LazyVim — install the latest release
from github.com/neovim/neovim/releases, plus `ripgrep fd-find build-essential`.

**Windows (PowerShell)**
```powershell
git clone https://github.com/maxkaiser11/dotfiles $HOME\dotfiles
cd $HOME\dotfiles; .\install.ps1
```

## Day to day

Linked files in `$HOME` are symlinks into this repo, so just edit as normal, then:
```bash
cd ~/dotfiles && git add -A && git commit -m "..." && git push
```
On other machines: `git pull`. To add a new config, move it into
`~/dotfiles/<name>/<same path>` and run `./install.sh <name>`.
