#!/usr/bin/env bash
# BEGIN_DOC
# ### [git-ls-large-files.sh](./git-ls-large-files.sh)
#
# See which files in a git repo history takes up the most space. Useful if
# pruning assets or similar from a repo.
#
# The following function is adapted from a Stack Overflow answer by
# [MatrixManAtYrService](https://stackoverflow.com/users/1054322/matrixmanatyrservice)
#
# - https://stackoverflow.com/questions/13403069/how-to-find-out-which-files-take-up-the-most-space-in-git-repo
#
# Licensed under [CC BY-SA 4.0](./LICENSES/CC-BY-SA-4.0-LICENSE.txt)
# END_DOC
while read -r largefile; do
    echo "$largefile" | awk '{printf "%s %s ", $1, $3 ; system("git rev-list --all --objects | grep " $1 " | cut -d \" \" -f 2-")}'
done <<< "$(git rev-list --all --objects | awk '{print $1}' | git cat-file --batch-check | sort -k3nr | head -n 20)"
