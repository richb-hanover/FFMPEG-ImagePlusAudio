#! /bin/bash
#
# Add a label and timecode to a Zoom recording, then
# output the video as 720p format
#   
# Usage: 
# 1. Drag the Zoom (.mp4) file from the SD card to this folder
# 
# Invoke with:
# sh ./TimecodeZoom.sh "Meeting Name" hh:mm:ss

# Get the label text
label="$1"

# Extract hours, minutes, and seconds
IFS=: read -r hours minutes seconds <<< "$2"

# Tweak the entered time to add ";00" 
start_time="$hours\:$minutes\:$seconds\;00"

# Debug label and start time
# echo "***** $label" "$start_time"

# Append  "-timecoded.mov" to the provided label for the file name
outfile="${label}-timecoded.mov"

# Run the ffmpeg command to read the Zoom .mp4 recording, add a label and timecode and produce a .mov
#   There are lots of fussy options. See the README.md for details
 
ffmpeg -i *.mp4 \
	-s 1280x720 -c:v libx264 -crf 23 -c:a copy \
	-vf "drawtext=text=${label}:               x=50:   y=670: fontsize=48:fontcolor=white: box=1:boxcolor=gray, \
		drawtext=timecode='$start_time': r=30: x=950: y=670: fontsize=48:fontcolor=white: box=1:boxcolor=gray" \
   	-y \
   	"$outfile"

# Play royalty-free beep from https://www.soundjay.com/beep-sounds-1.html to say we're done
afplay ./beep-02.wav

# and distinguish the end of the process in the terminal
echo ""
echo "============ Completed: ${label}"
echo ""
