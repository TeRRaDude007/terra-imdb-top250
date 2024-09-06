#!/bin/bash
###########################################################
# Alternative IMDB TOP 250 Directory creator by TeRRaDude #
###########################################################
#
# This script comes without any !!! WARRANTY !!!
# It will creat all titles from IMDb Top 250 page,.
# into a directorty of your choice eg;
#
# ../001-The_Shawshank_Redemption_(1994)
# ../002-The_Godfather_(1972)
#
# Keep in mind that iMBD Top 250 can change overtime.
# So only Run this script once then!!
#
# To check incomplete or filled directory's use;
#  - ./imdbtop250_checker.sh
#
# Modifications:
# - 1.0 Alternative: IDMB top 250 directory creator by TeRRaDude
# - 1.1 Recode / Fixed URL Modified by TeqnoDude
# - 1.2 Added glroot and section path configure by TeRRaDude
# - 1.3 Added corrected -m777 maindir by TeqnoDude 
# - 1.4 Added corrected -m777 subdirs by TeqnoDude
# - 1.5 Fixing &amp`s charts removed by TeqnoDude
# - 1.6 Fixing correct replacements charts by TeqnoDude
#
version="1.6 Beta" #2024-04-27
#
###########################################################

## Config glftp and section path

glroot="/glftpd/site"
section="MOViES/X264"

## What dir contains all 250 movies

imdbtopdir="_iMDBTOP250"

######################################
#### DO NOT EDIT BELOW THIS LINE #####
######################################

movie_info=`curl -s "https://250.took.nl/lists/top-250-without-india" | grep -o "<a.*>.*</a>" | grep -o "title=\".*([0-9][0-9][0-9][0-9])" | sed 's/title="//g; /hidden-sm/d; s/&amp;egrave;/e/g; s/&amp;eacute;/e/g; s/&amp;ocirc;/o/g; s/&amp;middot;/-/g; s/&amp;#xE9;/e/g; s/&amp;ugrave;/u/g; s/&amp;auml;/a/g; s/ü/u/g;' | sed "s/&#039;//g; s/&#00E8;//g; s/&amp;#x27;//g; s/[;:,.]//g; s/ /_/g;"`

# Check if extraction was successful
if [ -z "$movie_info" ]; then
    echo "Failed to extract movie titles and years."
    exit 1
fi

# Debug: Print extracted movie titles and years
echo "Movie Titles and Years:"
echo "$movie_info"

# Create directory if it doesn't exist
directory="$glroot/$section/$imdbtopdir"
mkdir -m777 -p "$directory"

# Loop through each movie and create directory
counter=1
while IFS= read -r movie; do
    padded_counter=$(printf "%03d" $counter)
    directory_name="${padded_counter}-${movie}"
    mkdir -m777 -p "$directory/$directory_name"
    ((counter++))
done <<< "$movie_info"

echo "Directories created successfully by imdbtop250 directory creator $version"
