# mako — Catppuccin Mocha

Compact notification cards matching Quickshell's popups: 5px corners,
subtle 1px Surface 0 borders, Base backgrounds, and small sans-serif text.
Low-priority text is muted; critical text is red without a bright border.
Notifications appear at the top right below the 24px bar; critical alerts
stay visible until dismissed.

Repository: [cjvnjde/dotfiles.mako](https://github.com/cjvnjde/dotfiles.mako).
Managed as the `mako` submodule of [dotfiles](https://github.com/cjvnjde/dotfiles).

## Setup

Requires mako and a checkout inside the parent dotfiles repository: `setup.sh`
uses the parent's shared `setup/lib.sh`. The preview commands also need `libnotify`.
Enable `mako` in `.modules` or `.modules.local`, then run:

```sh
bash ~/dotfiles/setup.sh mako
makoctl reload
```

The script links `config` to `${XDG_CONFIG_HOME:-$HOME/.config}/mako/config`.
Existing config files are preserved as `.bak`, `.bak1`, etc.; other files in
the mako directory are left alone. Re-running setup is safe. It does not
install packages, start services, or reload the daemon automatically.

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

## Undo

Remove the managed link and restore the newest backup, if any:

```sh
DOTFILES_RESTORE_BACKUPS=1 bash ~/dotfiles/mako/setup.sh disable
makoctl reload
```

Without `DOTFILES_RESTORE_BACKUPS=1`, `disable` only removes the managed link.
