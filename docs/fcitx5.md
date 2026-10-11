# Japanese input (fcitx5 + Mozc)

IBus was replaced by fcitx5 (`fcitx5-mozc`). On GNOME/Wayland, fcitx5's own
candidate window (Classic UI) appears slightly off the cursor, because Wayland
apps cannot report absolute screen positions and GNOME lacks `input-method-v2`.
The fix is to let GNOME Shell draw the candidates via **kimpanel**:

- fcitx5 side (in the repo): `fcitx5/.config/fcitx5/config` sets
  `DisabledAddons=classicui`; the kimpanel addon ships with the `fcitx5` package.
- GNOME side (**manual**, not scripted): install the
  [Input Method Panel](https://extensions.gnome.org/extension/261/kimpanel/) extension (`kimpanel@kde.org`)
  from extensions.gnome.org and enable it. If it is missing, candidates will not
  show at all — delete `~/.config/fcitx5/config` and run `fcitx5 -r` to revert.
- `~/.config/environment.d/fcitx5.conf` sets `XMODIFIERS` / `QT_IM_MODULE`, so log
  out and back in after the first install. IBus must not be in the GNOME input
  sources (`gnome.sh` sets only `xkb jp`).

Note: `fcitx5-configtool` rewrites the symlinked `profile` with extra comments;
discard that diff rather than committing it.
