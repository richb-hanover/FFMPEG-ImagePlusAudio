#! /bin/bash
#
# Combine Image and Audio file, add a timecode and produce a .mov output file
#
# Usage: 
# 1. Place an image file (.jpeg) and audio file (.mp4) in this folder.
# 2. Run the ImageAndAudio.sh script. It will scan for a .jpeg file and a .mp4 file.
# 3. Result is a .mov file with "Combined-" plus the same name as the .mp4 file
# 4. Discard/Move the source .mp4 file out of the directory
# 5. Move the .mov file to CompletedFiles for safe keeping or later processing
#
# Invoke with:
# sh ./AddTimecode.sh "Lyme Select Board-6Feb2024" 09:58:00

# Get the label text
label="$1"

# Extract hours, minutes, and seconds
IFS=: read -r hours minutes seconds <<< "$2"

# Calculate total seconds
# start_frame=$((hours * 3600 + minutes * 60 + seconds))
start_time="$hours\:$minutes\:$seconds\;00"

echo "***** $label" "$start_frame" "$start_time"

# Get the base filename of ".mp4" files in the current directory
file_name=$(find . -maxdepth 1 -type f -name "*.mp4" -exec basename {} \;)

# Append  "-timecoded.mov" to the provided label for the file name
outfile="${label}-timecoded.mov"

# Run the ffmpeg command to read the two files and produce a .mov
#   There are lots of fussy options. See the README.md for details
ffmpeg \
	-r 1 \
	-loop 1 \
	-y  \
	-i *.jpeg \
	-i "${file_name}" \
	-c:a copy \
	-r 1 \
	-vcodec libx264 \
	-shortest \
	-pix_fmt yuv444p \
	-vf "drawtext=text=${label}:x=100:y=580:fontsize=24:fontsize=36:fontcolor=white: box=1:boxcolor=gray, \
		drawtext=timecode='$start_time': r=30: x=700: y=580: fontsize=36:fontcolor=white: box=1:boxcolor=gray" \
	"$outfile"

# Play royalty-free beep from https://www.soundjay.com/beep-sounds-1.html to say we're done
afplay ./beep-02.wav

# and distinguish the end of the process in the terminal
echo ""
echo "============ Completed: ${label}"
echo ""

