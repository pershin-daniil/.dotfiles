#!/bin/bash

if [ "$1" == "up" ]; then
	light -S "$(light -G | awk '{ print int(($1 + .72) * 1.4) }')"
fi

if [ "$1" == "down" ]; then
	light -S "$(light -G | awk '{ print int($1 / 1.4) }')"
fi
