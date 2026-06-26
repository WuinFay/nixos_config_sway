#!/usr/bin/env bash
mkdir -p ~/Imagenes
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

case "$1" in
    area)
        grim -g "$(slurp)" ~/Imagenes/captura_${TIMESTAMP}.png
        ;;
    screen)
        grim ~/Imagenes/captura_${TIMESTAMP}.png
        ;;
    active)
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" ~/Imagenes/captura_${TIMESTAMP}.png
        ;;
esac

# Notificación
notify-send "Captura guardada" "~/Imagenes/captura_${TIMESTAMP}.png"