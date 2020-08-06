#!/bin/env bash

focuswindow(){

  declare -i forcing hvar

  forcing=$((__o[FORCE]?2:__o[force]?1:0))
  
  # if target window is active (current), 
  if ((i3list[AWC] == i3list[TWC])); then
    
    # send it to the scratchpad
    if ((!__o[nohide])); then
      if [[ -z ${i3list[TWP]} ]]; then
        # keep floating state in a var
        i3-msg -q "[con_id=${i3list[TWC]}]" move scratchpad
        i3var set "hidden${i3list[TWC]}" "${i3list[TWF]}"
      else
        # if it is handled by i3fyra and active
        # hide the container
        i3fyra --force --hide "${i3list[TWP]}" --array "$_array"
      fi

     ((forcing == 2)) && [[ -n ${__o[command]} ]] \
       && eval "${__o[command]}" > /dev/null 2>&1 & 

    else

     ((forcing > 0)) && [[ -n ${__o[command]} ]] \
       && eval "${__o[command]}" > /dev/null 2>&1 &  
    fi

  else # focus target window.
    # hvar can contain floating state of target
    hvar=$(i3var get "hidden${i3list[TWC]}")
    if [[ -n $hvar ]]; then
      # windows need to be floating on scratchpad
      # so to "restore" a tiling window we do this
      ((hvar == 1)) && fs=enable || fs=disable
      # clear the variable
      i3var set "hidden${i3list[TWC]}"
    else
      ((i3list[TWF] == 1)) && fs=enable || fs=disable
    fi
    # target is not handled by i3fyra and not active
    # TWP - target window parent container name
    if [[ -z ${i3list[TWP]} ]]; then

      # target is not on active workspace
      if ((i3list[WSA] != i3list[WST])); then
        # WST == -1 , target window is on scratchpad
        if ((i3list[WST] == -1 || __o[summon])); then
          i3-msg -q "[con_id=${i3list[TWC]}]"   \
            move to workspace "${i3list[WAN]}", \
            floating $fs
            ((i3list[TWF] && __o[mouse])) && sendtomouse
        else
          i3-msg -q workspace "${i3list[WTN]}"
        fi
        
      fi
    else # window is handled by i3fyra and not active

      # window is not on current ws
      if ((i3list[WSA] != i3list[WST])); then

        # current ws is i3fyra WS
        if ((i3list[WSF] == i3list[WSA])); then
          # target window is in a hidden (LHI) container
          [[ ${i3list[TWP]} =~ [${i3list[LHI]}] ]] \
            && i3fyra --force --show "${i3list[TWP]}" --array "$_array"

        else # current ws is not i3fyra WS
          # WST == -1 , target window is on scratchpad
          if ((i3list[WST] == -1 || __o[summon])); then
            i3-msg -q "[con_id=${i3list[TWC]}]" \
              move to workspace "${i3list[WAN]}", floating $fs
              ((i3list[TWF] && __o[mouse])) && sendtomouse
          else # got to target windows workspace
            # WTN == name (string) of workspace
            i3-msg -q workspace "${i3list[WTN]}"
          fi
        fi
      fi
    fi

    i3-msg -q "[con_id=${i3list[TWC]}]" focus

   ((forcing > 0)) && [[ -n ${__o[command]} ]] \
     && eval "${__o[command]}" > /dev/null 2>&1 & 
  fi

  echo "${i3list[TWC]}"
}
