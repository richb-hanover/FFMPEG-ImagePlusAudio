#! /bin/bash
#
# Merge multiple .MTS files into a single .mts file
#   Note: These files are created by Rich's Panasonic HDC-TM80 video camera
# Then add a label and timecode to the video as 720p format
#   
# Usage: 
# 1. Drag the AVCHD file from the SD card to this folder
# 
# Invoke with:
# sh ./TimecodeMTS.sh "Meeting Name" hh:mm:ss

# Get the label text
label="$1"

# Extract hours, minutes, and seconds
IFS=: read -r hours minutes seconds <<< "$2"

# Calculate total seconds
# start_frame=$((hours * 3600 + minutes * 60 + seconds))
start_time="$hours\:$minutes\:$seconds\;00"

echo "***** $label" "$start_frame" "$start_time"

# Get the base filename of ".mp4" files in the current directory
# file_name=$(find . -maxdepth 1 -type f -name "*.mp4" -exec basename {} \;)

# Append ".mov"
outfile="${label}-timecoded.mov"

# Run the ffmpeg command to concatenate all the .MTS files
# cat *.MTS  | ffmpeg  -i pipe: -c:a copy -c:v copy Merged.mts
ffmpeg -i AVCHD/BDMV/STREAM/0000*.MTS -y -c:v copy -c:a copy Merged.mts

# Run the ffmpeg command to read the merged .mts, add a label and timecode and produce a .mov
#   There are lots of fussy options. See the README.md for details
 
ffmpeg -i Merged.mts \
	-s 1280x720 -c:v libx264 -crf 23 -c:a copy \
	-vf "drawtext=text=${label}:               x=100:  y=975: fontsize=48:fontcolor=white: box=1:boxcolor=gray, \
		drawtext=timecode='$start_time': r=30: x=1300: y=975: fontsize=48:fontcolor=white: box=1:boxcolor=gray" \
   	-y \
   	"$outfile"

# # remove the temporary file
rm Merged.mts

# and play royalty-free beep from https://www.soundjay.com/beep-sounds-1.html
afplay ./beep-02.wav
