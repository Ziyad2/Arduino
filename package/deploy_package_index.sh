#!/bin/bash
#
# This script updates package index hosted on arduino.esp8266.com.
# Normally is run by Travis CI for tagged versions, as a deploy step.

tag=`git describe --tags`

cd $(dirname "$0")

# Decrypt and install SSH private key.
# "encrypted_xxx_key" and "encrypted_xxx_iv" are environment variables
# known to Travis CI builds.
openssl aes-256-cbc -K $encrypted_3f14690ceb9b_key -iv $encrypted_3f14690ceb9b_iv -in arduino-esp8266-travis.enc -out arduino-esp8266-travis -d
eval "$(ssh-agent -s)"
chmod 600 arduino-esp8266-travis
ssh-add arduino-esp8266-travis


ssh_dl_server=arduino.esp8266.com
# scp -r versions/$tag $ssh_dl_server:apps/download_files/download/versions/

oldver=$(ssh $ssh_dl_server "readlink apps/download_files/download/$branch")
newver="versions/$tag"
d=$(date)
msg="$d: changing version of $branch from $oldver to $newver"
echo $msg

# ssh $ssh_dl_server "pushd apps/download_files/download && ln -snf versions/$tag $branch"
