#!/bin/env bash

set -E
trap '[ "$?" -ne 98 ] || exit 98' ERR

_tmpE=$(mktemp)

ERX() { echo  "[ERROR] $*" > "$_tmpE" ; exit 98 ;}
ERR() { echo  "[WARNING] $*" > "$_tmpE"  ;}
ERM() { echo  "$*" > "$_tmpE"  ;}
ERH(){
  ___printhelp >&2
  [[ -n "$*" ]] && printf '\n%s\n' "$*" >&2
  exit 98
}
