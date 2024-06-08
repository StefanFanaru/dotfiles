#!/bin/bash

i3status | while :; do
	read line
	if [ "$line" == '{"version":1}' ] || [ "$line" == "[" ]; then
		echo "$line" || exit 1
	else
		bt_power=$(/home/stefanaru/dotfiles/scripts/workflow/check-bt-battery.sh "JBL LIVE PRO 2 TWS")
		# if bt_power does not contain % set BTPW to empty string
		if [[ ! $bt_power == *%* ]]; then
			BTPW=""
		else
			BTPW="{\"name\":\"bluetooth_power\",\"full_text\":\"󰂯 $bt_power \"},"
		fi
		MUSIC=""
		echo "[$MUSIC$BTPW${line#*[}," || exit 1
	fi
done
