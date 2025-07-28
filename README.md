# Deprecated scripts

This is the tracking branch for deprecated scripts that have gotten out of
rotation for various reasons. Descriptions from readme kept for posterity.

## Scripts
### add-font.sh

Just add a new font to system by making fontdir and fontscale, and refreshing
font cache. Really basic stuff but I kept forgetting so here's the script
ensuring I'll never remember.


### bandwidth

Output bandwidth usage to stdout. Did not write this, grabbed it from somewhere
I can't remember.

Authors:

- Copyright (C) 2012 Stefan Breunig <stefan+measure-net-speed@mathphys.fsk.uni-heidelberg.de>
- Copyright (C) 2014 kaueraal
- Copyright (C) 2015 Thiago Perrotta <perrotta dot thiago at poli dot ufrj dot br>

### battery.sh

This script is meant to use with i3blocks. It parses the output of the `acpi`
command (often provided by a package of the same name) to read the status of
the battery, and eventually its remaining time (to full charge or discharge).

The color will gradually change for a percentage below 85%, and the urgency
(exit code 33) is set if there is less that 5% remaining.  Output battery
status to stdout.

- Copyright 2014 Pierre Mavro <deimos@deimos.fr>
- Copyright 2014 Vivien Didelot <vivien@didelot.org>
- Licensed under the terms of the GNU GPL v3, or any later version.

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

Echo CPU temp formatted with colors based on threshold, don't remember what I
originally used this for but I'm guessing either i3blocks, or py3status.


Authors:

-   Copyright 2014 Pierre Mavro <deimos@deimos.fr>
-   Copyright 2014 Vivien Didelot <vivien@didelot.org>
-   Copyright 2014 Andreas Guldstrand <andreas.guldstrand@gmail.com>
-   Copyright 2014 Benjamin Chretien <chretien at lirmm dot fr>


### cpu-usage.sh

Output CPU usage to stdout with pre-pended color values for use in i3blocks

### ddns-start.sh

