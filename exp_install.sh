#!/usr/bin/sudo bash

##### this is an experimental playground for installation commands

export _tmp_download_folder="$(dirname $0 | xargs realpath)/installers"
mkdir -p $_tmp_download_folder # create the installers folder if it does not exist

### set the output color commands if not set yet
black=${black:-`tput setaf 0`}
red=${red:-`tput setaf 1`}
green=${green:-`tput setaf 2`}
yellow=${yellow:-`tput setaf 3`}
blue=${blue:-`tput setaf 4`}
magenta=${magenta:-`tput setaf 5`}
cyan=${cyan:-`tput setaf 6`}
white=${white:-`tput setaf 7`}
reset=${reset:-`tput sgr 0`}
