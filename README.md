# Warren Audio Briefings

Mobile-first audio player for daily briefings and interview prep.

**Live**: https://warren-wupeng.github.io/warren-audio-briefings/

## Features

- Mobile-first dark UI with large touch targets
- Playback speed control (0.8x - 2.0x)
- Lock screen controls via Media Session API
- Auto-play next track
- Category tabs (Briefings / Interview Prep)
- Zero dependencies, pure HTML/CSS/JS

## Add New Audio

```bash
./scripts/deploy-audio.sh path/to/file.mp3 "Title" briefing
```

Or manually:
1. Copy MP3 to `audio/`
2. Update `audio/manifest.json`
3. `git add . && git commit -m "Add audio" && git push`

GitHub Actions auto-deploys on push to main.
