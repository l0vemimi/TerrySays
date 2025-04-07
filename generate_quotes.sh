#!/bin/bash

# Directory containing video files
VIDEO_DIR="videos"
AUDIO_DIR="audio"
TRANSCRIPTION_DIR="transcriptions"
QUOTES_DIR="quotes"

# Create directories if they don't exist
mkdir -p "$AUDIO_DIR" "$TRANSCRIPTION_DIR" "$QUOTES_DIR"

# Print Python version and path
echo "Using Python version:"
python --version

echo "Python path:"
python -c "import sys; print(sys.path)"

# Activate virtual environment (if any)
source venv/bin/activate  # Adjust the path if your virtual environment is located elsewhere

# Process each video file in the directory
for VIDEO_FILE in "$VIDEO_DIR"/*.mp4; do
	BASENAME=$(basename "$VIDEO_FILE" .mp4)
	AUDIO_FILE="$AUDIO_DIR/${BASENAME}.wav"
	TRANSCRIPTION_FILE="$TRANSCRIPTION_DIR/${BASENAME}.txt"
	QUOTES_FILE="$QUOTES_DIR/${BASENAME}.txt"

	echo "Processing video file: $VIDEO_FILE"

	# Step 1: Extract audio from video
	ffmpeg -i "$VIDEO_FILE" -q:a 0 -map a "$AUDIO_FILE"
	if [ $? -ne 0 ]; then
		echo "Error extracting audio from video $VIDEO_FILE. Skipping..."
		continue
	fi
	echo "Audio extracted to: $AUDIO_FILE"

	# Step 2: Convert speech to text
	python3 speech_to_text.py "$AUDIO_FILE" "$TRANSCRIPTION_FILE"
	if [ $? -ne 0 ]; then
		echo "Error converting speech to text for $AUDIO_FILE. Skipping..."
		continue
	fi
	echo "Transcription written to: $TRANSCRIPTION_FILE"

	# Step 3: Extract quotes from text
	python3 extract_quotes.py "$TRANSCRIPTION_FILE" "$QUOTES_FILE"
	if [ $? -ne 0 ]; then
		echo "Error extracting quotes from text for $TRANSCRIPTION_FILE. Skipping..."
		continue
	fi
	echo "Quotes written to: $QUOTES_FILE"

	# Output the resulting quotes
	if [ -f "$QUOTES_FILE" ]; then
		echo "Quotes extracted from the video $VIDEO_FILE:"
		cat "$QUOTES_FILE"
	else
		echo "No quotes found for $VIDEO_FILE."
	fi
done