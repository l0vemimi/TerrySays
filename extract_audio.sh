#!/bin/bash
# extract_audio.sh

VIDEO_FILE="input_video.mp4"
AUDIO_FILE="audio_output.wav"

ffmpeg -i "$VIDEO_FILE" -q:a 0 -map a "$AUDIO_FILE"