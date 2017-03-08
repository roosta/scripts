# $1 = device $2 = name
open () {
  sudo cryptsetup --type luks open $1 $2 && sudo mount -t ext4 /dev/mapper/"$2" ~/mnt/"$2"
}

close () {
  sudo umount ~/mnt/"$1" && sudo cryptsetup close $1
}

usage() {
	cat >&2 <<EOL

Usage: crypthelper command [DEVICE] [NAME]

commands:
  open:             open and mount
  close:            umound and close
EOL
	exit 1
}

run () {
  (( $# >= 1 )) || usage
  case "$1" in
    "open")
      open ${@:2}
      ;;
    "close")
      close ${@:2}
      ;;
    *)
      usage
  esac
}

run "${@}"
