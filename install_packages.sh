#!/usr/bin/env bash

# install_packages.sh - Install packages from YAML configuration using paru
# Usage: ./install_packages.sh [config.yaml]

set -euo pipefail

CONFIG_FILE="${1:-dependencies.yaml}"

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

# Get all package categories
CATEGORIES=$(yq '.packages | keys | .[]' "$CONFIG_FILE")

# Count total packages for progress tracking
TOTAL_PACKAGES=$(yq '.packages.* | .[] | select(.aur != null) | length' "$CONFIG_FILE" | wc -l)
CURRENT=0

echo "📦 Found $TOTAL_PACKAGES packages to process across $(echo "$CATEGORIES" | wc -l) categories"
echo "⚙️ Starting installation..."

for category in $CATEGORIES; do
  echo "🔹 Processing category: $category"

  # Get all packages in this category
  PACKAGES=$(yq ".packages.${category[]} | select(.aur != null) | 
    {name: .name, aur: .aur, optional: .optional // false}" "$CONFIG_FILE")

  # Process each package
  echo "$PACKAGES" | yq -o=json | jq -c '.[]' | while read -r pkg_json; do
  name=$(echo "$pkg_json" | jq -r '.name')
  # aur=$(echo "$pkg_json" | jq -r '.aur')
  optional=$(echo "$pkg_json" | jq -r '.optional')

    # Skip optional packages for now
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
  done
done

echo "🎉 Package installation completed!"
