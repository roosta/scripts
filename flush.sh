#!/bin/bash
# flush gnome keyring
gnome-keyring-daemon -r -d &&
fusermount -u ~/Private
