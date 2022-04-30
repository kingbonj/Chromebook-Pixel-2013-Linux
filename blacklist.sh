#!/bin/bash

#############################################################################
#                                                                           #
#   This script will blacklist the cros_ec_lpcs module so that              #
#   it does not interfere with the linux kernel and prevent                 #
#   use of the hardware i.e fan control, backlight etc.                     #
#                                                                           #
#   Tested on Ubuntu derivatives 22.04 LTS on Chromebook Pixel              #
#   2013 - Codename Link (CB001) running MrChromeBox latest firmware.       #
#                                                                           #
#   Please use this at your own risk. It is a simple script that            #
#   adds the embedded chromeos_ec_lpcs to your blacklist.conf and           #
#   updates initramfs to apply the change.                                  #
#                                                                           #
#   To undo the changes use an editior such as nano to remove the entry     #
#   from/etc/modprobe.d/blacklist.conf > run "sudo initramfs -u" and        #
#   reboot.                                                                 #
#                                                                           #
#############################################################################

#   Set working dir to most likely location of blacklist.conf
cd /etc/modprobe.d/

#   Check if blacklist.conf exists
printf "Checking if \e[35mblacklist.conf\e[0m exists...\n"
if [ -e "blacklist.conf" ]; 
then
	printf "File \e[35mblacklist.conf\e[0m exists!"

#   Check if cros_ec_lpcs is already blacklisted
    printf "\nChecking if \e[33mcros_ec_lpcs\e[0m is blacklisted..."
    isInFile=$(cat blacklist.conf | grep -c "cros_ec_lpcs")
    if [ $isInFile -eq 0 ]; 
    then
#   If not blacklisted >
        printf "\nAppending module \e[33mcros_ec_lpcs\e[0m to blacklist configuration file..."
        printf "\ncros_ec_lpcs" >> blacklist.conf
        printf "Done\n"
        printf "Updating initramfs..."
        update-initramfs -u
        printf "Done\n"
        printf "\e[31mYOU WILL NOW NEED TO REBOOT THE SYSTEM FOR CHANGES TO TAKE EFFECT\n"
        printf "Exiting\n"
    else
#   If blacklisted >
        printf "\n\e[33mcros_ec_lpcs\e[0m appears to already be blacklisted!\n"
        printf "Exiting\n"
    fi    
else
#   If blacklist.conf not found > EXIT
	printf "\nFile \e[35mblacklist.conf\e[0m not found!\n"
    printf "You will need to add the \e[33mcros_ec_lpcs\e[0m entry manually to your blacklist.conf\n"
    printf "Exiting\n"
fi
 




