#!/bin/bash

# Generate all voice files from produced_audio.json using Piper TTS

PIPER="/Users/maxhatfull/Library/Python/3.9/bin/piper"
MODEL="/Users/maxhatfull/dev/impulse_response/models/en_US-lessac-medium.onnx"
JSON_FILE="/Users/maxhatfull/dev/impulse_response/produced_audio.json"
AUDIO_DIR="/Users/maxhatfull/dev/impulse_response/impulse_response/assets/audio"

# Check dependencies
if [ ! -f "$PIPER" ]; then
  echo "Error: piper not found at $PIPER"
  exit 1
fi

if [ ! -f "$MODEL" ]; then
  echo "Error: model not found at $MODEL"
  exit 1
fi

# Parse JSON and generate audio
# Using python to parse JSON since bash isn't great at it
python3 << 'EOF'
import json
import subprocess
import os

json_file = "/Users/maxhatfull/dev/impulse_response/produced_audio.json"
audio_dir = "/Users/maxhatfull/dev/impulse_response/impulse_response/assets/audio"
piper = "/Users/maxhatfull/Library/Python/3.9/bin/piper"
model = "/Users/maxhatfull/dev/impulse_response/models/en_US-lessac-medium.onnx"

with open(json_file) as f:
    data = json.load(f)

def process_entries(entries, path):
    for entry in entries:
        if isinstance(entry, dict):
            filename = entry.get("filename")
            content = entry.get("content")
            if content:  # Skip null content (ambient sounds)
                output_path = os.path.join(audio_dir, path, filename)
                os.makedirs(os.path.dirname(output_path), exist_ok=True)
                print(f"Generating: {output_path}")
                print(f"  Text: {content}")
                proc = subprocess.run(
                    [piper, "--model", model, "--output_file", output_path],
                    input=content,
                    text=True
                )
                if proc.returncode == 0:
                    print("  Done!")
                else:
                    print(f"  Error: {proc.returncode}")

def traverse(obj, path=""):
    if isinstance(obj, list):
        process_entries(obj, path)
    elif isinstance(obj, dict):
        for key, value in obj.items():
            new_path = os.path.join(path, key) if path else key
            traverse(value, new_path)

traverse(data["audio"])
print("\nAll done!")
EOF
