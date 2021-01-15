#!/bin/sh

# common functions
die() {
  echo $1
  exit 1
}

version_greater_equal() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# common checks
yq_version=$(yq -V | cut -d' ' -f 3)
version_greater_equal "${yq_version}" 3.0.0 || die "yq version 3.0.0 or greater required! (https://github.com/mikefarah/yq)"
