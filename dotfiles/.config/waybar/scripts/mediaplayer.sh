#!/usr/bin/env bash
status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

if [ -z "$status" ]; then
    echo '{"text": "🎵", "class": "stopped", "tooltip": "Sin reproducción"}'
    exit 0
fi

case $status in
    Playing) icon="▶️" ; class="playing" ;;
    Paused)  icon="⏸️" ; class="paused" ;;
    *)       icon="🎵" ; class="stopped" ;;
esac

# Escapar comillas dobles
title=${title//\"/\\\"}
artist=${artist//\"/\\\"}

echo "{\"text\": \"$icon\", \"class\": \"$class\", \"tooltip\": \"$title - $artist\"}"
