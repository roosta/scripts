#!/bin/bash
echo "OPTIND starts at $OPTIND"
while getopts "dt" optname
  do
    case "$optname" in
      "d")
      echo "Option $optname is specified"
      ;;
      "y")
      echo "Option $optname has value $OPTARG"
      ;;
      "?")
      echo "Unknown option $OPTARG"
      ;;
      ":")
      echo "No argument value for option $OPTARG"
      ;;
      *)
      # Should not occur
      echo "Unknown error while processing options"
      ;;
    esac
    echo "OPTIND is now $OPTIND"
  done
