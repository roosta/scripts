#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the “Software”), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Drafted May 2025 based on LLM suggestion (claude-3.7-sonnet)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [install-packages.sh](./install-packages.sh)
#
# Install packages from YAML configuration using paru. Will look for
# `~/.dependencies.yml` unless `[config.yml]` is provided.
#
# Requirements:
# - https://github.com/morganamilo/paru
# - https://github.com/kislyuk/yq
# - https://archlinux.org/
#
# Usage:
# ```sh
# ./install-packages.sh [config.yml]
# ```
#
# Example configuration:
# ```yml
# packages:
#   # Core system utilities
#   core:
#     - name: cryptsetup
#       description: Userspace setup tool for transparent encryption of block devices using dm-crypt
#       aur: false
#     - name: git
#       description: The fast distributed version control system
#       aur: false
#   # ...
# ```
#
# For a full example of config refer to my [dotfile
# dependencies](https://github.com/roosta/dotfiles/blob/f40a9dbbab2e721d9ec63dd2f51be55701faf5ba/.dependencies.yml)
# 
# > [!WARNING]
# > Work in progress
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC
# install-packages.sh - Install packages from YAML configuration using paru
# Usage: ./install-packages.sh [config.yaml]

set -euo pipefail

CONFIG_FILE="${1:-$HOME/.dependencies.yml}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file '$CONFIG_FILE' not found."
  exit 1
fi

if ! command -v yq &> /dev/null; then
  echo "Error: yq is required but not installed."
  echo "Please install it first with: paru -S yq"
  exit 1
fi

if ! command -v paru &> /dev/null; then
  echo "Error: paru is required but not installed."
  echo "Please install it first: https://github.com/Morganamilo/paru#installation"
  exit 1
fi

echo "🔍 Reading package configuration from $CONFIG_FILE..."

PACKAGE_JSON=$(yq < "$CONFIG_FILE")

CURRENT=0;

# Get all package categories
CATEGORIES=$(jq '.packages | keys | .[]' <<< "$PACKAGE_JSON")

# Count total packages for progress tracking
TOTAL_PACKAGES=$(jq '.packages.[] | .[] | length' <<< "$PACKAGE_JSON" | wc -l)

echo "📦 Found $TOTAL_PACKAGES packages to process across $(echo "$CATEGORIES" | wc -l) categories"
echo "⚙️ Starting installation..."

for category in $CATEGORIES; do
  echo "🔹 Processing category: $category"

  PACKAGES=$(jq ".packages.${category}" <<< "$PACKAGE_JSON")
  csv=$(jq -r '.[]|[.name, .optional // false, .aur] | @tsv' <<< "$PACKAGES");

  # Skip optional packages for now
  while IFS=$'\t' read -r name optional _; do
    if [[ "$optional" == "true" ]]; then
      echo "  ⏩ Skipping optional package: $name"
      continue
    fi

    CURRENT=$((CURRENT + 1))
    echo "  🔄 Installing package ($CURRENT/$TOTAL_PACKAGES): $name"

    # Install the package with paru
    if ! paru -S --needed --noconfirm "$name"; then
      echo "  ❌ Failed to install: $name"
    else
      echo "  ✅ Successfully installed: $name"
    fi
  done <<< "$csv"

done

echo "🎉 Package installation completed!"
