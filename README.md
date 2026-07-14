# BabelLyrics

`BabelLyrics` is a macOS Swift CLI for turning a source MP3 into separated vocal/music tracks, lyric transcriptions, and a final lyrics video.

It depends on [`BabelLyricsLib`](https://github.com/RustyKnight/BabelLyricsLib) (`main` branch) and uses:

- `Demucs` for source separation
- `FFmpeg` for audio segmentation
- `Whisper` for transcription
- `AVFoundation` for video rendering

## Requirements

- macOS 13+
- Swift 6.3+
- Python 3
- `ffmpeg`
- `demucs`
- `whisper`

The library dependency is resolved from GitHub by Swift Package Manager.

## Build

```bash
swift build
```

## Test

```bash
swift test
```

## CLI commands

Run the executable from a directory containing your source audio files.

Supported flags:

- `--split` — split the source MP3 into vocals and music
- `--segment` — segment the vocals track
- `--transcribe` — transcribe the vocal segments
- `--render` — render the lyrics video

You can combine flags in a single run:

```bash
BabelLyrics --split --segment --transcribe --render
```

The CLI runs the requested workflows in this order:

1. `--split`
2. `--segment`
3. `--transcribe`
4. `--render`

## Project outputs

The CLI writes its files relative to the current working directory:

- `Audio/vocals.wav`
- `Audio/music.wav`
- `Support/Segments/`
- `Support/VocalSegments.json`
- `Support/Transcriptions/`
- `Support/VocalAudioTranscript.json`
- `Video/Lyrics.mov`

## Examples

### 1. Split a single MP3

Put one MP3 in the working directory, then run:

```bash
BabelLyrics --split
```

This creates separated tracks under `Audio/`.

### 2. Segment vocals

After splitting:

```bash
BabelLyrics --segment
```

This reads `Audio/vocals.wav` and writes segment files under `Support/Segments/`.

### 3. Transcribe the segments

After segmentation:

```bash
BabelLyrics --transcribe
```

This reads `Support/VocalSegments.json` and writes `Support/VocalAudioTranscript.json`.

### 4. Render the final video

After transcription:

```bash
BabelLyrics --render
```

This reads the transcript metadata and writes `Video/Lyrics.mov`.

### 5. Full pipeline

```bash
BabelLyrics --split --segment --transcribe --render
```

## Notes

- The CLI uses the current directory as its working root.
- If more than one MP3 exists in the directory, `--split` stops and asks for a single source file.
- The `BabelLyricsLib` package can also export separated tracks to a custom destination directory when used directly from Swift code.
