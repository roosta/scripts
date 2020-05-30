# Roosta's scripts

This repo is basically a dumping ground for various scripts/utils/whatever that
are kinda one-shot stuff that doesn't fit in a project. Probably not very
useful to anyone but me but I'll include some information on each one I can
still remember what does

Some of these scripts I just grabbed off of various sources, wikis, the likes,
and have stuck around long after their expiration date. Hard to delete stuff.

## Scripts
<!-- vim-markdown-toc GFM -->

* [add-font.sh](#add-fontsh)
* [arch-updates.sh](#arch-updatessh)
* [bandwidth](#bandwidth)
* [battery.sh](#batterysh)
* [byzanz-gui.sh](#byzanz-guish)
* [chdisp-nvidia.sh](#chdisp-nvidiash)
* [chdisp-xrandr.sh](#chdisp-xrandrsh)
* [cpu-temp.sh](#cpu-tempsh)
* [cpu-usage.sh](#cpu-usagesh)
* [crypthelper.sh](#crypthelpersh)
* [ddns-start.sh](#ddns-startsh)
* [dialog-demo.sh](#dialog-demosh)
* [disk](#disk)
* [dropboxd-status.py](#dropboxd-statuspy)
* [dropdown-terminal.sh](#dropdown-terminalsh)
* [emacs-file-opener.sh](#emacs-file-openersh)
* [fontalias.sh](#fontaliassh)
* [fstrim.sh](#fstrimsh)
* [game-pick.sh](#game-picksh)
* [gfx-drv-swap.sh](#gfx-drv-swapsh)
* [git-remove-submodule.sh](#git-remove-submodulesh)
* [gpu-temp.sh](#gpu-tempsh)
* [i3exit.sh](#i3exitsh)
* [i3lock-color-locker.sh](#i3lock-color-lockersh)
* [i3lock-extra.sh](#i3lock-extrash)
* [iface](#iface)
* [iommu-groups.sh](#iommu-groupssh)
* [keyboard-layout.sh](#keyboard-layoutsh)
* [launch-polybar.sh](#launch-polybarsh)
* [loadavg-spark.sh](#loadavg-sparksh)
* [loadavg.sh](#loadavgsh)
* [memory.sh](#memorysh)
* [ocr-clip.sh](#ocr-clipsh)
* [openvpn-detect.sh](#openvpn-detectsh)
* [optirun (folder)](#optirun-folder)
* [paswitch.sh](#paswitchsh)
* [pip-uninstall-recursive.sh](#pip-uninstall-recursivesh)
* [pip-upgrade-all.py](#pip-upgrade-allpy)
* [pkg.sh](#pkgsh)
* [public-ip.sh](#public-ipsh)
* [record-gif.sh](#record-gifsh)
* [run-spotify.sh](#run-spotifysh)
* [tmux-attach.sh](#tmux-attachsh)
* [tmux-dev-session.sh](#tmux-dev-sessionsh)
* [tmux-update-window.sh](#tmux-update-windowsh)
* [touchpad-toggle.sh](#touchpad-togglesh)
* [urxvtc-tmux.sh](#urxvtc-tmuxsh)
* [volume.sh](#volumesh)
* [vpn.sh](#vpnsh)
* [wifi.sh](#wifish)
* [wol.sh](#wolsh)
* [xset-wacom-my-prefs.sh](#xset-wacom-my-prefssh)

<!-- vim-markdown-toc -->

### add-font.sh

Just add a new font to system by making fontdir and fontscale, and refreshing
font cache. Really basic stuff but I kept forgetting so here's the script
ensuring I'll never remember.


### arch-updates.sh

Displays the number of package updates pending for an Arch Linux installation.

This is grabbed straight from
[py3status](https://github.com/ultrabug/py3status), I think I made some
modifications on the print output but other than that it's the same.


### bandwidth

Output bandwidth usage to stdout. Did not write this, grabbed it from somewhere
I can't remember

Authors:

- Copyright (C) 2012 Stefan Breunig <stefan+measure-net-speed@mathphys.fsk.uni-heidelberg.de>
- Copyright (C) 2014 kaueraal
- Copyright (C) 2015 Thiago Perrotta <perrotta dot thiago at poli dot ufrj dot br>


### battery.sh

Output battery status to stdout


### byzanz-gui.sh

GUI script for byzanz, a script used for recording GIF screencasts. Have since
moved to other solutions but its here for posterity.

Author: (c) Rob W 2012, modified by MHC
(<http://askubuntu.com/users/81372/mhc>)


### chdisp-nvidia.sh

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

### chdisp-xrandr.sh

Same as above but using xrandr instead of nvidia-settings for setting layout

### cpu-temp.sh


Authors:

-   Copyright 2014 Pierre Mavro <deimos@deimos.fr>
-   Copyright 2014 Vivien Didelot <vivien@didelot.org>
-   Copyright 2014 Andreas Guldstrand <andreas.guldstrand@gmail.com>
-   Copyright 2014 Benjamin Chretien <chretien at lirmm dot fr>


### cpu-usage.sh

Output CPU usage to stdout with pre-pended color values for use in i3blocks


### crypthelper.sh

Script to simplify opening and mounting dm-crypt encrypted partitions. Really not terribly useful I just kept forgetting how to do it, so I wrote this.

It is used like so:

```shell
./crypthelper.sh open /dev/sdh1 my-encrypted-device-name # gets mounted in ~/mnt/[name]
./crypthelper.sh close my-encrypted-device-name
```


### ddns-start.sh

Wrote this for [asuswrt-merlin](https://asuswrt.lostrealm.ca/), to setup uniweb.no DDNS on my router a long time ago. This probably doesn't work anymore, and just keeping it here in case I need to do something similar at some point


### dialog-demo.sh

Demo various dialog boxes using `whiptail`, `ncurses`, `GTK dialog`, `KDE Dialog` I did not write this, only use it for reference. I stupidly never noted where I got it from.


### disk

Disk usage script used with [i3blocks](https://github.com/vivien/i3blocks), it defaults to `home`, but takes settings from [i3blocks](https://github.com/vivien/i3blocks) config Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>


### dropboxd-status.py

Display status of Dropbox daemon. I meant to use this outside of py3status hence its presence here, but haven't gotten around to modifying it yet. Requires: dropbox-cli Used with: [py3status](https://github.com/ultrabug/py3status)

-   Author: Tjaart van der Walt (github:tjaartvdwalt)
-   License: BSD


### dropdown-terminal.sh

Script I grabbed from [here](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh) and does some sorcery to create a dropdown terminal in bspwm. [This](https://www.reddit.com/r/unixporn/comments/60qw8z/bspwm_bite_my_shiny_metal_ass/) is the unixporn entry that linked me to the script It's my intention to modify this to work on [i3wm](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh)


### emacs-file-opener.sh

This uses emacsclient to open file `$1` at line `$2` What I usually do is to add this to a project.clj using [figwheel](https://github.com/bhauman/lein-figwheel):

```clojure
:figwheel {:open-file-command    "script/emacs_file_opener.sh"}
```

and I can click on the error dialog in the browser to have Emacs goto error.


### fontalias.sh

print which systemfont matches these aliases:

-   serif
-   sans-serif
-   monospace
-   Arial
-   Helvetica
-   Verdana
-   Times New Roman
-   Courier New


### fstrim.sh

Used in a cronjob to run fstrim and log to `/var/log/trim.log`


### game-pick.sh

Randomly pick a game from a list, using [toilet](https://github.com/cacalabs/toilet) for some added flair. I don't like making decisions.


### gfx-drv-swap.sh

Swap driver packages installed on Archlinux between nvidia and xf86-video-nouveau. Pulled this script from the archlinux wiki but was unable to find it again when I went back looking.


### git-remove-submodule.sh

Remove a git submodule, this used to be a bit of a hassle, unsure if it still is, since I basically stopped using submodules after much frustration. This script alleviates that hassle somewhat.

Author: Adam Sharp, Aug 21, 2013


### gpu-temp.sh

Outputs nvidia GPU temperature. Originally used with [i3blocks](https://github.com/vivien/i3blocks).


### i3exit.sh

Script used for an [i3wm display mode](https://i3wm.org/docs/userguide.html#_display_mode) that sends lock|logout|suspend|hibernate|reboot|shutdown commands

this script requires passwordless access to poweroff, reboot, pm-suspend and pm-hibernate

source: <https://github.com/Airblader/dotfiles-manjaro/blob/master/.i3/i3exit>


### i3lock-color-locker.sh

Using [i3lock-color](https://github.com/chrjguill/i3lock-color), setup color params and lock if i3lock-color is on system, else fall back to i3lock regular. Blurs background and use [srcery colors](https://github.com/roosta/vim-srcery).


### i3lock-extra.sh

Take a screenshot of desktop, blur and lock screen using i3lock. Got this from [unixporn](https://www.reddit.com/r/unixporn/) at some point. Did a quick google and found this [source file](https://gitgud.io/fbt/misc/blob/64297e8f99aa3b1c4059c92519f7040892a8eb78/i3lock-extra) but unsure if this is the original. Either way thanks to whoever wrote it


### iface

output local IP addresses. Used with [i3blocks](https://github.com/vivien/i3blocks).


### iommu-groups.sh

List all IOMMU groups for system. Used this when setting up PCI passthrough to a virtual machine. More info [here](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF).


### keyboard-layout.sh

Echo keyboard layout code/caps lock and formatting for [polybar](https://github.com/jaagr/polybar)

I like my indicator to have a red background on Norwegian layout and caps-lock since it always trips me up when this is activated. Only works for Norwegian and US layouts. Could easily be modified though.

original source: <http://unix.stackexchange.com/a/27688>

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


### launch-polybar.sh

Called on i3 startup to launch whatever polybar layout `hostname` requires.


### loadavg-spark.sh

Use [spark](https://github.com/holman/spark) with load average


### loadavg.sh

echo load average


### memory.sh

Output memory usage by using awk on `/proc/meminfo` Used with [i3blocks](https://github.com/vivien/i3blocks).

-   Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>


### ocr-clip.sh

Author: Mathias Bjerke <mathbje@gmail.com> Dependencies: tesseract-ocr imagemagick gnome-screenshot xclip

Select some text on screen, and attempt to OCR it. Takes language as param, i.e. \`./ocr-clip.sh eng\`. Will copy text to clipboard, and echo to terminal.


### openvpn-detect.sh

Checks for an openvpn instance and echo result

Usage:

1.  The configuration name of OpenVPN should be familiar for you
    (home,work&#x2026;)
2.  The device name in your configuration file should be fully named
    (tun0,tap1&#x2026;not only tun or tap)
3.  When you launch one or multiple OpenVPN connexion, be sure the PID file is
    written in the correct folder (ex: &#x2013;writepid /run/openvpn/home.pid)

Used with [i3blocks](https://github.com/vivien/i3blocks). Made by Pierre Mavro/Deimosfr <deimos@deimos.fr>

### optirun (folder)

Friend of mine sent me this conf and run script. I believe it was for enabling
optirun when charging/docked.
Author: Christian Karlsen

### paswitch.sh

Switch Pulseaudio sinks, used this mainly for reference and found it on the
[pulseaudio
docs](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/),
used the base concepts here to make the chdisp\* scripts.

-   paswitch 2011-02-02 by Ng Oon-Ee <ngoonee@gmail.com>
-   original author unknown


### pip-uninstall-recursive.sh

Remove a package with pip and recursively remove unneeded dependencies

### pip-upgrade-all.py

Upgrade all pip packages

### pkg.sh

Archlinux update status script, check for available updates using pacman and [cower](https://github.com/falconindy/cower), echo result as nr of offical/nr of AUR Used with [polybar](https://github.com/jaagr/polybar).


### public-ip.sh

echo public ip

### record-gif.sh

Records a selection of the screen and output result as a gif

This script requires:

- https://github.com/lolilolicon/xrectsel
- recordmydesktop
- mplayer
- imagemagick
- gifsicle

Author: Mathias Bjerke <mathbje@gmail.com>


### run-spotify.sh

Start spotify if no instance exist. Used this in either i3 or i3bar to start
spotify by clicking a music icon or somsuch.

### tmux-attach.sh

Attach to an existing session, or create a new. Useful if you want tmux to
always be started with terminal emulator. Source either in shell rc file, or in
window manager on terminal emulator startup. Believe I got from
[here](https://wiki.archlinux.org/index.php/Tmux#Start_tmux_with_default_session_layout).


### tmux-dev-session.sh

I run this manually to start a default tmux session layout. Check for existing
named session, attach, or create a new named session called dev. Opted for this
solution rather than using a session manager, even though there are
[several](https://wiki.archlinux.org/index.php/Tmux#Start_tmux_with_default_session_layout)
[nice](https://github.com/junegunn/heytmux)
[ones](https://github.com/tmuxinator/tmuxinator).

One thing with this that I'm currently testing out is monitoring silence on the
'update' window. I'd like to get notified when an update requires input


### tmux-update-window.sh

Create an update window if 'dev' session exist. Set this window to monitor
silence. Reasoning behind this is that if I start an update, and then do
something else I'd like to be alerted on silence since that indicates that its
either finished or requires input.

### touchpad-toggle.sh

Toggles touchpad on or off.

Used in i3wm config like so:

```example
bindsym XF86TouchpadToggle exec --no-startup-id ~/utils/touchpad-toggle.sh
```

### urxvtc-tmux.sh

much like 'tmux-attach.sh' but starts urxvt client and kick off Tmux.

### volume.sh

echo current volume

- Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>
- Copyright (C) 2014 Alexander Keller <github@nycroth.com>

### vpn.sh

Check for tunnel and echo [polybar formatted](https://github.com/jaagr/polybar/wiki/Formatting) string

### wifi.sh

Echo wifi signal quality, used with [i3blocks](https://github.com/vivien/i3blocks).

### wol.sh

wake-on-lan script, used for reference Author: unknown

Nabbed from conky source code. Was experimenting with removing a window from
i3wm's control, where conky has a window-mode option of 'override', which is
exactly what I needed. Never got around to actually using this, just dumped
here and forgotten.


### xset-wacom-my-prefs.sh

Set my Wacom prefs using `xsetwacom`, never found a gui app that did what I needed to resorted to setting it with a script
