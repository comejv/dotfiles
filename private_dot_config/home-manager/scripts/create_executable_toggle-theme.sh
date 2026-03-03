#!/usr/bin/env bash

# Robustly find DBUS_SESSION_BUS_ADDRESS if not set
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
fi

set_theme() {
    local mode=$1
    if [ "$mode" = "light" ]; then
        echo "Setting light mode..."
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    else
        echo "Setting dark mode..."
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    fi
}

toggle_theme() {
    current=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$current" == *'prefer-dark'* ]]; then
        set_theme "light"
    else
        set_theme "dark"
    fi
}

case "$1" in
    light)
        set_theme "light"
        ;;
    dark)
        set_theme "dark"
        ;;
    toggle)
        toggle_theme
        ;;
    *)
        # Default auto behavior based on current hour if no arg provided
        hour=$(date +%H)
        if [ "$hour" -ge 8 ] && [ "$hour" -lt 18 ]; then
            set_theme "light"
        else
            set_theme "dark"
        fi
        ;;
esac
