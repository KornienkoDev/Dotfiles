#!/bin/bash
# swaync volume notification script with dynamic icons
# Adjust step size if you want smaller/larger changes
STEP=5

case "$1" in
  up)
    pamixer -i "$STEP"
    ;;
  down)
    pamixer -d "$STEP"
    ;;
  mute)
    pamixer -t
    ;;
  *)
    echo "Usage: $0 {up|down|mute}"
    exit 1
    ;;
esac

# Get current volume and mute status
vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

# Determine icon and value
if [ "$mute" = "true" ]; then
    icon="󰖁"
    msg=" Muted"
    vol=0
else
    if [ "$vol" -ge 66 ]; then
        icon=""
    elif [ "$vol" -ge 33 ]; then
        icon=""
    else
        icon=""
    fi
    msg=" Volume: ${vol}%"
fi

# Send notification with slider
notify-send \
  -h string:synchronous:volume \
  -h int:value:"$vol" \
  "$icon $msg"
