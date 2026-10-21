# Windows: install Neovim + dependencies and link the nvim config from this repo.
# Run in PowerShell from the repo folder:   .\install.ps1
# (No admin needed - it uses a directory junction.)

$ErrorActionPreference = "Stop"
$Source = Join-Path $PSScriptRoot "nvim\.config\nvim"
$Target = Join-Path $env:LOCALAPPDATA "nvim"

# Dependencies (already-installed ones are skipped by winget)
$deps = @(
  "Neovim.Neovim",
  "Git.Git",
  "BurntSushi.ripgrep.MSVC",
  "sharkdp.fd",
  "zig.zig",                 # C compiler for Treesitter parsers
  "JesseDuffield.lazygit"
)
foreach ($id in $deps) {
  Write-Host "winget: $id"
  winget install --id $id -e --accept-source-agreements --accept-package-agreements | Out-Null
}

# Link %LOCALAPPDATA%\nvim -> repo
if (Test-Path $Target) {
  $item = Get-Item $Target -Force
  if ($item.LinkType -eq "Junction" -and (@($item.Target) -contains $Source)) {
    Write-Host "nvim config already linked"
  } else {
    $bak = "$Target.bak-$(Get-Date -Format yyyyMMddHHmmss)"
    Move-Item $Target $bak
    Write-Host "Backed up existing config to $bak"
  }
}
if (-not (Test-Path $Target)) {
  New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
  Write-Host "Linked $Target -> $Source"
}

Write-Host ""
Write-Host "Done. Restart your terminal so PATH updates, install a Nerd Font"
Write-Host "(e.g. JetBrainsMono Nerd Font), set it in Windows Terminal, then run: nvim"
