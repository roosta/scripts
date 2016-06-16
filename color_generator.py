#!/bin/env python
"""
docstring
"""
# from subprocess import call
from yaml import safe_load

INPUT = open('vars/sourcery_palette.yml')
DEST = open('xcolors/test.xresources', 'w')

# use safe_load instead load
PALETTE = safe_load(INPUT)

INPUT.close()

print(PALETTE['bright_green'])


# call(["echo", PALETTE['bright_green']])
