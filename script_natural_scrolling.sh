#!/bin/sh
# Switch the scrolling direction for touchpad
export touchpadid=`xinput list | grep -i touchpad | awk -F"=" '{ print $2 }'| awk '{ print $1 }'`
export propid=`xinput list-props "${touchpadid}" | grep -i "Natural Scrolling Enabled" | grep -vi "default" | awk -F"(" '{ print $2 }' | awk -F")" '{ print $1 }'`
xinput set-prop "${touchpadid}" "${propid}" 0
