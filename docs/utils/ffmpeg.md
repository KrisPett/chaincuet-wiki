### Install ffmpeg on Windows

https://github.com/BtbN/FFmpeg-Builds/releases

- download ffmpeg-N-117304-g358fdf3083-win64-gpl.zip
- copy ffmpeg.exe ffplay.exe ffprobe.exe --> C:\ffmpeg
- Edit env --> Add Path C:\ffmpeg


### Convert mkv to mp4

```
ffmpeg -i "1 Introduktion till Versionshantering.mkv" -c:v copy -c:a copy "1 Introduktion till Versionshantering.mp4"
```