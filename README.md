## Scripts

These are utility scripts I use on my systems that isn't a package, or is
simple enough to warrant a script file. These files are in flux, due to
changing requirements and environments.

Going forward most of these scripts target Wayland, Xorg scripts kept here for
backward compatibility so I can launch an i3 session for whatever reason. For a
full list of phased out scripts `checkout` the deprecated branch.

- Companion repo for for my [dotfiles](https://github.com/roosta/etc)

### Branches

| Branch | Description |
|--------|-------------|
| [**main**](https://github.com/roosta/scripts) | Most current up to date scripts I use on the daily. |
| [**deprecated**](https://github.com/roosta/scripts/tree/deprecated) | Deprecated scripts not in use |

### Script descriptions

Short descriptions for each script, not always up to data. Attribution where
possible.

#### [bookmarks_md.mjs](bookmarks_md.mjs)

Node script to grab bookmarks from chrome/firefox in a folder on the toolbar
called `capture`. Converts the bookmarks to markdown links.

#### [crypthelper.sh](crypthelper.sh)

Script to simplify opening and mounting dm-crypt encrypted partitions. Really
not terribly useful I just kept forgetting how to do it, so I wrote this.

It is used like so:

```bash
./crypthelper.sh open /dev/sdh1 my-encrypted-device-name ## gets mounted in ~/mnt/[name]
./crypthelper.sh close my-encrypted-device-name
```

#### [flush.sh](flush.sh)

WIP script to flush credentials and secrets.

#### [git-ls-large-files.sh](git-ls-large-files.sh)

See which files in a git repo history takes up the most space. Useful if
pruning assets or similar from a repo.

Source: https://stackoverflow.com/questions/13403069/how-to-find-out-which-files-take-up-the-most-space-in-git-repo

#### Power scripts

Scripts used in custom power menus, mostly using systemctl, but also uses
[zenity](https://gitlab.gnome.org/GNOME/zenity) as a confirm dialog, cause I
sometimes hit the wrong menu item.

- [hibernate.sh](hibernate.sh)
- [lock.sh](lock.sh)
- [locker.sh](locker.sh)
- [logout.sh](logout.sh)
- [reboot.sh](reboot.sh)
- [shutdown.sh](shutdown.sh)
- [suspend.sh](suspend.sh)

#### [iommu-groups.sh](iommu-groups.sh)

List all IOMMU groups for system. Used this when setting up PCI passthrough to
a virtual machine. More info [here](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF).

#### [keyboard-layout.sh](keyboard-layout.sh)

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

#### [launch-polybar.sh](launch-polybar.sh)

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Called on i3 startup to launch whatever polybar layout `hostname` requires.

```
exec_always --no-startup-id $HOME/scripts/launch-polybar.sh
```

I have multiple monitors, so I launch several bars depending on hostname, since
the number of screens vary, so does the configs.


#### [rainbow.sh](rainbow.sh)

Script used to troubleshoot true color in terminal, will print a rainbow and
how it looks depends on what colors are supported by your terminal.

More on that [here](https://gist.github.com/XVilka/8346728).

#### [tmux-attach.sh](tmux-attach.sh)

Attach to an existing session, or create a new. Useful if you want tmux to
always be started with terminal emulator. Source either in shell rc file, or in
window manager on terminal emulator startup. Believe I got from
[here](https://wiki.archlinux.org/index.php/Tmux##Start_tmux_with_default_session_layout).

#### [tmux-main.sh](tmux-main.sh)

I run this manually to start a default tmux session layout. Check for existing
named session, attach, or create a new named session called main. Opted for this
solution rather than using a session manager, even though there are
[several](https://wiki.archlinux.org/index.php/Tmux##Start_tmux_with_default_session_layout)
[nice](https://github.com/junegunn/heytmux)
[ones](https://github.com/tmuxinator/tmuxinator).


#### [tmux-notify.sh](tmux-notify.sh)

Use libnotify to notify when a tmux window receives a bell. Used with
`tmux-update-window.sh`.

Example:
```tmux
set-hook -g alert-silence 'run ". ~/utils/tmux-notify.sh; return 0"'
```

#### [tmux-ssh.sh](tmux-ssh.sh)

Starts a new session called `ssh` that launches [ngrok](https://ngrok.com/), I
use this sometimes if I need to access a computer over ssh that doesn't have a
static ip.

Takes TCP PORT as argument to ngrok.

#### [tmux-update-window.sh](tmux-update-window.sh)

Create an update window if `main` session exist. Set this window to monitor
silence. When I start an update, and then do something else I'd like to be
alerted on silence since that indicates that its either finished or requires
input.

#### [torrent-done.sh](torrent-done.sh)

Extract `rar` archives on torrent completion, used in [transmission](https://github.com/transmission/transmission)

#### [touchpad-toggle.sh](touchpad-toggle.sh)

- TODO: Fix for wayland

Toggles touchpad on or off.

Used in i3wm config like so:

```i3
bindsym XF86TouchpadToggle exec --no-startup-id ~/utils/touchpad-toggle.sh
```
#### [updates-arch-combined.sh](updates-arch-combined.sh)

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily.

Will output formatted text for Polybar, checking Arch Linux `pacman` updates, as
well as AUR updates.

#### [waybar-dev.sh](waybar-dev.sh)

Requirements:
- [entr](https://eradman.com/entrproject/)
- [Waybar](https://github.com/Alexays/Waybar)

Uses `entr` to watch for changes in my Waybar config files, and will restart
Waybar on save. I use this when I develop themes and customization, you can
pass `-d` to open a GTK debugger window as well, to get CSS selectors used for
styling Waybar.

#### [wl-prop.sh](wl-prop.sh)

- source: https://gist.github.com/crispyricepc/f313386043395ff06570e02af2d9a8e0#file-wlprop-sh

Requirements:

- `swaymsg`
- `jq`
- `slurp`
- `awk`

Works similarly to `xprop` in xorg. Running this will start a window selection,
and output the relevant node from the Sway tree.

#### Rofi Action Menu

A Rofi menu with common actions I used to script or save as cmd one liners.

When transitioning to Wayland, several desktop related tools stopped working,
like `flameshot`, or `gpick`. So I needed some alternatives for Wayland. I set it
up as a Rofi menu with generic scripts, so that it can be swapped out on
need.

- [colorpicker.sh](colorpicker.sh)
  - [hyprpicker](https://github.com/hyprwm/hyprpicker)
  - [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
- [monitor.sh](monitor.sh)
  - [alacritty](https://github.com/alacritty/alacritty)
  - [btop](https://github.com/aristocratos/btop)
- [screenshot.sh](screenshot.sh)
  - [grim](https://git.sr.ht/~emersion/grim)
  - [slurp](https://github.com/emersion/slurp)
  - [swappy](https://github.com/jtheoof/swappy)

