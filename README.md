# Using ffmpeg to massage image, audio, and video

Instead of wrestling with [Shutter Encoder](https://shutterencoder.com),
I decided to go straight to the `ffmpeg` program to accomplish
certain repeated, well-defined tasks.

## Add image, label, and timecode to an audio track
Combines a photo of the Lyme Town Offices with an audio track
from a meeting recording. 

1. Open the audio _.mp4_ file with QuickTime Player,
and use the Trim (Cmd-T) function to remove the dead air
from the start and end of the recording,
as necessary. Save as _Meeting Name\_ddMMMyyyy.mp4_
2. Drag the resulting audio file to this folder and
run this script, where `hh:mm:ss` is the start time of the meeting:

   ```
   sh AddTimestamp.sh "Meeting Name and Date" hh:mm:ss
   ```
   The script looks for a `.mp4` file (and the image of Town Offices)
   to produce an output file named _Meeting Name and Date-timecoded.mov_
3. _Cleanup:_ so they won't confuse us next time.
  - Remove the original audio file from the folder
  - Move the resulting _...-timecoded.mov_ file to the OutputFiles folder.
  Discard after they have been uploaded

## Add label and timecode to Panasonic camera files

The Panasonic HDC-TM80 video camera produces a `AVCHD` meta-file
that contains the video in a set of `.MTS` files
for any recording session.
These have the filenames `0000.MTS`, `0001.MTS`, etc.

Drag the AVCHD file into this folder and run this script:

```
sh ./TimecodeMTS.sh "Meeting Name and Date" hh:mm:ss
```

The output is a file named `MeetingName-timecoded.mov`

## Add label and timecode to Zoom video recordings

This follows the format of the TimecodeMTS.sh options
(no need to merge `.MTS` files) but places the
label and timecode just below the full-view.
Needs to be adjusted for the different screen size...

... to come...

## Obsolete Information

This was preliminary work that has been folded into the scripts above.

### Shutter Encoder settings 

For the Town Office image, labels should both be 30%, and placed at:

* Timecode X/Y: 700/570
* Label X/Y: 100/570
* Font size: 30%

### Experiments with `ffmpeg`
From: [https://superuser.com/questions/1041816/combine-one-image-one-audio-file-to-make-one-video-using-ffmpeg](https://superuser.com/questions/1041816/combine-one-image-one-audio-file-to-make-one-video-using-ffmpeg)

1.  Accepted answer:
`ffmpeg -loop 1 -i image.jpg -i audio.wav -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest out.mp4`

   > ffmpeg -loop 1 -i Lyme-Town-Hall-Offices-cropped-1024.jpeg -i SB-20231130.mp4 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest 11Nov2023-first.mp4
   
   Takes a while to encode

2. PJBrunet and Kokizzu:
` ffmpeg -r 1 -loop 1 -y -i 1.jpg -i 1.m4a -c:a copy -r 1 -vcodec libx264 -shortest 1.avi`

   > time ffmpeg -r 1 -loop 1 -y -i Lyme-Town-Hall-Offices-cropped-1024.jpeg -i SB-20231130.mp4 -c:a copy -r 1 -vcodec libx264 -shortest 11Nov2023-second.mp4

   ~5 seconds; result 18.6mbytes.
   Creates file that cannot be opened by QuickTime Player

3. Same as #2 with image that has odd number of pixels

   > ffmpeg -r 1 -loop 1 -y -i Lyme-Town-Hall-Offices-cropped-1024-1.jpeg -i SB-20231130.mp4 -c:a copy -r 1 -vcodec libx264 -shortest 11Nov2023-three.mp4

   **Blows big chunks** with "odd dimensions" error

4. Same as #2 with odd number of pixels, using `-pix_fmt yuv444p` right before name of output file.

   > time ffmpeg -r 1 -loop 1 -y  -i Lyme-Town-Hall-Offices-cropped-1024-1.jpeg -i SB-20231130.mp4 -c:a copy -r 1 -vcodec libx264 -shortest -pix_fmt yuv444p 11Nov2023-four.mp4
   
   Fast (takes 5-10seconds). Creates file that cannot be opened by QuickTime Player
   
   But this file can be run through normal Shutter Encoder procedure to add text and time code. This produces a file that works in QT Player and works on Youtube.

5. ~~Using #4 above, video fadein is slow (one frame per second?) Increase loop to make it faster?...~~

   > ~~time ffmpeg -r 2 -loop 1 -y  -i Lyme-Town-Hall-Offices-cropped-1024-1.jpeg -i SB-20231130.mp4 -c:a copy -r 1 -vcodec libx264 -shortest -pix_fmt yuv444p 11Nov2023-seven.mp4~~
   
   Blows big chunks with some kind of parameter error...


