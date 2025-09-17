#!/usr/bin/env fish
# Charge once to a target percentage, then restore thresholds.
# Requires: tpacpi-bat, thinkpad_acpi battery control enabled.
# Usage: charge-once.fish [TARGET]
#   TARGET default: 90

function usage
    echo "Usage: charge-once.fish [TARGET]"
    echo "  TARGET default: 90 (valid: 1-100)"
end

# --- Parse args ---
set -l TARGET ""
if test (count $argv) -gt 0
    if string match -rq '^[0-9]+$' -- $argv[1]
        set TARGET $argv[1]
    else
        echo "Error: TARGET must be an integer."
        usage
        exit 2
    end
end
if test -z "$TARGET"
    set TARGET 90
end
if test $TARGET -lt 1 -o $TARGET -gt 100
    echo "Error: TARGET must be between 1 and 100."
    exit 2
end

# --- Preflight checks ---
if not command -v tpacpi-bat >/dev/null 2>&1
    echo "Error: tpacpi-bat not found. Install it and ensure thinkpad_acpi threshold control is enabled."
    exit 1
end

# Choose battery: /sys uses BAT0/BAT1, tpacpi-bat uses 1/2
set -l SYS_BAT 0
set -l TPACPI_BAT 1
if not test -e /sys/class/power_supply/BAT$SYS_BAT
    if test -e /sys/class/power_supply/BAT1
        set SYS_BAT 1
        set TPACPI_BAT 2
    else
        echo "Error: No /sys/class/power_supply/BAT0 or BAT1 found."
        exit 1
    end
end

# Poll interval and timeout
set -l POLL_SECS 30
set -l MAX_WAIT_SECS 7200  # 2 hours
set -l waited 0

function capacity_for --argument-names id
    if test -r /sys/class/power_supply/BAT$id/capacity
        cat /sys/class/power_supply/BAT$id/capacity
    end
end

function status_for --argument-names id
    if test -r /sys/class/power_supply/BAT$id/status
        cat /sys/class/power_supply/BAT$id/status
    end
end

# Save current thresholds if available; fall back to defaults
set -g SAVED_START 75
set -g SAVED_STOP 80
set -g TPACPI_BAT_GLOBAL $TPACPI_BAT
set -g SYS_BAT_GLOBAL $SYS_BAT
set -g THRESHOLDS_CHANGED 0

# tpacpi-bat -g ST/SP uses battery numbers 1/2, not 0/1
set -l cur_start (tpacpi-bat -g ST $TPACPI_BAT 2>/dev/null | string match -rg 'threshold = ([0-9]+)')
set -l cur_stop  (tpacpi-bat -g SP $TPACPI_BAT 2>/dev/null | string match -rg 'threshold = ([0-9]+)')
if string match -rq '^[0-9]+$' -- $cur_start
    set SAVED_START $cur_start
end
if string match -rq '^[0-9]+$' -- $cur_stop
    set SAVED_STOP $cur_stop
end

echo "Current thresholds: start=$SAVED_START stop=$SAVED_STOP"

# Function to restore thresholds
function restore_thresholds
    if test $THRESHOLDS_CHANGED -eq 1
        echo ""
        echo "Restoring thresholds (start=$SAVED_START stop=$SAVED_STOP)..."
        sudo tpacpi-bat -s ST $TPACPI_BAT_GLOBAL $SAVED_START 2>/dev/null
        or echo "Warning: failed to restore start threshold"
        sudo tpacpi-bat -s SP $TPACPI_BAT_GLOBAL $SAVED_STOP 2>/dev/null
        or echo "Warning: failed to restore stop threshold"
        echo "Thresholds restored."
    end
end

# Set up signal handlers to restore thresholds on interruption
function cleanup --on-signal SIGINT --on-signal SIGTERM
    restore_thresholds
    exit 130
end

# Get current capacity
set -l cap (capacity_for $SYS_BAT)
if test -z "$cap"
    echo "Cannot read capacity for BAT$SYS_BAT"
    exit 1
end

# If already at or above target, just restore and exit
if test $cap -ge $TARGET
    echo "BAT$SYS_BAT already at $cap% (target: $TARGET%). Nothing to do."
    exit 0
end

# Set one-time thresholds so charging begins now and stops at TARGET
# Start threshold slightly above current capacity (max 99)
set -l one_start (math "min($cap + 1, 99)")
echo "BAT$SYS_BAT: setting one-time start=$one_start stop=$TARGET"
if not sudo tpacpi-bat -s sp $TPACPI_BAT $TARGET
    echo "Error: failed to set stop threshold on battery $TPACPI_BAT"
    exit 1
end
sleep 0.5
if not sudo tpacpi-bat -s st $TPACPI_BAT $one_start
    echo "Error: failed to set start threshold on battery $TPACPI_BAT"
    exit 1
end

# Mark that we've changed thresholds
set THRESHOLDS_CHANGED 1

# Wait until target reached or charging stops/timeout
echo "Charging once to $TARGET%... (Ctrl+C to interrupt and restore thresholds)"
while true
    set -l cap (capacity_for $SYS_BAT)
    set -l stat (status_for $SYS_BAT)

    if test -z "$cap" -o -z "$stat"
        echo "Warning: unable to read battery state; continuing..."
    else
        echo "BAT$SYS_BAT: status=$stat capacity=$cap%"
    end

    if test -n "$cap"
        if test $cap -ge $TARGET
            echo "Target reached."
            break
        end
    end

    # Only exit if actually discharging (on battery) or full
    if test -n "$stat"
        if test "$stat" = "Discharging" -o "$stat" = "Full"
            echo "Discharging (likely on battery) or Full; stopping wait."
            break
        end
    end

    if test $waited -ge $MAX_WAIT_SECS
        echo "Timeout after $MAX_WAIT_SECS seconds."
        break
    end

    sleep $POLL_SECS
    set waited (math $waited + $POLL_SECS)
end

# Restore thresholds
restore_thresholds
echo "Done."
