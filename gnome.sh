#!/usr/bin/env bash
set -euo pipefail

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"

gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'jp')]"

gsettings set org.gnome.Ptyxis use-system-font false
gsettings set org.gnome.Ptyxis font-name 'JetBrainsMono Nerd Font 13'
ptyxis_profile="$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")"
if [ -n "$ptyxis_profile" ]; then
  gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$ptyxis_profile/" palette 'Vs Code'
else
  echo "Ptyxis has no profile yet: launch it once, then re-run ./gnome.sh" >&2
fi

S=org.gnome.Ptyxis.Shortcuts
gsettings set $S new-window '<ctrl><shift><alt>n'
gsettings set $S toggle-fullscreen '<ctrl><shift>n'
gsettings set $S close-tab '<alt>x'
