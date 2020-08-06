#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
i3run - version: 0.085
updated: 2020-08-06 by budRich
EOB
}



___printhelp(){
  
cat << 'EOB' >&2
i3run - Run, Raise or hide windows in i3wm


SYNOPSIS
--------
i3run --instance|-i INSTANCE [--summon|-s] [--nohide|-g] [--mouse|-m] [--rename|-x OLD_NAME] [--force|-f] [--FORCE|-F] [--command|-e COMMAND]
i3run --class|-c CLASS [--summon|-s] [--nohide|-g] [--mouse|-m] [--rename|-x OLD_NAME] [--force|-f] [--FORCE|-F] [--command|-e COMMAND]
i3run --title|-t  TITLE [--summon|-s] [--nohide|-g] [--mouse|-m] [--rename|-x OLD_NAME] [--force|-f] [--FORCE|-F] [--command|-e COMMAND]
i3run --conid|-n CON_ID [--summon|-s] [--nohide|-g] [--mouse|-m] [--rename|-x OLD_NAME] [--force|-f] [--FORCE|-F] [--command|-e COMMAND]
i3run --help|-h
i3run --version|-v

OPTIONS
-------

--instance|-i INSTANCE  
Search for windows with the given INSTANCE


--summon|-s  
Instead of switching workspace, summon window to
current workspace


--nohide|-g  
Don't hide window/container if it's active.


--mouse|-m  
The window will be placed on the location of the
mouse cursor when it is created or shown. (needs
xdotool)  


--rename|-x OLD_NAME  
If the search criteria is -i (instance), the
window with instance: OLDNAME will get a n new
instance name matching the criteria when it is
created (needs xdotool).  


   i3run --instance budswin --rename sublime_main -command subl
   
   # when the command above is executed:
   # a window with the instance name: "budswin" will be searched for.
   # if no window is found the command: "subl" will get executed,
   # and when a window with the instance name: "sublime_main" is found,
   # the instance name of that window will get renamed to: "budswin"





--force|-f  
Execute COMMAND (--command), even if the window
already exist. But not when hiding a window.


--FORCE|-F  
Execute COMMAND (--command), even if the window
already exist.


--command|-e COMMAND  
Command to run if no window is found. Complex
commands can be written inside quotes:  

   i3run -i sublime_text -e 'subl && notify-send "sublime is started"'




--class|-c CLASS  
Search for windows with the given CLASS


--title|-t TITLE  
Search for windows with the given TITLE


--conid|-n CON_ID  
Search for windows with the given CON_ID


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:i3run" \
    --options "i:sgmx:fFe:c:t:n:hv" \
    --longoptions "instance:,summon,nohide,mouse,rename:,force,FORCE,command:,class:,title:,conid:,help,version," \
    -- "$@" || exit 98
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --instance   | -i ) __o[instance]="${2:-}" ; shift ;;
    --summon     | -s ) __o[summon]=1 ;; 
    --nohide     | -g ) __o[nohide]=1 ;; 
    --mouse      | -m ) __o[mouse]=1 ;; 
    --rename     | -x ) __o[rename]="${2:-}" ; shift ;;
    --force      | -f ) __o[force]=1 ;; 
    --FORCE      | -F ) __o[FORCE]=1 ;; 
    --command    | -e ) __o[command]="${2:-}" ; shift ;;
    --class      | -c ) __o[class]="${2:-}" ; shift ;;
    --title      | -t ) __o[title]="${2:-}" ; shift ;;
    --conid      | -n ) __o[conid]="${2:-}" ; shift ;;
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 




