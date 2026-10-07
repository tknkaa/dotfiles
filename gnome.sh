#!/usr/bin/env bash
# GNOME desktop settings. Safe to re-run.
set -euo pipefail

# Caps Lock acts as Ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"

# Cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# Japanese keyboard layout only; Mozc is provided by fcitx5 (see fcitx5/)
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'jp')]"

# Ptyxis terminal: Nerd Font + Dracula palette (herdr's "dracula" theme assumes it).
# The profile uuid is generated on first launch, so look it up instead of hardcoding.
gsettings set org.gnome.Ptyxis use-system-font false
gsettings set org.gnome.Ptyxis font-name 'JetBrainsMono Nerd Font 14'
ptyxis_profile="$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")"
if [ -n "$ptyxis_profile" ]; then
  gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$ptyxis_profile/" palette 'dracula'
else
  echo "Ptyxis has no profile yet: launch it once, then re-run ./gnome.sh" >&2
fi
