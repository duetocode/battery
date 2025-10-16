#!/bin/bash

# User welcome message
echo -e "\n####################################################################"
echo '# 👋 Welcome, this is the setup script for the battery CLI tool.'
echo -e "# Note: this script will ask for your password once or multiple times."
echo -e "####################################################################\n\n"

# Set environment variables
tempfolder=~/.battery-tmp
binfolder=/usr/local/bin
mkdir -p $tempfolder

# Set script value
calling_user=${1:-"$USER"}
configfolder=/Users/$calling_user/.battery
repo_config_file=$configfolder/repo.conf

if [ -f "$repo_config_file" ]; then
	. "$repo_config_file"
fi

repo_owner=${BATTERY_REPO_OWNER:-actuallymentor}
repo_name=${BATTERY_REPO_NAME:-battery}
update_branch=${BATTERY_REPO_BRANCH:-main}
archive_branch_name=${update_branch//\//-}
pidfile=$configfolder/battery.pid
logfile=$configfolder/battery.log

# Ask for sudo once, in most systems this will cache the permissions for a bit
sudo echo "🔋 Starting battery installation"
echo -e "[ 1 ] Superuser permissions acquired."

# Note: github names zips by <reponame>-<branchname>.replace( '/', '-' )
in_zip_folder_name="$repo_name-$archive_branch_name"
batteryfolder="$tempfolder/battery"
echo "[ 2 ] Downloading latest version of battery CLI"
rm -rf $batteryfolder
mkdir -p $batteryfolder
curl -sSL -o $batteryfolder/repo.zip "https://github.com/$repo_owner/$repo_name/archive/refs/heads/$update_branch.zip"
unzip -qq $batteryfolder/repo.zip -d $batteryfolder
cp -r $batteryfolder/$in_zip_folder_name/* $batteryfolder
rm $batteryfolder/repo.zip

# Move built file to bin folder
echo "[ 3 ] Move smc to executable folder"
sudo mkdir -p $binfolder
sudo cp $batteryfolder/dist/smc $binfolder
sudo chown $calling_user $binfolder/smc
sudo chmod 755 $binfolder/smc
sudo chmod +x $binfolder/smc

echo "[ 4 ] Writing script to $binfolder/battery for user $calling_user"
sudo cp $batteryfolder/battery.sh $binfolder/battery

echo "[ 5 ] Setting correct file permissions for $calling_user"
# Set permissions for battery executables
sudo chown -R $calling_user $binfolder/battery
sudo chmod 755 $binfolder/battery
sudo chmod +x $binfolder/battery

# Set permissions for logfiles
mkdir -p $configfolder
sudo chown -R $calling_user $configfolder

touch $logfile
sudo chown $calling_user $logfile
sudo chmod 755 $logfile

touch $pidfile
sudo chown $calling_user $pidfile
sudo chmod 755 $pidfile

sudo chown $calling_user $binfolder/battery

echo "[ 6 ] Setting up visudo declarations"
sudo $batteryfolder/battery.sh visudo $USER
sudo chown -R $calling_user $configfolder

cat <<EOF > $repo_config_file
BATTERY_REPO_OWNER=$repo_owner
BATTERY_REPO_NAME=$repo_name
BATTERY_REPO_BRANCH=$update_branch
EOF
chmod 600 $repo_config_file

# Remove tempfiles
cd ../..
echo "[ 7 ] Removing temp folder $tempfolder"
rm -rf $tempfolder

echo -e "\n🎉 Battery tool installed. Type \"battery help\" for instructions.\n"
