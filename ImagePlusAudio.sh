#! /bin/bash
#
# Combine Image and Audio file to produce a mp4 output file
#
# Usage: 
# 1. Place an image file (.jpeg) and audio file (.mp4) in this folder.
# 2. Run the ImageAndAudio.sh script. It will scan for any .jpeg and .mp4 file.
# 3. Result is yyyy-mm-dd-hh-mm.mp4.
#		Be sure to move this file out of the folder before re-running the script
#

# Get the name of ".mp4" files in the current directory
file_name=$(find . -maxdepth 1 -type f -name "*.mp4" -exec basename {} \;)

# Append ".mov"
outfile="Combined-${file_name%.mp4}.mov"

# Run the ffmpeg command to read in the 
ffmpeg -r 1 -loop 1 -y  -i *.jpeg -i "${file_name}" -c:a copy -r 1 -vcodec libx264 -shortest -pix_fmt yuv444p "$outfile"