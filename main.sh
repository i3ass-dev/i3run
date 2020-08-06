#!/usr/bin/env bash

main(){

  declare -a acri   # options passed to i3list
  declare -A i3list # globals array

  for k in instance class title conid ; do
    [[ -n ${__o[$k]} ]] \
      && acri=("--$k" "${__o[$k]}") && break
  done ; unset k

  [[ -z ${acri[*]} ]] \
    && ERH "please specify a criteria"

  _array=$(i3list "${acri[@]}")
  eval "$_array"

  # if window doesn't exist, launch the command.
  if [[ -z ${i3list[TWC]} ]]; then
    launchcommand
  else
    focuswindow
  fi
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
