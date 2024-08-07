#!/bin/sh
swayidle \
    timeout 10 'swaylock -f -c 000000' \
    timeout 20 'wlr-randr --output eDP-1 --off' \
    resume 'wlr-randr --output eDP-1 --on; qtile restart' \
    before-sleep 'swaylock -f -c 000000' &
