#!/usr/bin/env bash

launchcommand(){

  [[ -z ${__o[command]} ]] && ERX i3run no command, no action
  
  eval "${__o[command]}" > /dev/null 2>&1 &

  declare -a xdtopt # options passed to xdotool

  [[ -n ${__o[rename]} ]] && {

    [[ ${acri[0]} = '--class'    ]] && xdtopt=("--class")
    [[ ${acri[0]} = '--instance' ]] && xdtopt=("--classname")
    [[ ${acri[0]} = '--title   ' ]] && xdtopt=("--name")

    xdtopt+=("${acri[1]}")

    xdotool set_window "${xdtopt[@]}" \
      "$(i3get "${acri[0]}" "${__o[rename]}" -r d -y)"
  }
  
  i3list[TWC]=$(i3get -y "${acri[@]}")
  
  ((__o[mouse])) && sendtomouse

  i3-msg -q "[id=${i3list[TWC]}]" focus
  echo "${i3list[TWC]}"
}
