#! /bin/bash
#
# Combine Image and Audio file to produce a .mov output file
#
# Usage: 
# 1. Place an image file (.jpeg) and audio file (.mp4) in this folder.
# 2. Run the ImageAndAudio.sh script. It will scan for a .jpeg file and a .mp4 file.
# 3. Result is a .mov file with "Combined-" plus the same name as the .mp4 file
# 4. Discard/Move the source .mp4 file out of the directory
# 5. Move the .mov file to OutputFiles for safe keeping or later processing
#

# Get the base filename of ".mp4" files in the current directory
file_name=$(find . -maxdepth 1 -type f -name "*.mp4" -exec basename {} \;)

# Append ".mov"
outfile="Combined-${file_name%.mp4}.mov"

# Run the ffmpeg command to read the two files and produce a .mov
#   There are lots of fussy options. See the README.md for details
ffmpeg -r 1 -loop 1 -y  -i *.jpeg -i "${file_name}" -c:a copy -r 1 -vcodec libx264 -shortest -pix_fmt yuv444p "$outfile"
