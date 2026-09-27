#!/usr/bin/env bash
# GNOME desktop settings. Safe to re-run.
set -euo pipefail

# Caps Lock acts as Ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"

# Cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# Japanese keyboard layout + Mozc (switch with Super+Space)
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'jp'), ('ibus', 'mozc-jp')]"
