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

Voice lines are generated using [Piper TTS](https://github.com/rhasspy/piper).

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
│   ├── generate_all_voices.sh    # regenerate all from produced_audio.json
│   └── generate_voice_piper.sh   # generate single voice line
└── impulse_response/
    ├── main.rb               # main entry point
    ├── assets/               # images, models, sounds
    ├── components/           # custom component classes
    └── game_objects/         # reusable game object definitions
```
