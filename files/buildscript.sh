#!/bin/sh

#Placing terminal to the starting folder
cd /root/

#Clone the lhos repo
git clone https://github.com/aurumfoundation/aurum-os-standard

#Go to this new working folder
cd $(ls|grep -Ev 'buildscript.sh')

#Run the script to build the ISO
./build.sh -v

#Move the final ISO to /tmp to be accessible from the host
mv out/*.iso /tmp
