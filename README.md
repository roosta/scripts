Scripts
=========

These are utility scripts I use on my systems that isn't a package, or is
simple enough to warrant a script file. These files are in flux, due to
changing requirements and environments.

- Companion repo for for my [dotfiles](https://github.com/roosta/dotfiles)

## Branches


| Branch | Description |
|--------|-------------|
| [**main**](https://github.com/roosta/scripts) | Most current up to date scripts I use on the daily. |
| [**deprecated**](https://github.com/roosta/scripts/tree/deprecated) | Deprecated scripts not in use |


## Script descriptions

Short descriptions for each script, attribution & licensing where applicable.

### [action-menu.sh](./action-menu.sh)

Creates a menu using [rofi-menu.sh](./rofi-menu.sh) 

Requirements: 
- https://github.com/lbonn/rofi
- [rofi-menu.sh](./rofi-menu.sh)
- [screenshot.sh](./screenshot.sh)
- [colorpicker.sh](./colorpicker.sh)
- [system-monitor.sh](./system-monitor.sh)

See requirements for each respective script used in the menu

Usage:

Called as a mode in rofi like this

```rasi
configuration {
  modes: "actions:~/scripts/action-menu.sh";
}
```

Config for this menu looks like this:
```yml
items:
  - script: ~/scripts/colorpicker.sh
    description: Pick a color
    icon: applications-graphics
    args: ["--format", "hex"]
# ...
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [add-vim-plugin.sh](./add-vim-plugin.sh)

Will create a plugin file for lazy.nvim at ~/.config/nvim/lua/plugins from a
repo identifier: repo/name This was created to speed up migration from vimrc
to init.lua

Requirements:
- https://neovim.io/
- https://github.com/cacalabs/toilet
- https://github.com/xero/figlet-fonts
- https://github.com/folke/lazy.nvim

Also asumes lazy.nvim is being used with a structured file layout
https://lazy.folke.io/usage/structuring

Usage
```sh
./add-vim-plugin.sh "roosta/fzf-folds.vim"
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [ags-dev.sh](./ags-dev.sh)

Starts an ags dev session, passing optional debug flat to also open inspector 

Requirements:
- https://github.com/eradman/entr
- https://github.com/aylur/ags

Usage: `./ags-dev.sh [OPTIONS]`

    OPTIONS:
      -d, --debug      open debug inspector

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [audio-menu.sh](./audio-menu.sh)

Creates a menu using [rofi-menu.sh](./rofi-menu.sh) 

Requirements:
- https://github.com/lbonn/rofi
- [rofi-menu.sh](./rofi-menu.sh)
- [switch-audio.sh](./switch-audio.sh)

Usage:
Called as a mode in rofi like this

```rasi
configuration {
  modes: "audio:~/scripts/audio-menu.sh";
}
```

Config for this menu looks like this:
```yml
items:
  - script: ~/scripts/switch-audio.sh
    description: Switch to Speakers
    icon: audio-speakers
    args: ["speakers"]
# ...
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [bakc.sh](./bakc.sh)

Quickly backup and timestamp a file mirroring its location in a target backup
directory

Usage: `bakc [OPTION] SOURCE`

    OPTIONS:
       -w         Save source file in working directory with .bak extension
       -R         Remove file after backup
       -h         Display this message

Examples

```sh
./bakc.sh ~/src/bakc/bakc.sh
# backed up /home/[user]/src/bakc/bakc.sh to /home/[user]/backup/home/[user]/src/bakc/bakc.sh~2017-02-12@21:20:12
```

Includes the option of placing it in working dir and only appending a .bak file extension

```sh
./bakc.sh -w file.txt
# Created test.txt.bak here (pwd)
```

Also included is the option to remove source file after backup:

```sh
./bakc.sh -wR file.txt
# Created file.txt.bak here (/home/[user]/[path]) removed 'file.txt'
```

It takes a relative path, and/or multiple files and follow symlinks:

```sh
~/bakc.sh ~/.zprofile ~/.zshenv
# backed up /home/[user]/.zshenv to /home/[user]/backup/home/[user]/.zshenv\~2017-02-12@22:01:40
# backed up /home/[user]/.zprofile to /home/[user]/backup/home/[user]/.zprofile\~2017-02-12@22:01:40
```

```sh
~/bakc.sh -w ~/.zshenv ~/.zprofile
# created /home/[user]/.zshenv.bak here (/home/[user]/src/bakc)
# Created /home/[user]/.zprofile.bak here (/home/[user]/src/bakc)
```

License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
### [colorpicker.sh](./colorpicker.sh)

Starts a colorpicker and saves result to clipboard

Requirements:

- https://github.com/bugaevc/wl-clipboard
- https://github.com/hyprwm/hyprpicker

Usage

```sh
./colorpicker.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [crypthelper.sh](./crypthelper.sh)

Script to simplify opening and mounting dm-crypt encrypted partitions. Really
not terribly useful I just kept forgetting how to do it, so I wrote this.

Requirements:
- https://gitlab.com/cryptsetup/cryptsetup/

Usage: `./cryptsetup.sh [CMD]`

    commands:
      open:             open device by passing these args [DEVICE] [NAME]
      close:            close device by passing [NAME]
    
    Example:
      crypthelper open /dev/sdh1 my-encrypted-device-name # gets mountet in ~/mnt/[name]
      crypthelper close my-encrypted-device-name

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [display-menu.sh](./display-menu.sh)

Creates a menu using [rofi-menu.sh](./rofi-menu.sh) 

Requirements:
- https://github.com/lbonn/rofi
- [rofi-menu.sh](./rofi-menu.sh)
- [switch-display.sh](./switch-display.sh)

Usage:
Called as a mode in rofi like this

```rasi
configuration {
  modes: "display:~/scripts/display-menu.sh";
}
```

Config for this menu looks like this:
```yml
items:
  - script: ~/scripts/switch-display.sh
    description: Switch to Desk Displays
    icon: input-keyboard
    args: ["desk"]
# ...
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [dotfiles.sh](./dotfiles.sh)

Scaffold various shell utils  needed for storing dotfiles like described here
https://wiki.archlinux.org/title/Dotfiles.

> [!WARNING]
> Work in progress

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [figlet-list.sh](./figlet-list.sh)

Script to display all toilet/figlet fonts with sample text in `$PAGER`

Requirements:
- https://github.com/cacalabs/toilet
- https://github.com/xero/figlet-fonts

Usage
```sh
./figlet-list.sh
```

Script will try `/usr/share/figlet` and `$HOME/lib/figlet-fonts`. I got extra
fonts installed in the latter.

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [flush.sh](./flush.sh)

Flush credentials and secrets.

> [!WARNING]
> Work in progress

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [fzf-edit.sh](./fzf-edit.sh)

Quicky find and edit files using fzf and fd

Requirements:
- https://github.com/sharkdp/fd
- https://github.com/junegunn/fzf

Usage:
```bash
./fzf-edit.sh              # Fuzzy find files in current directory and open in $EDITOR
./fzf-edit <file> ..       # Open specified file(s) in $EDITOR
./fzf-edit <multiple args> # Pass all arguments to $EDITOR
```

>[!TIP]
> Using zsh I symlink this to `$fpath`, add it as a zle widget, and bind it
> to a shortcut, as well as have it autoloaded.

License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
### [generate-readme.sh](./generate-readme.sh)

Generates this readme, by extracting docs between comment markers. Support
additional filetypes by adding to `comment_markers`

Usage:
```sh
./generate-readme.sh
```

License [MIT](./LICENSE)
### [get-package-description.sh](./get-package-description.sh)

Quckly grab a package description and put in clipboard

Requirements: 

- https://pacman.archlinux.page/
- https://github.com/bugaevc/wl-clipboard

Usage:
```sh
./get-package-description.sh [PACKAGE]
```

For example, here's a `nvim` command that will get description for whats in the
`"` register:
```vim
:lua vim.cmd('! ~/scripts/get-package-description.sh ' .. vim.fn.shellescape(vim.fn.getreg('"')))
```

License [MIT](./LICENSE)
### [git-ls-large-files.sh](./git-ls-large-files.sh)

See which files in a git repo history takes up the most space. Useful if
pruning assets or similar from a repo.

The following function is adapted from a Stack Overflow answer by
[MatrixManAtYrService](https://stackoverflow.com/users/1054322/matrixmanatyrservice)

- https://stackoverflow.com/questions/13403069/how-to-find-out-which-files-take-up-the-most-space-in-git-repo

Licensed under [CC BY-SA 4.0](./LICENSES/CC-BY-SA-4.0-LICENSE.txt)
### [git-update.sh](./git-update.sh)

Script to walk a list of repositories and either pull or clone, depending on
state. It is done in parallel, and takes a destination and a flat text file
with git repo urls to sync separated by newlines. Used in my dotfiles, when I
need to keep repos up to date with a job.

Requirements:
- https://www.gnu.org/software/parallel/
- https://git-scm.com/

Usage: `git-update.sh DEST REPO_FILE.txt`

```sh
./git-update.sh ~/src mydependencies.txt
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [hibernate.sh](./hibernate.sh)

Generic hibernate script, normally called via a graphical menu. Uses kdialog
for a confirm dialog. Locks screen before hibernating.

Requirements:
- https://invent.kde.org/utilities/kdialog
- https://github.com/hyprwm/hyprlock
- ./locker.sh
- ./lock.sh

Usage:
```sh
./hibernate.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [hypr-mouse-state.sh](./hypr-mouse-state.sh)

Handle the different states `mouse:275` (first side button on my setup)
I use this for various conflicting things, this handles toggling on and off
the various modes.

Requirements:
- https://github.com/hyprwm/Hyprland

Usage:

```hyprlang
exec = ~/scripts/hypr-mouse-state.sh sync
bind = $main_mod SHIFT,mouse:275,exec,~/scripts/hypr-mouse-state.sh menu
bind = $main_mod ALT,mouse:275,exec,~/scripts/hypr-mouse-state.sh alt
```

`sync` checks the state file and sets the mode accordingly
Calling the script multiple times will toggle the passed mode on and off

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [install-packages.sh](./install-packages.sh)

Install packages from YAML configuration using paru. Will look for
`~/.dependencies.yml` unless `[config.yml]` is provided.

Requirements:
- https://github.com/morganamilo/paru
- https://github.com/kislyuk/yq
- https://archlinux.org/

Usage:
```sh
./install-packages.sh [config.yml]
```

Example configuration:
```yml
packages:
  # Core system utilities
  core:
    - name: cryptsetup
      description: Userspace setup tool for transparent encryption of block devices using dm-crypt
      aur: false
    - name: git
      description: The fast distributed version control system
      aur: false
  # ...
```

For a full example of config refer to my [dotfile
dependencies](https://github.com/roosta/dotfiles/blob/f40a9dbbab2e721d9ec63dd2f51be55701faf5ba/.dependencies.yml)

> [!WARNING]
> Work in progress

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [iommu-groups.sh](./iommu-groups.sh)

Lists system iommu groups used for PCI passthrough via OVMF. This was copied
from the arch wiki in 2016, I would probably go check the latest wiki
revision to get up to date scripts.

- https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF

Usage:

```sh
./iommu-groups.sh
```

License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
### [locker.sh](./locker.sh)

Generic locker script, normally called via a graphical menu. Uses kdialog
for a confirm dialog.

Requirements:
- https://github.com/hyprwm/hyprlock
- https://invent.kde.org/utilities/kdialog

Usage:
```sh
./locker.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [lock.sh](./lock.sh)

Generic lock script, normally called via a graphical menu. Uses kdialog
for a confirm dialog.

Requirements:
- https://invent.kde.org/utilities/kdialog
- https://github.com/hyprwm/hyprlock
- ./locker.sh

Usage:
```sh
./lock.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [logout.sh](./logout.sh)

Generic logout script, normally called via a graphical menu. Uses kdialog
for a confirm dialog. Session needs to be started with uwsm.

Requirements:
- https://invent.kde.org/utilities/kdialog
- https://github.com/Vladimir-csp/uwsm

Usage:
```sh
./logout.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [media-browser.sh](./media-browser.sh)

Open firefox with a custom (media) profile and app_id (firefox-media)

Requirements:
- https://www.mozilla.org/firefox/

Usage:
```sh
./media-browser.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [media-clean.sh](./media-clean.sh)

Usage: `./media-clean.sh [OPTIONS] [DIRECTORY]`
Clean up RAR files from directories that contain extracted video files

    OPTIONS:
      -d, --dry-run    Show what would be deleted without actually deleting
      -h, --help       Show this help message

    DIRECTORY: Target directory to clean (default: current directory)

> [!WARNING]
> without passing dryrun this script WILL delete files, use at own
> risk.

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [power-menu.sh](./action-menu.sh)

Creates a menu using [rofi-menu.sh](./rofi-menu.sh) 

Requirements: 
- https://github.com/lbonn/rofi
- [rofi-menu.sh](./rofi-menu.sh)
- [shutdown.sh](./shutdown.sh)
- [reboot.sh](./reboot.sh)
- [logout.sh](./logout.sh)
- [lock.sh](./lock.sh)
- [suspend.sh](./suspend.sh)
- [hibernate.sh](./hibernate.sh)

See requirements for each respective script used in the menu
Usage:

Called as a mode in rofi like this

```rasi
configuration {
  modes: "actions:~/scripts/power-menu.sh";
}
```

Config for this menu looks like this:

```yml
items:
  - script: ~/scripts/shutdown.sh
    description: Shutdown
    icon: system-shutdown
# ...
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [reboot.sh](./reboot.sh)

Generic reboot script, normally called via a graphical menu. Uses kdialog
for a confirm dialog.

Requirements:
- https://invent.kde.org/utilities/kdialog

Usage:
```sh
./reboot.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [rofi-menu.sh](./rofi-menu.sh)

Script to create rofi menus based on a provided YAML config file
(`ROFI_MENU_CONFIG`)

Requirements:
- https://github.com/lbonn/rofi
- https://github.com/kislyuk/yq

Resources:
- https://github.com/davatorium/rofi/wiki/Script-Launcher
- https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown

Config Format (YAML): 
```yml
  items:
    - script: ~/path/to/my/script.sh
      description: Item description
      icon: icon_name
      args: ["optional", "arguments"]
```

Usage:
To create a menu create a script like this

```sh
export ROFI_MENU_CONFIG="${XDG_CONFIG_HOME}/rofi-menu/config.yaml"
exec "${HOME}/scripts/rofi-menu.sh" "$@"
```

Then in rofi you'add your new script to a mode
```rasi
modes: "run,mymode:~/scripts/script.sh";
```

>[!NOTE]
> It's a bit slow, tried to reduce the queries passed to yq, but depending
> on the complexity of menu will take longer than I'd like. 

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [screenshot.sh](./screenshot.sh)

Capture screenshot of wayland region selected by slurp, anotate with satty/swappy

Requirements:

- https://gitlab.freedesktop.org/emersion/grim
- https://github.com/emersion/slurp
- https://github.com/gabm/satty || https://github.com/jtheoof/swappy

Usage

```sh
./screenshot.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [shutdown.sh](./shutdown.sh)

Generic shutdown script, normally called via a graphical menu. Uses kdialog
for a confirm dialog.

Requirements:
- https://invent.kde.org/utilities/kdialog

Usage:
```sh
./shutdown.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [suspend.sh](./suspend.sh)

Generic suspend script, normally called via a graphical menu. Uses kdialog
for a confirm dialog.

Requirements:
- https://invent.kde.org/utilities/kdialog
- [locker.sh](./locker.sh)

Usage:
```sh
./suspend.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [sway-prop.sh](./sway-prop.sh)

source: https://gist.github.com/crispyricepc/f313386043395ff06570e02af2d9a8e0#file-wlprop-sh

Starts a window picker (slurp) and print selected window information. 
Similar to xprop. This is for sway, in Hyprland you can just use `hyprctl
clients` + some grep pattern will get you far.

Requirements:

- https://swaywm.org/
- https://jqlang.github.io/jq/
- https://github.com/emersion/slurp
- https://www.gnu.org/software/gawk/

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [switch-audio.sh](./switch-audio.sh)

Switches between audio sink (output) presets using pactl. Normally used with
a graphical menu. See menu scripts in this repo for an example.

    Usage: ./switch-audio.sh [headphones|speakers|tv|mute-output|mute-input|toggle]
      headphones: Activate headphones
      speakers: Activate speakers
      tv: Activate tv speakers
      mute-output: Toggle mute default output sinks
      mute-input: Toggle mute default input source
      toggle: Toggle between speakers and headphones

> [!NOTE]
> This is spesific for my personal setup, script needs modification to work
> for any setup.

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [switch-display.sh](./switch-display.sh)

Hyprland display switcher using dynamic monitor configs, switch between
monitor layouts.

This script is spesifific to my home setup. It uses symlinks to swap out
config for `~/.config/hypr/monitors/current.conf`. These conf files are
just hyprland config files with settings spesific to that display layout.
Remember to source the symlink in your main hyprland config:

```hyprland
source = ~/.config/hypr/monitors/current.conf
```

    Usage: ./switch-display.sh <config> [options]

    Configurations:
      [all desk mirror single tv] Switch to specified display configuration

    Example (Switch to desk configuration):
      ./switch-display.sh desk

    Note: Make sure to create config files in $HOME/.config/hypr/monitors matching argument name, e.g., desk.conf

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [system-monitor.sh](./system-monitor.sh)

System monitor

Requirements:
- https://github.com/kovidgoyal/kitty
- https://github.com/aristocratos/btop

Usage:
```sh
./system-monitor.sh`
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [tmux-attach.sh](./tmux-attach.sh)

Try to attach to existing tmux deattached session or start a new session

Requirements:
- https://github.com/tmux/tmux

Usage:
```sh
./tmux-attach.sh`
```
> [!NOTE]
> Pending deprecation, I don't generally use this, I instead use
> `./tmux-main.sh`*

> [!NOTE]
> I belive this was orignally copied from wiki.archlinux.org way back in
> 2015, so I'm keeping the license in accordance with the wiki.

License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
### [tmux-main.sh](./tmux-main.sh)

Main session with default layout. Useful if you want tmux to always be
started with terminal emulator. Source either in shell rc file, or in window
manager on terminal emulator startup, or just run manually.

Requirements:
- https://github.com/tmux/tmux

Usage:
```sh
./tmain.sh
```

Resources:
1. https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
2. https://wiki.archlinux.org/title/Tmux#Autostart_tmux_with_default_tmux_layout

License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
### [tmux-notify.sh](./tmux-notify.sh)

Use libnotify to notify when a tmux window receives a bell. Used with
`tmux-update-window.sh`.

Requirements:
- https://gitlab.gnome.org/GNOME/libnotify

Usage:
```tmux
set-hook -g alert-silence 'run ". ~/utils/tmux-notify.sh; return 0"'
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [tmux-ssh.sh](./tmux-ssh.sh)

Starts a new session called `ssh` that launches [ngrok](https://ngrok.com/),
I use this sometimes if I need to access a computer over ssh that doesn't
have a static ip.

Requirements:
- https://ngrok.com/
- https://github.com/tmux/tmux

Usage:
Takes TCP PORT as argument to ngrok.

```tmux
./tmux-ssh.sh [PORT]
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [tmux-update-window.sh](./tmux-update-window.sh)

Create an update window if `main` session exist. Set this window to monitor
silence. When I start an update, and then do something else I'd like to be
alerted on silence since that indicates that its either finished or requires
input.

Requirements:
- https://ngrok.com/
- https://github.com/tmux/tmux

Usage:
Requires a running tmux session

```tmux
./tmux-update-window.sh
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [torrent-done.sh](./torrent-done.sh)

A simple script to extract a rar file inside a directory downloaded by
Transmission. It uses environment variables passed by the transmission client
to find and extract any rar files from a downloaded torrent into the folder
they were found in.

Requirements:
- https://transmissionbt.com/

Usage:
Configure to run on torrent completion in your client. See `./media-clean.sh`
for a way to clean up after this script.

> [!NOTE]
> I don't actually know where this snippet originated, its all over the web,
> in gists and other script repos. I've seen other variants of this licensed
> under MIT, so I'm assuming that's OK here to, but I'm not 100%. If anyone
> knows, please let me know so I can add proper credit
 
License [MIT](./LICENSES/MIT-LICENSE.txt)
### [update-nvim-plugins.sh](./update-nvim-plugins.sh)

Commit changed lock file to dotfiles. Pass --sync to also update using
lazy.nvim, otherwise it will commit a dirty lock file.

Requirements:
- https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
- https://github.com/folke/lazy.nvim

Usage:
```bash
./update-nvim-plugins.sh [--sync]
```

License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
### [updates-arch-combined.sh](./updates-arch-combined.sh)

Requirements:
- https://gitlab.archlinux.org/pacman/pacman-contrib

Usage:
This is normally used in a bar, in polybar for example

```ini
[module/updates-arch-combined]
 type = custom/script
 exec = ~/scripts/updates-arch-combined.sh
 interval = 600
```

Source: https://github.com/polybar/polybar-scripts

License [UNLICENSE](./LICENSES/UNLICENSE.txt)
### [waybar-dev.sh](./waybar-dev.sh)

Uses `entr` to watch for changes in my Waybar config files, and will restart
Waybar on save. I use this when I develop themes and customization, you can
pass `-d` to open a GTK debugger window as well, to get CSS selectors used
for styling Waybar.

Requirements:
- https://eradman.com/entrproject/
- https://github.com/Alexays/Waybar

Usage:

```tmux
./waybar-dev.sh [OPTIONS]

    OPTIONS:
      -d, --debug      open debug inspector
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [qute-nuke-cookies.py](./qute-nuke-cookies.py)

Usage: `qute-nuke-cookies.py [-h] [-n] [-w WHITELIST_FILE]`

Nuke qutebrowser cookies except for whitelisted domains.

      options:
        -h, --help            show this help message and exit
        -n, --dry-run         Print actions, but do not modify the database
        -w, --whitelist-file WHITELIST_FILE
                        Whitelist file (default:
                        $XDG_CONFIG_HOME/qutebrowser/cookie_whitelist).

Cookie whitelist file:
`$XDG_CONFIG_HOME/qutebrowser/cookie_whitelist` (use `-w` to use a different
location) Config file is flat file with URLs, and supports simple comments (#)

```conf
# My whitelist
example.com
google.com
```

License [MIT](./LICENSES/MIT-LICENSE.txt)
### [bookmarks-md.mjs](./bookmarks-md.mjs)

Parse chrome bookmark json, it looks for a folder in the bookmark_bar that
is called `capture`. It'll go through each outputting to stdout each bookmark
as a markdown formatted string.

Rationale: I don't main google-chrome, I use it on some other machines, and
sometimes I stuble on something interesting in chrome I'd like to put in my
notes, so I put it in a folder called `capture` to be processed later. Using
this script I can save script output in my notes (markdown)

Usage
```sh
node bookmarks-md.mjs
```

License [MIT](./LICENSES/MIT-LICENSE.txt)

## Licences

See individual script headers, or attached licenses in [LICENSES](./LICENSES)

- [CC BY-SA 4.0](./LICENSES/CC-BY-SA-4.0-LICENSE.txt) 
- [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
- [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
- [MIT LICENSE](./LICENSES/MIT-LICENSE.txt)

---

*This README was automatically generated by `generate-readme.sh` on 2026-02-02 13:32:26*
