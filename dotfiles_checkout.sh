# https://wiki.archlinux.org/title/Dotfiles
mkdir -p .dotfiles-backup && \
  /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout 2>&1 | \
  grep -E "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .dotfiles-backup/{}
