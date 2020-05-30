# Roosta's scripts

This is where maintain my various shell scripts.

## Branches

## [master](https://github.com/roosta/scripts)

Most current up to date scripts.

## [deprecated](https://github.com/roosta/scripts/tree/deprecated)

I have a lot of scripts I never use anymore, but they're backed up in the
`deprecated` branch for posterity.

## Table of content
<!-- vim-markdown-toc GFM -->

* [add-font.sh](#add-fontsh)
* [chdisp-nvidia.sh](#chdisp-nvidiash)
* [chdisp-xrandr.sh](#chdisp-xrandrsh)
* [crypthelper.sh](#crypthelpersh)
* [ddns-start.sh](#ddns-startsh)
* [dialog-demo.sh](#dialog-demosh)
* [dropdown-terminal.sh](#dropdown-terminalsh)
* [emacs-file-opener.sh](#emacs-file-openersh)
* [fontalias.sh](#fontaliassh)
* [gfx-drv-swap.sh](#gfx-drv-swapsh)
* [gpu-temp.sh](#gpu-tempsh)
* [i3lock-color-locker.sh](#i3lock-color-lockersh)
* [iommu-groups.sh](#iommu-groupssh)
* [keyboard-layout.sh](#keyboard-layoutsh)
* [launch-polybar.sh](#launch-polybarsh)
* [ocr-clip.sh](#ocr-clipsh)
* [optirun (folder)](#optirun-folder)
* [paswitch.sh](#paswitchsh)
* [rainbow.sh](#rainbowsh)
* [record-area.sh](#record-areash)
* [record-window.sh](#record-windowsh)
* [tmux-attach.sh](#tmux-attachsh)
* [tmux-main.sh](#tmux-mainsh)
* [tmux-music.sh](#tmux-musicsh)
* [tmux-notify.sh](#tmux-notifysh)
* [tmux-ssh.sh](#tmux-sshsh)
* [tmux-update-window.sh](#tmux-update-windowsh)
* [tmux-work.sh](#tmux-worksh)
* [touchpad-toggle.sh](#touchpad-togglesh)
* [urxvtc-tmux.sh](#urxvtc-tmuxsh)
* [vpn.sh](#vpnsh)
* [work-fin.sh](#work-finsh)
* [xset-wacom-my-prefs.sh](#xset-wacom-my-prefssh)

<!-- vim-markdown-toc -->

## add-font.sh

Just add a new font to system by making fontdir and fontscale, and refreshing
font cache. Really basic stuff but I kept forgetting so here's the script
ensuring I'll never remember.


## chdisp-nvidia.sh

Script for changing output displays using nvidia cards. It also changes audio
sink.

Wrote this because I have a couch and a desk, and need to switch between them
by using a shortcut. I couldn't find a script that changes both displays and
audio sink so here we are.

It uses pre-defined layouts and takes a single argument. `desk`, `tv`, `mix`

Usage:
```shell
./chdisp-nvidia.sh desk
./chdisp-nvidia.sh tv
```

## chdisp-xrandr.sh

Same as above but using xrandr instead of nvidia-settings for setting layout

## crypthelper.sh

Script to simplify opening and mounting dm-crypt encrypted partitions. Really
not terribly useful I just kept forgetting how to do it, so I wrote this.

It is used like so:

```bash
./crypthelper.sh open /dev/sdh1 my-encrypted-device-name # gets mounted in ~/mnt/[name]
./crypthelper.sh close my-encrypted-device-name
```

## ddns-start.sh

Wrote this for [asuswrt-merlin](https://asuswrt.lostrealm.ca/), to setup
uniweb.no DDNS on my router a long time ago. This probably doesn't work
anymore, and just keeping it here in case I need to do something similar at
some point.

## dialog-demo.sh

Demo various dialog boxes using `whiptail`, `ncurses`, `GTK dialog`, `KDE
Dialog` I did not write this, only use it for reference. I stupidly never noted
where I got it from.

## dropdown-terminal.sh

Script I grabbed from
[here](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh)
and does some sorcery to create a dropdown terminal in bspwm.
[This](https://www.reddit.com/r/unixporn/comments/60qw8z/bspwm_bite_my_shiny_metal_ass/)
is the unixporn entry that linked me to the script It's my intention to modify
this to work on
[i3wm](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh).


## emacs-file-opener.sh

This uses emacsclient to open file `$1` at line `$2` What I usually do is to
add this to a project.clj using
[figwheel](https://github.com/bhauman/lein-figwheel):

```clojure
:figwheel {:open-file-command  "script/emacs_file_opener.sh"}
```

and I can click on the error dialog in the browser to have Emacs goto error.

## fontalias.sh

print which systemfont matches these aliases:

- serif
- sans-serif
- monospace
- Arial
- Helvetica
- Verdana
- Times New Roman
- Courier New

## gfx-drv-swap.sh

Swap driver packages installed on Archlinux between nvidia and
xf86-video-nouveau. Pulled this script from the archlinux wiki but was unable
to find it again when I went back looking.


## gpu-temp.sh

Outputs nvidia GPU temperature. Originally used with
[i3blocks](https://github.com/vivien/i3blocks).

## i3lock-color-locker.sh

Using [i3lock-color](https://github.com/chrjguill/i3lock-color), setup color
params and lock if i3lock-color is on system, else fall back to i3lock regular.
Blurs background and use [srcery colors](https://github.com/srcery-colors/srcery-vim).

## iommu-groups.sh

List all IOMMU groups for system. Used this when setting up PCI passthrough to
a virtual machine. More info
[here](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF).


## keyboard-layout.sh

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

original source: <http://unix.stackexchange.com/a/27688>

## launch-polybar.sh

Called on i3 startup to launch whatever polybar layout `hostname` requires.

```
exec_always --no-startup-id $HOME/scripts/launch-polybar.sh
```

I have multiple monitors, so I launch several bars depending on hostname, since
the number of screens vary, so does the configs.


## ocr-clip.sh

Dependencies: tesseract-ocr imagemagick gnome-screenshot xclip

Select some text on screen, and attempt to OCR it. Takes language as param,
i.e. `./ocr-clip.sh eng`. Will copy text to clipboard, and echo to terminal.

Author: Mathias Bjerke \<mathbje@gmail.com\>

## optirun (folder)

Friend of mine sent me this conf and run script. I believe it was for enabling
optirun when charging/docked.

Author: Christian Karlsen

## paswitch.sh

Switch Pulseaudio sinks, used this mainly for reference and found it on the
[pulseaudio
docs](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/),
used the base concepts here to make the chdisp\* scripts.

- paswitch 2011-02-02 by Ng Oon-Ee <ngoonee@gmail.com>
- original author unknown


## rainbow.sh

Script used to troubleshoot true color in terminal, will print a rainbow and
how it looks depends on what colors are supported by your terminal.

More on that [here](https://gist.github.com/XVilka/8346728).

## record-area.sh

Records a selection of the screen and output result as a gif.

This script requires:

- https://github.com/lolilolicon/xrectsel
- recordmydesktop
- mplayer
- imagemagick
- gifsicle

Author: Mathias Bjerke \<mathbje@gmail.com\>

## record-window.sh

Records entire screen and output result as a gif.

This script requires:

- https://github.com/lolilolicon/xrectsel
- recordmydesktop
- mplayer
- imagemagick
- gifsicle

Author:

Mathias Bjerke \<mathbje@gmail.com\>

Daniel Berg \<mail@roosta.sh\>

## tmux-attach.sh

Attach to an existing session, or create a new. Useful if you want tmux to
always be started with terminal emulator. Source either in shell rc file, or in
window manager on terminal emulator startup. Believe I got from
[here](https://wiki.archlinux.org/index.php/Tmux#Start_tmux_with_default_session_layout).


## tmux-main.sh

I run this manually to start a default tmux session layout. Check for existing
named session, attach, or create a new named session called main. Opted for this
solution rather than using a session manager, even though there are
[several](https://wiki.archlinux.org/index.php/Tmux#Start_tmux_with_default_session_layout)
[nice](https://github.com/junegunn/heytmux)
[ones](https://github.com/tmuxinator/tmuxinator).


## tmux-music.sh

Starts a new session called `mpd`, and launch mopidy.

## tmux-notify.sh

Use libnotify to notify when a tmux window receives a bell. Used with
`tmux-update-window.sh`.

Example:
```tmux
set-hook -g alert-silence 'run ". ~/utils/tmux-notify.sh; return 0"'
```

## tmux-ssh.sh

Starts a new session called `ssh` that launches [ngrok](https://ngrok.com/), I
use this sometimes if I need to access a computer over ssh that doesn't have a
static ip.

Takes TCP PORT as argument to ngrok.

## tmux-update-window.sh

Create an update window if `main` session exist. Set this window to monitor
silence. When I start an update, and then do something else I'd like to be
alerted on silence since that indicates that its either finished or requires
input.

## tmux-work.sh

Creates a work session that automatically starts a datomic transactor and the
datomic dev console.

## touchpad-toggle.sh

Toggles touchpad on or off.

Used in i3wm config like so:

```i3
bindsym XF86TouchpadToggle exec --no-startup-id ~/utils/touchpad-toggle.sh
```

## urxvtc-tmux.sh

Used in window manager to instead of starting a new session on term
shortcut it attach to an existing session and split the window.
If none exist create a new one. This is a modified version of this:
https://wiki.archlinux.org/index.php/Tmux#Start_tmux_in_urxvt

## vpn.sh

Check for tunnel and echo [polybar formatted](https://github.com/jaagr/polybar/wiki/Formatting) string

## work-fin.sh

WIP script to wrap up work session in one script.

## xset-wacom-my-prefs.sh

Set my Wacom prefs using `xsetwacom`, never found a gui app that did what I
needed to resorted to setting it with a script.

