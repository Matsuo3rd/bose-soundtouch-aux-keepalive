#!/bin/bash
PATH=$PATH:/opt/bin:/usr/bin/:/opt/bin/bash

soundtouch_ip=192.168.0.42
source=$(curl -s http://$soundtouch_ip:8090/now_playing | xmllint --xpath 'string(/nowPlaying/@source)' -)

if [ $source = "AUX" ]
then
        echo SoundTouch mode is AUX: keep-alive
        curl -s -o /dev/null --request POST --header "Content-Type: application/xml" --data '<key state="press" sender="Gabbo">THUMBS_UP</key>' http://$soundtouch_ip:8090/key
elif [ $source = "STANDBY" ]
then
        echo SoundTouch mode is STANDBY: switch to AUX
        curl -s -o /dev/null --request POST --header "Content-Type: application/xml" --data '<ContentItem source="AUX" sourceAccount="AUX"></ContentItem>' http://$soundtouch_ip:8090/select
fi
