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
# Drafted June 2025 based on LLM suggestion (claude-3.7-sonnet)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [media-clean.sh](./media-clean.sh)
#
# Usage: `./media-clean.sh [OPTIONS] [DIRECTORY]`
# Clean up RAR files from directories that contain extracted video files
#
#     OPTIONS:
#       -d, --dry-run    Show what would be deleted without actually deleting
#       -h, --help       Show this help message
#
#     DIRECTORY: Target directory to clean (default: current directory)
#
# > [!WARNING]
# > without passing dryrun this script WILL delete files, use at own
# > risk.
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

set -euo pipefail

# Default values
DRY_RUN=false
TARGET_DIR="."

# Video file extensions
VIDEO_EXTENSIONS=("mp4" "mkv" "avi" "mov" "wmv" "flv" "webm" "m4v" "mpg" "mpeg" "ts" "m2ts")

usage() {
  echo "Usage: $0 [OPTIONS] [DIRECTORY]"
  echo "Clean up RAR files from directories that contain extracted video files"
  echo ""
  echo "OPTIONS:"
  echo "  -d, --dry-run    Show what would be deleted without actually deleting"
  echo "  -h, --help       Show this help message"
  echo ""
  echo "DIRECTORY: Target directory to clean (default: current directory)"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option $1"
      usage
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

# Verify target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Directory '$TARGET_DIR' does not exist"
  exit 1
fi

# Counters
total_dirs=0
dirs_with_rars=0
dirs_cleaned=0
files_to_delete=0
total_size=0

echo "Scanning directory: $TARGET_DIR"
if [[ "$DRY_RUN" == "true" ]]; then
  echo "=== DRY RUN MODE - No files will be deleted ==="
fi
echo ""

# Process each subdirectory
while IFS= read -r -d '' dir; do
  ((++total_dirs))

  # Build find expression for video files (excluding samples)
  video_find_expr=()
  for ext in "${VIDEO_EXTENSIONS[@]}"; do
    video_find_expr+=(-iname "*.${ext}" -o)
  done
  # Remove the last -o
  unset 'video_find_expr[-1]'

  # Find video files (excluding sample directories and sample files)
  video_files=()
  while IFS= read -r -d '' file; do
    # Skip if in sample directory or filename contains sample
    if [[ "$file" =~ /[Ss][Aa][Mm][Pp][Ll][Ee]/ ]] || [[ "$(basename "$file")" =~ [Ss][Aa][Mm][Pp][Ll][Ee] ]]; then
      continue
    fi
    video_files+=("$file")
  done < <(find "$dir" -type f \( "${video_find_expr[@]}" \) -print0 2>/dev/null || true)

  # Find RAR files
  rar_files=()
  while IFS= read -r -d '' file; do
    rar_files+=("$file")
  done < <(find "$dir" -maxdepth 1 -type f \( \
    -iname "*.rar" -o \
    -iname "*.r[0-9][0-9]" -o \
    -iname "*.r[0-9][0-9][0-9]" -o \
    -iname "*.part[0-9]*.rar" -o \
    -iname "*.part[0-9][0-9]*.rar" \
    \) -print0 2>/dev/null || true)

  # If we have RAR files
  if [[ ${#rar_files[@]} -gt 0 ]]; then
    ((++dirs_with_rars))

    # If we also have video files, we can clean up
    if [[ ${#video_files[@]} -gt 0 ]]; then
      ((++dirs_cleaned))
      echo "📁 $(basename "$dir"): Found ${#video_files[@]} video file(s), cleaning ${#rar_files[@]} RAR file(s)"

        for rar_file in "${rar_files[@]}"; do
          ((++files_to_delete))
          file_size=$(stat -f%z "$rar_file" 2>/dev/null || stat -c%s "$rar_file" 2>/dev/null || echo 0)
          ((total_size += file_size))

          if [[ "$DRY_RUN" == "true" ]]; then
            echo "  🗑️  Would delete: $(basename "$rar_file") ($(numfmt --to=iec --suffix=B "$file_size"))"
          else
            echo "  🗑️  Deleting: $(basename "$rar_file") ($(numfmt --to=iec --suffix=B "$file_size"))"
            rm "$rar_file"
          fi
        done
        echo ""
      else
        echo "⚠️  $(basename "$dir"): Found ${#rar_files[@]} RAR file(s) but no extracted video files - skipping"
    fi
  fi
done < <(find "$TARGET_DIR" -type d -print0)

# Summary
echo "==================== SUMMARY ===================="
echo "Directories scanned: $total_dirs"
echo "Directories with RAR files: $dirs_with_rars"
echo "Directories cleaned: $dirs_cleaned"
echo "RAR files processed: $files_to_delete"
if [[ $total_size -gt 0 ]]; then
  echo "Total space freed: $(numfmt --to=iec --suffix=B $total_size)"
fi

if [[ "$DRY_RUN" == "true" && $files_to_delete -gt 0 ]]; then
  echo ""
  echo "Run without --dry-run to actually delete these files."
fi

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
