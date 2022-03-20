#!/bin/bash
set -o nounset
set -o pipefail
set -o errexit


if [[ -n ${DEBUG:-} ]]; then
  echo "=> DEBUG is enabled"
  echo "=> Your passed args are: $1"
  set -o xtrace
fi

/go/bin/tuf "$1"