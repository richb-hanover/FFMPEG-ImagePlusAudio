#! /bin/bash
#
# Merge multiple .MTS files into a single .mts file
#   Note: These files are created by Rich's Panasonic HDC-TM80 video camera
#   
# Usage: 
# 1. Drag the AVCHD file from the SD card to the Downloads folder
# 2. If necessary, Show Package Contents to reveal the BDMV file
# 3. Show Package Contents on the BDMV file
# 4. This reveals the STREAM folder, containing files named 0000.MTS, 0001.MTS, etc 
# 5. Drag those files to this folder (making copies of the files)
# 6. Run `sh ./MergeMTS.sh` to produce "Merged.mts"
#
# Invoke with:
# sh ./TimestampMTS.sh "Meeting Name" 01:23:45

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
outfile="${label}-timestamped.mov"

# Run the ffmpeg command to concatenate all the .MTS files
cat *.MTS  | ffmpeg  -i pipe: -c:a copy -c:v copy Merged.mts
# ffmpeg -f concat -safe 0 -i "concat:$(cat *.MTS)" -c copy Merged.mts

# Run the ffmpeg command to read the merged .mts, add a label and timecode and produce a .mov
#   There are lots of fussy options. See the README.md for details
 
ffmpeg -i Merged.mts \
	-c:v prores -profile:v 2 -c:a copy \
	-vf "drawtext=text=${label}:               x=100:  y=975: fontsize=36:fontcolor=white: box=1:boxcolor=gray, \
		drawtext=timecode='$start_time': r=30: x=1000: y=975: fontsize=36:fontcolor=white: box=1:boxcolor=gray" \
   	-an \
   	-y \
   	"$outfile"

# # remove the temporary file
rm Merged.mts

# and play royalty-free beep from https://www.soundjay.com/beep-sounds-1.html
afplay ./beep-02.wav


# ffmpeg \
# 	-r 1 \
# 	-loop 1 \
# 	-y  \
# 	-i *.jpeg \
# 	-i "${file_name}" \
# 	-c:a copy \
# 	-r 1 \
# 	-vcodec libx264 \
# 	-shortest \
# 	-pix_fmt yuv444p \
# 	-vf "drawtext=text=${label}:x=100:y=580:fontsize=24:fontsize=36:fontcolor=white: box=1:boxcolor=gray, \
# 		drawtext=timecode='$start_time': r=30: x=700: y=580: fontsize=36:fontcolor=white: box=1:boxcolor=gray" \
# 	"$outfile"

	# -vf "drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: timecode='09\:57\:00\;00': r=30: \
   	# 	x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" \

# From https://trac.ffmpeg.org/wiki/FilteringGuide#BurntinTimecode
# ffmpeg -i in.mp4 -vf "drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: timecode='09\:57\:00\;00': r=30: \
#    x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" -an -y out.mp4
