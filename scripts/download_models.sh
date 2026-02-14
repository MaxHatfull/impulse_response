#!/bin/bash

# Download Piper TTS voice models

MODELS_DIR="/Users/maxhatfull/dev/impulse_response/models"
BASE_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US"

mkdir -p "$MODELS_DIR"
cd "$MODELS_DIR"

echo "Downloading Piper voice models..."

# Ryan high quality (default voice)
echo "Downloading en_US-ryan-high..."
curl -L -O "$BASE_URL/ryan/high/en_US-ryan-high.onnx"
curl -L -O "$BASE_URL/ryan/high/en_US-ryan-high.onnx.json"

echo "Done! Models downloaded to $MODELS_DIR"
