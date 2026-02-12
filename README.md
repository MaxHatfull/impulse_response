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
