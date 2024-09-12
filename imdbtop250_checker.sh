#!/bin/bash
###########################################################
# Alternative IMDB TOP 250 Directory checker by TeRRaDude #
###########################################################
#
# This script comes without any !!! WARRANTY !!! 
# It checks all titles inside the iMBDTOP250 directory,
# and checks if movie directorys are filled or not.
#
# This script is part of;
# - ./imdbtop250_creator.sh
#
# If directory isn't emty it will rename movie dir to iMDB_;
#
# - ../iMDB_001-The_Shawshank_Redemption_(1994)
# - ../iMDB_002-The_Godfather_(1972)
#
# If directory is emty it creats symlink into ./INCOMPLETE 
# dir and once incomplete dir not emty anymore it removes 
# the symlink from incomplete dir and adds the imdbtag.
#
# Optional:
# You can run this add cron like every 24hrs or once a week.
#
# 0 0 * * 0  /glftpd/bin/imdbtop250_checker.sh >/dev/null 2>&1
#
# Modifications: ###########################################
#
# - 1.0 iDMBtop250 Fist inT.directory Checker by TeRRaDude
# - 1.2 iMDBtop250 Corrected listning dir and few first bumps by TeRRaDude
# - 1.3 iDMBtop250 Corrected cd into SymLink first by TeRRaDude
# - 1.4 iDMBtop250 Added config path for glftpd by TeRRaDude
#
version="1.4 Beta" #2024-04-27
#
##########################################################
# CONFIG #################################################
##########################################################

# Config path for glftpd?
glroot="/glftpd/site"

# Where is the iMDBtop250 dir?
parent_directory="/_ARCHiVE/MOViES/X264-1080P/_iMDBTOP250"

# Where is the incomplete dir for the symlinks?
incomplete_directory="/_ARCHiVE/MOViES/X264-1080P/_iMDBTOP250/_iNCOMPLETE"

# Wat tag will be used to mark FILLED directorys?
imdbtag="iMDB_"

######################################
#### DO NOT EDIT BELOW THIS LINE #####
######################################


# Check if the parent directory exists
if [ -d "$glroot/$parent_directory" ]; then
    # Create incomplete directory if it doesn't exist
    mkdir -m777 -p "$glroot/$incomplete_directory"

    # Loop through each directory inside the parent directory
    for directory in "$glroot/$parent_directory"/*; do
        # Skip the incomplete directory itself
        if [ "$directory" == "$glroot/$incomplete_directory" ]; then
            continue
        fi

        # Check if it's a directory
        if [ -d "$directory" ]; then
            # Extract the directory name
            dir_name=$(basename "$directory")
            # Check if the directory is already marked as imdbtag
            if [[ "$dir_name" == $imdbtag* ]]; then
                echo "$directory is already marked as filled"
                continue
            fi
            # Check if the directory is empty
            if [ -z "$(ls -A "$directory")" ]; then
                echo "$directory is empty"
                # Create a symlink in the incomplete directory if it doesn't already exist
                # bud before that we crawl into dir where they symlink needs to be made!!
                cd "$glroot/$incomplete_directory"
            if [ ! -e "$glroot/$incomplete_directory/$dir_name" ]; then
                    #ln -s "$directory" "$glroot/$incomplete_directory/$dir_name" 
                    ln -s "../$dir_name" "$glroot/$incomplete_directory/$dir_name"
                    echo "Created symlink for $dir_name in incomplete directory"
                fi
            else
                # Remove symlink from the incomplete directory if it exists
                if [ -L "$glroot/$incomplete_directory/$dir_name" ]; then
                    rm "$glroot/$incomplete_directory/$dir_name"
                    echo "Removed symlink for $directory from incomplete directory"
                fi
                # Rename the directory
                new_name="$imdbtag$dir_name"
                mv "$directory" "$glroot/$parent_directory/$new_name"
                echo "Renamed $directory to $new_name"
            fi
        fi
    done
else
    echo "Parent directory does not exist"
fi


echo "Directories checked successfully by imdbtop250 directory checker $version"
# EOF
# !!!+++ This Script Comes Without any Support +++!!!
# ./Just enjoy it.

