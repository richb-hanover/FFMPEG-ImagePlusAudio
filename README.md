# Using ffmpeg to massage image, audio, and video

I regularly record public meetings in my town and post them on
[Youtube](https://www.youtube.com/playlist?list=PLhg_eBomuA8iBIXkkRjULVbqunRqsnHWc).
This allows residents who could not attend the meeting in person to see
what occurred. It also supports creation of accurate minutes. 

I like to add a label (consisting of the committee name and date) and a timecode (a running clock showing the current time in the meeting).
I found a free program [Shutter Encoder](https://shutterencoder.com)
that does this. It works well, but has a detailed (very fussy) user interface
that requires a long set of steps for every new video.

Since I only deal with a couple variations of the recordings,
I decided to write scripts that use the `ffmpeg` program directly
to accomplish these repeated, well-defined tasks.

I now move the video/audio files into this directory
and issue a command like the one below, and wait a few minutes.
The resulting video is ready for uploading to Youtube.

```
sh ./AddTimecode.sh "Lyme Committee Meeting-6Feb2024" 09:58:00
```

Here are the notes I use to remind myself how to make the videos using my Mac.
This information and the resulting scripts are also available on my
[github repo](https://github.com/richb-hanover/FFMPEG-ImagePlusAudio).

NB: You may need to install the `ffmpeg` program. Download a pre-built binary 
from [ffmpeg.org](https://ffmpeg.org//download.html#build-mac),
or read more on that site for getting a version for your computer.

## Add image, label, and timecode to an audio track
To convert an audio-only recording into a video suitable for uploading
to Youtube, this script combines a static JPEG photo with an audio track.
The repo contains a photo of the Lyme Town Offices which is used by default.
To use the script:

1. Open the audio _.mp4_ file with QuickTime Player,
and use the Trim (Cmd-T) function to remove the dead air
from the start and end of the recording,
as necessary. Save as _Meeting Name\_ddMMMyyyy.mp4_
2. Move the resulting audio file to this folder and
run this script, where `hh:mm:ss` is the start time of the meeting:

   ```
   sh AddTimestamp.sh "Meeting Name and Date" hh:mm:ss
   ```
   The script looks for a `.mp4` file (and the image of Town Offices)
   to produce an output file named _Meeting Name and Date-timecoded.mov_
3. _Cleanup:_ so they won't interfere with subsequent runs:
  - Remove the original audio file from the folder
  - Move the resulting _...-timecoded.mov_ file to the CompletedFiles folder.
  Discard after they have been uploaded

## Add label and timecode to AVCHD files

A Panasonic HDC-TM80 video camera produces a `AVCHD` meta-file
that contains the video from a recording session.
The files are within the `AVCHD` file, within the `AVCHD/BDMV/STREAM` directory
with filenames `00000.MTS`, `00001.MTS`, etc.

Drag the AVCHD file into this folder and run this script:

```
sh ./TimecodeMTS.sh "Meeting Name and Date" hh:mm:ss
```

The script looks for a file named `AVCHD` and
outputs file named `MeetingName-timecoded.mov`

## Add label and timecode to Zoom video recordings

Sometimes, a meeting is recorded by an
[Owl Camera](https://www.amazon.com/Owl-360-Degree-Conference-Microphone-Automatic/dp/B0B193JVDJ/ref=sr_1_1).
This results in a good video with good audio,
but it's still helpful to display 
the meeting name and timecode at the bottom.

Drag the Zoom file (a .mp4 file) into this folder and run this script:

```
sh ./TimecodeZoom.sh "Meeting Name and Date" hh:mm:ss
```

The script looks for any file with a `.mp4` extension and
outputs file named `MeetingName-timecoded.mov`

------
### Background Information

StackOverflow/SuperUser and similar sites are your friends.

So is ChatGPT. I gave it this initial prompt,
"give me a ffmpeg command to read a .mts file and add a label and a timecode and output a .mov file. Be sure the audio of the .mts file is preserved." and iterated to get the final commands.

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

This is a test
