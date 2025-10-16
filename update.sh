#!/bin/bash

# Force-set path to include sbin
PATH="$PATH:/usr/sbin"

# Set environment variables
tempfolder=~/.battery-tmp
binfolder=/usr/local/bin
batteryfolder="$tempfolder/battery"
repo_config_file=$HOME/.battery/repo.conf

if [ -f "$repo_config_file" ]; then
	. "$repo_config_file"
fi

repo_owner=${BATTERY_REPO_OWNER:-actuallymentor}
repo_name=${BATTERY_REPO_NAME:-battery}
repo_branch=${BATTERY_REPO_BRANCH:-main}
mkdir -p $batteryfolder

echo -e "🔋 Starting battery update\n"

# Write battery function as executable

echo "[ 1 ] Downloading latest battery version"
rm -rf $batteryfolder
mkdir -p $batteryfolder
curl -sS -o $batteryfolder/battery.sh "https://raw.githubusercontent.com/$repo_owner/$repo_name/$repo_branch/battery.sh"

echo "[ 2 ] Writing script to $binfolder/battery"
cp $batteryfolder/battery.sh $binfolder/battery
chown $USER $binfolder/battery
chmod 755 $binfolder/battery
chmod u+x $binfolder/battery

echo "[ 3 ] Updating visudo declarations"
sudo $binfolder/battery visudo

# Remove tempfiles
cd
rm -rf $tempfolder
echo "[ 4 ] Removed temporary folder"

echo -e "\n🎉 Battery tool updated.\n"
