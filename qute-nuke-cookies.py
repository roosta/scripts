#!/usr/bin/env python
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Drafted June 2025 based on LLM suggestion (GTP-4.1)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [qute-nuke-cookies.py](./qute-nuke-cookies.py)
#
# Usage: `qute-nuke-cookies.py [-h] [-n] [-w WHITELIST_FILE]`
#
# Nuke qutebrowser cookies except for whitelisted domains.
#
#       options:
#         -h, --help            show this help message and exit
#         -n, --dry-run         Print actions, but do not modify the database
#         -w, --whitelist-file WHITELIST_FILE
#                         Whitelist file (default:
#                         $XDG_CONFIG_HOME/qutebrowser/cookie_whitelist).
#
# Cookie whitelist file:
# `$XDG_CONFIG_HOME/qutebrowser/cookie_whitelist` (use `-w` to use a different
# location) Config file is flat file with URLs, and supports simple comments (#)
# 
# ```conf
# # My whitelist
# example.com
# google.com
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

import sqlite3
import os
import argparse
import sys

def get_default_whitelist_file():
    """Return the default whitelist file path per XDG spec."""
    cfg_home = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    return os.path.join(cfg_home, "qutebrowser", "cookie_whitelist")

def load_whitelist(filename):
    """
    Load domains from whitelist file, one per line.
    Lines starting with # and blanks are ignored.
    """
    whitelist = []
    if not os.path.isfile(filename):
        print(f"❌ Whitelist file not found: {filename}")
        print("Please create it with one domain per line, '#' for comments (e.g. example.com).")
        sys.exit(1)
    with open(filename, "r") as f:
        for line in f:
            stripped = line.strip()
            if stripped and not stripped.startswith("#"):
                whitelist.append(stripped)
    return whitelist

def is_whitelisted(host, whitelist):
    return any(domain in host for domain in whitelist)

def main(dry_run, whitelist_file):
    whitelist = load_whitelist(whitelist_file)
    
    # --- edit this for profile support, if needed:
    cookie_db = os.path.expanduser("~/.local/share/qutebrowser/webengine/Cookies")

    if not os.path.exists(cookie_db):
        print(f"Cookie database not found: {cookie_db}")
        return

    print(f"Loaded {len(whitelist)} domains from whitelist: {whitelist_file}")
    print(f"Connecting to DB: {cookie_db}")

    conn = sqlite3.connect(cookie_db)
    cursor = conn.cursor()

    cursor.execute("SELECT host_key, name, path FROM cookies")
    cookies = cursor.fetchall()

    to_delete = []
    to_keep = []

    for host_key, name, path in cookies:
        if is_whitelisted(host_key, whitelist):
            to_keep.append((host_key, name, path))
        else:
            to_delete.append((host_key, name, path))

    print(f"\n=== Cookie keep/delete summary ===")
    print(f"Keeping {len(to_keep)} cookies (whitelisted):")
    for host_key, name, path in to_keep:
        print(f"  KEEP   {host_key.ljust(30)} {name}")

    print(f"Deleting {len(to_delete)} cookies:")
    for host_key, name, path in to_delete:
        print(f"  NUKE   {host_key.ljust(30)} {name}")

    if dry_run:
        print("\n[Dry run] No database changes made.")
    else:
        if to_delete:
            print("\nDeleting nuked cookies from database...")
            for host_key, name, path in to_delete:
                cursor.execute(
                    "DELETE FROM cookies WHERE host_key=? AND name=? AND path=?",
                    (host_key, name, path)
                )
            conn.commit()
            print("Deleted nuked cookies. Done.")
        else:
            print("Nothing to delete!")
    conn.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Nuke qutebrowser cookies except for whitelisted domains.")
    parser.add_argument(
        "-n", "--dry-run", action="store_true",
        help="Print actions, but do not modify the database"
    )
    parser.add_argument(
        "-w", "--whitelist-file", type=str, default=get_default_whitelist_file(),
        help="Whitelist file (default: $XDG_CONFIG_HOME/qutebrowser/cookie_whitelist)."
    )
    args = parser.parse_args()
    main(args.dry_run, args.whitelist_file)
