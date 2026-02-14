#!/bin/bash

# Generate WAV voice lines from text using Piper TTS
# Usage: ./scripts/generate_voice_piper.sh "Hello world" [output_name]
#
# Examples:
#   ./scripts/generate_voice_piper.sh "Welcome aboard"
#   ./scripts/generate_voice_piper.sh "System online" system_online
#
# Install piper first: brew install piper
# Download a model: https://github.com/rhasspy/piper/blob/master/VOICES.md

TEXT="$1"
OUTPUT_NAME="$2"
MODEL="${PIPER_MODEL:-en_US-ryan-high}"

OUTPUT_DIR="impulse_response/assets/audio/generated"

if [ -z "$TEXT" ]; then
  echo "Usage: $0 \"text to speak\" [output_name]"
  echo ""
  echo "Set PIPER_MODEL env var to change voice (default: en_US-ryan-high)"
  echo "Models: https://github.com/rhasspy/piper/blob/master/VOICES.md"
  exit 1
fi

# Check if piper is installed
if ! command -v piper &> /dev/null; then
  echo "Error: piper not found. Install with: brew install piper"
  exit 1
fi

# Generate output name from text if not provided
if [ -z "$OUTPUT_NAME" ]; then
  OUTPUT_NAME=$(echo "$TEXT" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
fi

mkdir -p "$OUTPUT_DIR"

WAV_FILE="${OUTPUT_DIR}/${OUTPUT_NAME}.wav"

echo "Generating: \"$TEXT\""
echo "Model: $MODEL"
echo "Output: $WAV_FILE"

echo "$TEXT" | piper --model "$MODEL" --output_file "$WAV_FILE"

echo "Done!"
