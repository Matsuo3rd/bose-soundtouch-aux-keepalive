#!/bin/bash
set -e

CURL=$(which curl) || \
  { echo "$0 missing prereq curl. Fatal error."; exit 1; }
XMLLINT=$(which xmllint) || \
  { echo "$0 missing prereq xmllint. Fatal error."; exit 1; }

if [[ "$1" == "" ]] ; then
  soundtouch_ip=192.168.0.42
else
  soundtouch_ip="$1"
fi

ping -c1 $soundtouch_ip >/dev/null 2>&1 || \
  { echo "SoundTouch not reachable to $soundtouch_ip"; exit 1; }

source=$(${CURL} -s "http://$soundtouch_ip:8090/now_playing" | ${XMLLINT} --xpath 'string(/nowPlaying/@source)' - 2>/dev/null ) || \
  { echo "curl to SoundTouch failed. Device is pingeable. Wrong ip? Fatal Error."; exit 1; }

if [ "${source}" = "AUX" ]
then
  echo SoundTouch mode is AUX: keep-alive
  ${CURL} -s -o /dev/null --request POST --header "Content-Type: application/xml" --data '<key state="press" sender="dummy">THUMBS_UP</key>' "http://$soundtouch_ip:8090/key"
elif [ "${source}" = "STANDBY" ]
then
  echo SoundTouch mode is STANDBY: switch to AUX
  ${CURL} -s -o /dev/null --request POST --header "Content-Type: application/xml" --data '<ContentItem source="AUX" sourceAccount="AUX"></ContentItem>' "http://$soundtouch_ip:8090/select"
fi
