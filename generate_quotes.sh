#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Directory containing video files
VIDEO_DIR="$SCRIPT_DIR/videos"
AUDIO_DIR="$SCRIPT_DIR/audio"
TRANSCRIPTION_DIR="$SCRIPT_DIR/transcriptions"
QUOTES_DIR="$SCRIPT_DIR/quotes"

# Create directories if they don't exist
mkdir -p "$AUDIO_DIR" "$TRANSCRIPTION_DIR" "$QUOTES_DIR"

# Process each video file in the directory
for VIDEO_FILE in "$VIDEO_DIR"/*.mp4; do
	BASENAME=$(basename "$VIDEO_FILE" .mp4)
	AUDIO_FILE="$AUDIO_DIR/${BASENAME}.wav"
	TRANSCRIPTION_FILE="$TRANSCRIPTION_DIR/${BASENAME}.txt"
	QUOTES_FILE="$QUOTES_DIR/${BASENAME}.txt"

	# Step 1: Extract audio from video
	ffmpeg -i "$VIDEO_FILE" -q:a 0 -map a "$AUDIO_FILE"
	if [ $? -ne 0 ]; then
		echo "Error extracting audio from video $VIDEO_FILE. Skipping..."
		continue
	fi

	# Step 2: Convert speech to text
	python3 "$SCRIPT_DIR/speech_to_text.py" "$AUDIO_FILE" "$TRANSCRIPTION_FILE"
	if [ $? -ne 0 ]; then
		echo "Error converting speech to text for $AUDIO_FILE. Skipping..."
		continue
	fi

	# Step 3: Extract quotes from text
	python3 "$SCRIPT_DIR/extract_quotes.py" "$TRANSCRIPTION_FILE" "$QUOTES_FILE"
	if [ $? -ne 0 ]; then
		echo "Error extracting quotes from text for $TRANSCRIPTION_FILE. Skipping..."
		continue
	fi

	# Output the resulting quotes
	if [ -f "$QUOTES_FILE" ]; then
		echo "Quotes extracted from the video $VIDEO_FILE:"
		cat "$QUOTES_FILE"
	else
		echo "No quotes found for $VIDEO_FILE."
	fi
done