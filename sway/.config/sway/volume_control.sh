#!/bin/bash

if [ "$1" == "up" ]; then
	pactl set-sink-volume @DEFAULT_SINK@ +5%
fi

if [ "$1" == "down" ]; then
	pactl set-sink-volume @DEFAULT_SINK@ -5%
fi
