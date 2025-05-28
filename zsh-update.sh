#!/usr/bin/env zsh
# Updates zsh plugins with zplug, used in an update script job that will ensure
# that zsh plugins are updated
# ref: https://github.com/zplug/zplug

source ~/.zplug/init.zsh
source ~/.zshrc
zplug update
