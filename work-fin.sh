#!/bin/bash
set -e
locations=(~/src ~/org ~/etc)

## check if dirty

# if git diff-files --quiet; then
#   echo "yay";
# fi
# && make commit && git push

# flush gnome keyring
# gnome-keyring-daemon -r -d

cherry-each() {
  while IFS= read -r -d '' dir
  do
    cd $dir || exit 1
    [ -d .git ] || git cherry -v

    let unpushed=$(cd "$dir" && git cherry -v)
    if $unpushed; then
      echo "unpushed commits in $dir"
    fi
  done <   <(find "$1" -maxdepth 1 -type d -print0)
}

# diff-each() {
#   for dir in $(find ./ -type d -maxdepth 3) ; do
#     (cd "$dir" && git cherry -v)
#   done
# }

cherry-each "$@"
