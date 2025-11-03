#!/bin/bash

ACTION="$1"
VALUE="${2:-5}"

get_brightness() {
    current=$(ddcutil getvcp 10 --brief 2>/dev/null | awk -F' ' '{print $4}' || echo "50")
    echo "$current"
}

case "$ACTION" in
    "inc")
        current=$(get_brightness)
        if [[ "$current" =~ ^[0-9]+$ ]]; then
            new_value=$((current + VALUE))
            if [ "$new_value" -gt 100 ]; then new_value=100; fi
            ddcutil setvcp 10 "$new_value" --brief --noverify 2>/dev/null
            notify-send -h "string:x-canonical-private-synchronous:brightness" \
                        -h int:transient:1 \
                        -h "int:value:$new_value" \
                        "󰃠 Brightness: $new_value%"
        fi
        ;;
    "dec")
        current=$(get_brightness)
        if [[ "$current" =~ ^[0-9]+$ ]]; then
            new_value=$((current - VALUE))
            if [ "$new_value" -lt 0 ]; then new_value=0; fi
            ddcutil setvcp 10 "$new_value" --brief --noverify 2>/dev/null
            notify-send -h "string:x-canonical-private-synchronous:brightness" \
                        -h int:transient:1 \
                        -h "int:value:$new_value" \
                        "󰃠 Brightness: $new_value%"
        fi
        ;;
esac