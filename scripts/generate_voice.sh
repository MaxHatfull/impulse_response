#!/bin/bash

# Generate WAV voice lines from text using macOS say command
# Usage: ./scripts/generate_voice.sh "Hello world" [output_name] [voice]
#
# Examples:
#   ./scripts/generate_voice.sh "Welcome aboard"
#   ./scripts/generate_voice.sh "System online" system_online
#   ./scripts/generate_voice.sh "Greetings human" greeting Zarvox
#
# Voices for sci-fi: Samantha (computer), Zarvox (robot), Trinoids (alien), Whisper (creepy)

TEXT="$1"
OUTPUT_NAME="$2"
VOICE="${3:-Samantha}"

OUTPUT_DIR="impulse_response/assets/audio/generated"

if [ -z "$TEXT" ]; then
  echo "Usage: $0 \"text to speak\" [output_name] [voice]"
  echo ""
  echo "Available sci-fi voices:"
  echo "  Samantha  - Clean computer voice (default)"
  echo "  Zarvox    - Robotic/alien"
  echo "  Trinoids  - Alien chorus"
  echo "  Whisper   - Creepy whisper"
  echo "  Fred      - Classic Mac voice"
  exit 1
fi

# Generate output name from text if not provided
if [ -z "$OUTPUT_NAME" ]; then
  OUTPUT_NAME=$(echo "$TEXT" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
fi

mkdir -p "$OUTPUT_DIR"

AIFF_FILE="/tmp/${OUTPUT_NAME}.aiff"
WAV_FILE="${OUTPUT_DIR}/${OUTPUT_NAME}.wav"

echo "Generating: \"$TEXT\""
echo "Voice: $VOICE"
echo "Output: $WAV_FILE"

say -v "$VOICE" -o "$AIFF_FILE" "$TEXT"
afconvert -f WAVE -d LEI16 "$AIFF_FILE" "$WAV_FILE"
rm "$AIFF_FILE"

echo "Done!"
