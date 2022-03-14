#!/bin/bash
# deploys to cbmministry site as hugo simply generates static files, we still need to copy to webserver
# use "./deploy.sh y" to skip confirmation

hugo_exists=$(which hugo)
if [[ -z $hugo_exists ]]; then
    echo 'Please have hugo installed: https://gohugo.io/'
    exit 1
fi

# for scripts to skip confirmation
sync_immediately=$1

# Clean the public folder before rebuild - not sure why needed but issues on some machine
rm -rf ./public/*

echo "Generating hugo site"
hugo

# Uploading generated site to
cd ../
# open hugo/public/index.html # On mac, launch browser to check

if [[ $sync_immediately != "y" ]]; then
    # Confirm whether to perform sync now
    read -p "Would you like to run the above rsync now (y/n)? " -n 1 -r
    echo # (optional) move to a new line
fi

if [[ $REPLY =~ ^[Yy]$ || $sync_immediately == "y" ]]; then
    rsync -avz hugo/public/ aonemak1@a1make.net:www/cbmministry/events/gospel/2022/2022-03-26/hugo/
fi
# DONE!
