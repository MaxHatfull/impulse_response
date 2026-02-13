# Impulse Response

A game built with [ruby_rpg](https://github.com/rubyrpg/ruby_rpg).

## Setup

```bash
bundle install
```

## Run

```bash
bundle exec bin/run
```

Press **Escape** to quit.

## Generating Voice Lines

Use the built-in script to generate WAV voice lines from text (macOS only):

```bash
./scripts/generate_voice.sh "Hello world"                     # auto-names output
./scripts/generate_voice.sh "System online" system_online     # custom filename
./scripts/generate_voice.sh "Greetings" greet Zarvox          # custom voice
```

Available voices:
- **Samantha** - Clean computer voice (default)
- **Zarvox** - Robotic/alien
- **Trinoids** - Alien chorus
- **Whisper** - Creepy whisper

Output goes to `impulse_response/assets/audio/generated/` by default.

### High-Quality Voice Generation (Piper)

For better quality neural TTS, use Piper:

1. Install Piper:
   ```bash
   pip3 install piper-tts pathvalidate
   ```

2. Download a voice model (one-time):
   ```bash
   mkdir -p models
   curl -L -O https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx
   curl -L -O https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json
   ```

3. Regenerate all voice files from `produced_audio.json`:
   ```bash
   ./scripts/generate_all_voices.sh
   ```

   Or generate a single file:
   ```bash
   ./scripts/generate_voice_piper.sh "Hello world" hello
   ```

## Structure

```
├── bin/
│   └── run                   # launch script
├── scripts/
│   └── generate_voice.sh     # voice line generator
└── impulse_response/
    ├── main.rb               # main entry point
    ├── assets/               # images, models, sounds
    ├── components/           # custom component classes
    └── game_objects/         # reusable game object definitions
```
