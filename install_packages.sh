#!/usr/bin/env bash

# install_packages.sh - Install packages from YAML configuration using paru
# Usage: ./install_packages.sh [config.yaml]

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
