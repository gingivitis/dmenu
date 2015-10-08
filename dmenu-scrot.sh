#!/bin/bash

IMG_PATH=$HOME/screenshots
EDIT=gimp

prog="1.quick_fullscreen
2.delayed_fullscreen
3.section
4.edit_fullscreen"

cmd=$(dmenu  -l 20 "$@" -p 'screenshot'   <<< "$prog")

cd $IMG_PATH
case ${cmd%% *} in
  1.quick_fullscreen)	scrot -d 1 '%Y-%m-%d-@%H-%M-%S-scrot.png'  && notify-send -u low 'Scrot' 'Fullscreen taken and saved'
    ;;
  2.delayed_fullscreen)	scrot -d 4 '%Y-%m-%d-@%H-%M-%S-scrot.png'  && notify-send -u low 'Scrot' 'Fullscreen Screenshot saved'
    ;;
  3.section)	scrot -s '%Y-%m-%d-@%H-%M-%S-scrot.png' && notify-send -u low 'Scrot' 'Screenshot of section saved'
    ;;
  4.edit_fullscreen)	scrot -d 1 '%Y-%m-%d-@%H-%M-%S-scrot.png' -e "$EDIT \$f"  && notify-send -u low 'Scrot' 'Screenshot edited and saved'
    ;;
  *) exec "'${cmd}'"
    ;;
esac

