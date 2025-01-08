#!/usr/bin/env bash
# Original by Dougie modified and edited by Jon Eskdale 2019-01-26
# Run program to dim or turn off RPi backlight after a period of time,
# turn on when the touchscreen is touched.
# Best to run this script from /etc/rc.local to start at boot.

#EDIT THIS VALUE to set the period before it will dim
timeout_period=10 # seconds

#EDIT THIS VALUE to set the brightness it dims the display to.
#0-253 0 will be backlight off, 9 is probably the smallest you would use with my test display
min_brightness=10

# Find the device the touchscreen uses.  This can change depending on
# other input devices (keyboard, mouse) are connected at boot time.
for line in $(lsinput); do
        if [[ $line == *"/dev/input"* ]]; then
                word=$(echo $line | tr "/" "\n")
                for dev in $word; do
                        if [[ $dev == "event"* ]]; then
                                break
                        fi
                done
        fi
        if [[ $line == *"FT5406"* ]] ; then
                break
        fi
done
# Use nice as it sucks up CPU.
nice -n 19 /etc/timeout $timeout_period $min_brightness $dev &
