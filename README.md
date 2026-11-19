# mako — Catppuccin Mocha

Compact notification cards matching Quickshell's popups: 5px corners,
subtle 1px Surface 0 borders, Base backgrounds, and small sans-serif text.
Low-priority text is muted; critical text is red without a bright border.
Notifications appear at the top right below the 24px bar; critical alerts
stay visible until dismissed.

Repository: [cjvnjde/dotfiles.mako](https://github.com/cjvnjde/dotfiles.mako).
Managed as the `mako` submodule of [dotfiles](https://github.com/cjvnjde/dotfiles).

## Setup

Requires mako, `pw-play` (PipeWire), and a checkout inside the parent dotfiles
repository: `setup.sh` uses the parent's shared `setup/lib.sh`. The preview
commands also need `libnotify`. Enable `mako` in `.modules` or `.modules.local`,
then run:

```sh
bash ~/dotfiles/setup.sh mako
makoctl reload
```

The script links `config` and `sounds/` into
`${XDG_CONFIG_HOME:-$HOME/.config}/mako/`. Existing files or directories at those
paths are preserved as `.bak`, `.bak1`, etc.; unrelated mako files are left
alone. Re-running setup is safe. It does not install packages, start services,
or reload the daemon automatically.

The root setup script discovers this module automatically.
Do not enable it on macOS: mako is a Wayland notification daemon.

## Preview

```sh
notify-send 'Catppuccin Mocha' 'Your notifications now match your desktop.'
notify-send -u low 'Background task' 'A subtle, low-priority notification.'
notify-send -u critical 'Needs attention' 'Right-click to dismiss this alert.'
```

- Left click: invoke the notification's default action, if provided.
- Right click: dismiss one notification.
- Middle click: dismiss all notifications.
- Normal timeout: 6 seconds; low priority: 4 seconds. Sender timeouts are
  respected except for critical alerts.

## Notification sound

Every notification plays `sounds/notification.mp3` through `pw-play`, at
`--volume=0.5`, on the current default audio output. System output volume and
mute still apply. The sound was copied from
`~/Downloads/universfield-positive-notification-351299.mp3`; the original
download is unchanged. Do Not Disturb and overflow placeholders stay silent.

```sh
makoctl mode -a do-not-disturb  # hide notifications and silence their sounds
makoctl mode -r do-not-disturb  # resume notifications and sounds
```

Different sounds can be assigned with mako criteria such as `[urgency=critical]`,
`[app-name=Herdr]`, `[desktop-entry=com.mitchellh.ghostty]`, or a `[category=...]`
provided by the sender. Override `on-notify` in the matching section to play
another file from `sounds/`, or use `on-notify=none` to mute it. Keep sound
overrides before `[hidden]` and the final `[mode=do-not-disturb]` section so
those silence rules win; apply edits with `makoctl reload`.

### Herdr

With `[ui.toast] delivery = "terminal"`, Herdr sends desktop notifications
through Ghostty to mako. Set `[ui.sound] enabled = false` in
`~/.config/herdr/config.toml` to avoid a second native chime and let mako's Do
Not Disturb control the audio. Reload each running session with
`herdr --session <name> server reload-config`.

Herdr also supports separate native MP3 files via `ui.sound.done_path`
(finished) and `ui.sound.request_path` (needs attention), with `ui.sound.path`
as a shared default. This is an alternative to mako-owned sound: re-enabling
it requires muting the corresponding mako notifications to avoid duplicates,
and mako's Do Not Disturb cannot silence Herdr's native playback. See the
[Herdr sound documentation](https://herdr.dev/docs/configuration/#sound).

## Undo

Remove the managed links and restore the newest backups, if any:

```sh
DOTFILES_RESTORE_BACKUPS=1 bash ~/dotfiles/mako/setup.sh disable
makoctl reload
```

Without `DOTFILES_RESTORE_BACKUPS=1`, `disable` only removes the managed links.
