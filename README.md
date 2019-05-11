# audioRecorder
Simple FFmpeg bash script to record an audio stream to disk for surveillance purposes and capture peak audio intensity

This should work with any audio stream that ffmpeg can handle (i.e. wav, mp3
even video camera streams I guess?). I tested with android phone running
[IPWebcam](https://play.google.com/store/apps/details?id=com.pas.webcam)

I used this to keep a record of how often our dog barked during the day
while no one was home.

Audio is save to timestamped mp3 files each 1 hour long. RMS peak level
over a 5 second frame is saved to a file. I'm using a raspberry pi and
don't want to wear out the SD card, so I'm writing this to shared memory.
change this path as needed for your purpose. I use zabbix to monitor and
record the peek value and trigger an alert when the intensity is too high.

# Requirements
- FFMpeg (sudo apt-get install ffmpeg)
- usable /dev/shm if you want to save peek audio values here
- Plenty of free space such as a USB hard drive. Write rate is about 28MB/hour
