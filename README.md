# bose-soundtouch-aux-keepalive
Prevents Bose SoundTouch speakers to automatically switch off after 20 minutes of inactivity (Auto-Off feature) when using AUX source.

## Description

Keeps Bose SoundTouch speakers always-on when using AUX source by sending notifications every 15 minutes (cron) and do the following:
* If the SoundTouch is On and the source is set to AUX (auxiliary), sends a "dummy" Thumbs-Up notification to fool the Auto-Off features
* If the SoundTouch is Off (stand-by), switches on the SoundTouch and set it to AUX source.

## Why?

My Bose SoundTouch is wired (AUX) to my computer but unfortunately the speaker automatically switches off after a period of 20 minutes of inactivity. This is a problem for me and others who are using their SoundTouch alongside smarthome devices (Alexa and co); the speaker must be on continuously.

Bose have produced a firmware which can turn off auto-off features, but this is only available for BLUETOOTH source (not AUX).

I have tried different workarounds but to no avail:
* Playing "silent" sound every 15 minutes with [MacOS Audio Keep Alive](http://milgra.com/macos-audio-keepalive.html)
* [Telnet the SoundTouch to disable the auto-off feature](https://ntotten.com/2017/01/19/disable-auto-shutoff-on-bose-soundtouch/)

I have eventually been successful with this script wich leverages Bose SoundTouch APIs. Basically, it fools the SoundTouch auto-off feature by sending a "dummy" (yet not intrusive) notification every 15 minutes. You can define the time window of the script's execution through a CRON expression. I personnaly set it from 8am to 10pm so that the SoundTouch speaker is automatically switched on at 8am, stays alive until 10pm and then goes into standby mode afterward (except if you are currently listening sound from it).

## Prerequisites

* Bose SoundTouch speaker (this has been tested with a SoundTouch 10 and SoundTouch Wireless Link adapter. but shall works with other models)
* Always-on Linux/Mac/Raspberry Pi computer which periodically executes a shell script (curl and xmllint are required)

## Installation

1. Download `bose-soundtouch-aux-keepalive.sh` to your always-on Linux or Mac computer
2. Call the script using as first argument the fqdn or ip of your SoundTouch's network IP or define the `soundtouch_ip` variable in the script (line 10, mine is `192.168.0.42` you shall replace it accordingly)
3. Define a [crontab](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/) (or any scheduling system) which executes the script every 15 minutes (e.g.  `0/15 8-21 * * *`)
