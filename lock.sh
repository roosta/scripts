#!/usr/bin/env bash

cfg_tmpdir="/tmp/$USER"

err() { echo "$*" >&2; }

usage() {
 while read; do printf '%s\n' "$REPLY"; done <<- EOF
   Usage: i3lock-extra <-m mode> [args]
   Modes:
          rnd <dir>        # Use a random image from a dir.
          blur [img]       # Take a screenshot, blur it out. If provided, add an image on top.
          pizelize [img]   # Same as the abobe, but pixelize the image instead.
          img <img>        # Use the provided image.
 EOF
}

random() {
 images_dir=$1

 images=( "$images_dir"/* )
 images_c="${#images[*]}"
 image_r=$(( RANDOM % images_c ))
 image="${images[$image_r]}"

 printf '%s' "$image"
}

deskshot() {
 declare dist_mode=$1; shift

 case "$dist_mode" in
   blur) scrot -e "convert -gaussian-blur 4x8 \$f ${cfg_tmpdir}/lockbg.png" "${cfg_tmpdir}/lockbg.png";;
   pixelize) scrot -e "convert \$f -scale 25% -scale 400% ${cfg_tmpdir}/lockbg.png" "${cfg_tmpdir}/lockbg.png";;
 esac

 if (( $# )); then
   convert -gravity center -composite -matte "${cfg_tmpdir}/lockbg.png" "$1" "${cfg_tmpdir}/lockbg.png"
 fi
 
 image="${cfg_tmpdir}/lockbg.png"
 printf '%s' "$image"
}

main() {
 while (( $# )); do
   case "$1" in
     --help|-h) usage; return 0;;
     --mode|-m) mode="$2"; shift;;

     --) shift; break;;
     -*)
       err "Unknown key: $1"
       usage
       return 1
     ;;

     *) break;;
   esac
   shift
 done

 (( $# )) || {
   usage
   return 1
 }

 [[ -d "$cfg_tmpdir" ]] || {
   mkdir -p "$cfg_tmpdir" || {
     return 1
   }
 }

 case "${mode:-img}" in
   blur|pixelize) image=$( deskshot "$mode" "$1" );;
   rnd) image=$( random "$1" );;
   img) image="$1";;
   *) usage; return 1;;
 esac

 until i3lock -n -t -i "$image"; do
   true
 done
}

main "$@"