Wrote this for [asuswrt-merlin](https://asuswrt.lostrealm.ca/), to setup
uniweb.no DDNS on my router a long time ago. This probably doesn't work
anymore, and just keeping it here in case I need to do something similar at
some point.

### dialog-demo.sh

Demo various dialog boxes using `whiptail`, `ncurses`, `GTK dialog`, `KDE
Dialog` I did not write this, only use it for reference. I stupidly never noted
where I got it from.

### disk

Disk usage script used with [i3blocks](https://github.com/vivien/i3blocks), it
defaults to `home`, but takes settings from
[i3blocks](https://github.com/vivien/i3blocks) config.

Copyright (C) 2014 Julien Bonjean \<julien@bonjean.info\>


### dropboxd-status.py

Display status of Dropbox daemon. I meant to use this outside of py3status
hence its presence here, but haven't gotten around to modifying it yet.
Requires: dropbox-cli.

Used with: [py3status](https://github.com/ultrabug/py3status)

- Author: [Tjaart van der Walt](https://github.com/tjaartvdwalt)
- License: BSD


### dropdown-terminal.sh

Script I grabbed from
[here](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh)
and does some sorcery to create a dropdown terminal in bspwm.
[This](https://www.reddit.com/r/unixporn/comments/60qw8z/bspwm_bite_my_shiny_metal_ass/)
is the unixporn entry that linked me to the script It's my intention to modify
this to work on
[i3wm](https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh).


### emacs-file-opener.sh

This uses emacsclient to open file `$1` at line `$2` What I usually do is to
add this to a project.clj using
[figwheel](https://github.com/bhauman/lein-figwheel):

```clojure
:figwheel {:open-file-command  "script/emacs_file_opener.sh"}
```

and I can click on the error dialog in the browser to have Emacs goto error.


### fontalias.sh

print which systemfont matches these aliases:

- serif
- sans-serif
- monospace
- Arial
- Helvetica
- Verdana
- Times New Roman
- Courier New


### fstrim.sh

Used in a cronjob to run fstrim and log to `/var/log/trim.log`


### game-pick.sh

Randomly pick a game from a list, using
[toilet](https://github.com/cacalabs/toilet) for some added flair.


### gfx-drv-swap.sh

Swap driver packages installed on Archlinux between nvidia and
xf86-video-nouveau. Pulled this script from the archlinux wiki but was unable
to find it again when I went back looking.


### git-remove-submodule.sh

Remove a git submodule, this used to be a bit of a hassle, unsure if it still
is, since I basically stopped using submodules after much frustration. This
script alleviates that hassle somewhat.

Author: Adam Sharp, Aug 21, 2013


### gpu-temp.sh

Outputs nvidia GPU temperature. Originally used with
[i3blocks](https://github.com/vivien/i3blocks).

### i3exit.sh

Script used for an [i3wm display
mode](https://i3wm.org/docs/userguide.html#_display_mode) that sends
`lock | logout | suspend | hibernate | reboot |` shutdown commands

this script requires passwordless access to poweroff, reboot, pm-suspend and pm-hibernate

source: <https://github.com/Airblader/dotfiles-manjaro/blob/master/.i3/i3exit>


### i3lock-color-locker.sh

Using [i3lock-color](https://github.com/chrjguill/i3lock-color), setup color params and lock if i3lock-color is on system, else fall back to i3lock regular. Blurs background and use [srcery colors](https://github.com/roosta/vim-srcery).


### i3lock-extra.sh

Take a screenshot of desktop, blur and lock screen using i3lock. Got this from
[unixporn](https://www.reddit.com/r/unixporn/) at some point. Did a quick
google and found this [source
file](https://gitgud.io/fbt/misc/blob/64297e8f99aa3b1c4059c92519f7040892a8eb78/i3lock-extra)
but unsure if this is the original. Either way thanks to whoever wrote it


### iface

output local IP addresses. Used with [i3blocks](https://github.com/vivien/i3blocks).


### loadavg-spark.sh

Use [spark](https://github.com/holman/spark) with load average

### loadavg.sh

echo load average

### memory.sh

Output memory usage by using awk on `/proc/meminfo` Used with
[i3blocks](https://github.com/vivien/i3blocks).

- Copyright (C) 2014 Julien Bonjean \<julien@bonjean.info\>


### ocr-clip.sh

Dependencies: tesseract-ocr imagemagick gnome-screenshot xclip

Select some text on screen, and attempt to OCR it. Takes language as param,
i.e. `./ocr-clip.sh eng`. Will copy text to clipboard, and echo to terminal.

Author: Mathias Bjerke \<mathbje@gmail.com\>

### openvpn-detect.sh

Checks for an openvpn instance and echo result

Usage:

1.  The configuration name of OpenVPN should be familiar for you
    (home,work, etc)
2.  The device name in your configuration file should be fully named
    (tun0, tap1, not only tun or tap)
3.  When you launch one or multiple OpenVPN connexion, be sure the PID file is
    written in the correct folder (ex: `--writepid /run/openvpn/home.pid`)

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

Archlinux update status script, check for available updates using pacman and
[auracle](https://github.com/falconindy/auracle), echo result as number of
offical/AUR packages.

Used with [polybar](https://github.com/jaagr/polybar).


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

### tmux-dev-session.sh

I run this manually to start a default tmux session layout. Check for existing
named session, attach, or create a new named session called dev. Opted for this
solution rather than using a session manager, even though there are
[several](https://wiki.archlinux.org/index.php/Tmux#Start_tmux_with_default_session_layout)
[nice](https://github.com/junegunn/heytmux)
[ones](https://github.com/tmuxinator/tmuxinator).

One thing with this that I'm currently testing out is monitoring silence on the
'update' window. I'd like to get notified when an update requires input


### tmux-music.sh

Starts a new session called `mpd`, and launch mopidy.

### tmux-work.sh

Creates a work session that automatically starts a datomic transactor and the
datomic dev console.

### urxvtc-tmux.sh

much like 'tmux-attach.sh' but starts urxvt client and kick off Tmux.

### volume.sh

echo current volume

- Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>
- Copyright (C) 2014 Alexander Keller <github@nycroth.com>

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

### [vpn.sh](vpn.sh)

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Check for tunnel and echo [polybar formatted](https://github.com/jaagr/polybar/wiki/Formatting) string

### [launch-polybar.sh](./launch-polybar.sh)

> DEPECATED: Xorg is getting phased out for wayland, kept for backward
> compatibility temporarily

Called on i3 startup to launch whatever polybar layout `hostname` requires.

```
exec_always --no-startup-id $HOME/scripts/launch-polybar.sh
```

I have multiple monitors, so I launch several bars depending on hostname, since
the number of screens vary, so does the configs.



### [rainbow.sh](./rainbow.sh)

Script used to troubleshoot true color in terminal, will print a rainbow and
how it looks depends on what colors are supported by your terminal.

More on that [here](https://gist.github.com/XVilka/8346728).

### [zsh-update.sh](./zsh-update.sh)

Requires:

- [zplug](https://github.com/zplug/zplug)
- [Zsh](https://www.zsh.org/)

Makes updating zsh plugins via zplug accessible via a script, normally you'd
have to source an environment for `zplug update` to work, in other words have a
fully sourced config with zplug to be able to update. You still need that, but
here it is as a script callable from a subshell.

### [keyboard-layout.sh](./keyboard-layout.sh)

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

