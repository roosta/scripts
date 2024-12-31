## Scripts

These are utility scripts I use on my systems that isn't a package, or is
simple enough to warrant a script file. These files are in flux, due to
changing requirements and environments.

- Companion repo for for my [dotfiles](https://github.com/roosta/etc)

### Branches

| Branch | Description |
|--------|-------------|
| [**main**](https://github.com/roosta/scripts) | Most current up to date scripts I use on the daily. |
| [**deprecated**](https://github.com/roosta/scripts/tree/deprecated) | Deprecated scripts not in use |

### Script descriptions

Short descriptions for each script, not always up to data. Attribution where
possible.

#### bookmarks_md.mjs

Node script to grab bookmarks from chrome/firefox in a folder on the toolbar
called `capture`. Converts the bookmarks to markdown links.

#### crypthelper.sh

Script to simplify opening and mounting dm-crypt encrypted partitions. Really
not terribly useful I just kept forgetting how to do it, so I wrote this.

It is used like so:

```bash
./crypthelper.sh open /dev/sdh1 my-encrypted-device-name ## gets mounted in ~/mnt/[name]
./crypthelper.sh close my-encrypted-device-name
```

#### flush.sh

WIP script to flush credentials and secrets.

### git_ls_large_files.sh

See which files in a git repo history takes up the most space. Useful if
pruning assets or similar from a repo.

### Power scripts

Scripts used in custom power menus, mostly using systemctl, but also uses
[zenity](https://gitlab.gnome.org/GNOME/zenity) as a confirm dialog, cause I
sometimes hit the wrong menu item.

- hibernate.sh
- lock.sh
- locker.sh
- logout.sh
- reboot.sh
- shutdown.sh
- suspend.sh

#### [iommu-groups.sh](iommu-groups.sh)

List all IOMMU groups for system. Used this when setting up PCI passthrough to
a virtual machine. More info [here](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF).

#### keyboard-layout.sh

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Echo keyboard layout code/caps lock and formatting for [polybar](https://github.com/jaagr/polybar)

I like my indicator to have a red background on Norwegian layout and caps-lock
since it always trips me up when this is activated. Only works for Norwegian
and US layouts. Could easily be modified though.

How to use: In polybar setup a module using IPC:

```conf
[module/keyboard-layout]
type = custom/ipc
format-foreground = ${colors.brightwhite}
format = <output>
hook-0 = ~/scripts/keyboard-layout.sh
initial = 1
```

Then in i3 setup something like this:

```conf
bindsym --release Caps_Lock exec polybar-msg hook keyboard-layout 1
```

This triggers an ipc message when releasing caps lock, which I have setup via xorg to toggle between layouts.

Remember to enable ipc for your bar:

```conf
[bar/primary]
enable-ipc = true
```

Original source: <http://unix.stackexchange.com/a/27688>

#### launch-polybar.sh

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Called on i3 startup to launch whatever polybar layout `hostname` requires.

```
exec_always --no-startup-id $HOME/scripts/launch-polybar.sh
```

I have multiple monitors, so I launch several bars depending on hostname, since
the number of screens vary, so does the configs.


#### rainbow.sh

Script used to troubleshoot true color in terminal, will print a rainbow and
how it looks depends on what colors are supported by your terminal.

More on that [here](https://gist.github.com/XVilka/8346728).

#### tmux-attach.sh

Attach to an existing session, or create a new. Useful if you want tmux to
always be started with terminal emulator. Source either in shell rc file, or in
window manager on terminal emulator startup. Believe I got from
[here](https://wiki.archlinux.org/index.php/Tmux##Start_tmux_with_default_session_layout).

#### tmux-main.sh

I run this manually to start a default tmux session layout. Check for existing
named session, attach, or create a new named session called main. Opted for this
solution rather than using a session manager, even though there are
[several](https://wiki.archlinux.org/index.php/Tmux##Start_tmux_with_default_session_layout)
[nice](https://github.com/junegunn/heytmux)
[ones](https://github.com/tmuxinator/tmuxinator).


#### tmux-notify.sh

Use libnotify to notify when a tmux window receives a bell. Used with
`tmux-update-window.sh`.

Example:
```tmux
set-hook -g alert-silence 'run ". ~/utils/tmux-notify.sh; return 0"'
```

#### tmux-ssh.sh

Starts a new session called `ssh` that launches [ngrok](https://ngrok.com/), I
use this sometimes if I need to access a computer over ssh that doesn't have a
static ip.

Takes TCP PORT as argument to ngrok.

#### tmux-update-window.sh

Create an update window if `main` session exist. Set this window to monitor
silence. When I start an update, and then do something else I'd like to be
alerted on silence since that indicates that its either finished or requires
input.

#### torrent-done.sh

Extract `rar` archives on torrent completion, used in [transmission](https://github.com/transmission/transmission)

#### touchpad-toggle.sh

- TODO: Fix for wayland

Toggles touchpad on or off.

Used in i3wm config like so:

```i3
bindsym XF86TouchpadToggle exec --no-startup-id ~/utils/touchpad-toggle.sh
```

#### vpn.sh

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Check for tunnel and echo [polybar formatted](https://github.com/jaagr/polybar/wiki/Formatting) string

