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

## Project driven

The intention of the CLI is to drive a project based around a single MP3.

Output of the various phases are stored relative to source MP3 and each phase relies on the output from previous phase in order to perform its operations.

Because the workflow is heavily AI depended, the output should always be reviewed.

The commands should be run in order of:
* Split
* Segment
* Transcribe
* Render

Because each phase persists it's output, subsequent phases can be rerun without the need to run previous phases.  This allows you to make modifications to the output from a previous phases and run subsequent phases and update their outputs.

## Build

```bash
swift build
```

## Test

```bash
swift test
```

## CLI commands

Run the executable from a directory containing your source audio file.

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
- `Audio/vocals-mono.wav`
- `Audio/music.wav`
- `Support/Segments/`
- `Support/VocalSegments.json`
- `Support/Transcriptions/`
- `Support/VocalAudioTranscript.json`
- `Video/Lyrics.mov`

## Configuration

Configuration is provided by a `BabelConfiguration.json` file within the project directory, this is used to drive each individual phase.  If you just want to configure a single phase, you only need to supply the configuration elements for it.

Some properties are optional, meaning that it will be excluded when executing the underlying command.  Some properties are default optional, meaning, if you don't supply a value for them, they will default to a specific value.

### Audio Separation

See Demucs CLI documentation for more details.

* model: String - Model to be used.
	* Default: `htdemucs_ft`
	* Valid options include: `htdemucs`, `htdemucs_ft`, `htdemucs_6s`, `mdx_extra` and `mdx_extra_q`
* device: String - Determins how the AI is run.  As a general rule, use `cpu` unless you really understand what you're doing.
	* Default: `cpu`
	* Valid options include: `cpu`, `mps`, `cuba`
* segment: Int - Optional whole second segment length.
	* Default: `7`
* overlap: Double - Optional overlap ratio.
	* Default: `0.5`
* shifts: Int - Optional number of random shifts.  This WILL increase the processing time as each model is executed `shift` times.  So a model which contains only a single model and shift of 2 will run 2 times.  A model with 4 models and shift of 2 will run 8 times.
* jobs: Int - Optional number of workers

### Audio segmentation

See ffmpeg CLI documenation for more details.

* silenceThresholdDecibels: Double - Silence detection threshold in decibels.
	* Default: `-35`
* minimumSilenceDurationSeconds: Double - Minimum silence duration in seconds.
	* Default: `0.35`
* minimumSegmentDurationSeconds: Double - Minimum generated segment duration in seconds.
	* Default: `0.026`
* segmentPaddingSeconds: Double - Silence padding added to both start and end of each segment.
	* Default: `0.5`

### Audio Transcriber

See Whisper CLI documentation for more details

* model: String - Whisper model to use
	* Default: `large-v3`
	* Valid options: `tiny`, `base`, `small`, `medium`, `large`, `large-v2`, `large-v3`, `large-v3-turbo`, `turbo`
	* Note: The availability of models will depend on the version of Whisper installed.
* language: String - Language of the audio.	Generally either the full name or two character coding should be accepted, ie `english` or `en`
	* Default: English
* task: String - Defines the output operation to execute.
	* Default: `transcribe`
	* Value options: `transcribe`, `translate`
* beamSize: Int - Beam size used during beam searches.
	* Default: `5`
* temperature: Double
	* Default: `0.0`
* bestOf: Int - Optional `best_of` candidate count.
* conditionOnPreviousText: Bool - Whisper context carry-over behavior.
	* Default: `true`
* initialPrompt: String - Optional Optional initial prompt for domain-specific vocabulary.
* threads: Int - Optional thread count for Whisper to use.

### Video Renderer

* resolution: Resolution of video
	* Default: 1080p
* framesPerSecond: Double
	* Default: `25`
* preRollPaddingSeconds: Double - Pre-roll padding in seconds before a lyric line becomes active.
	* Default: `1`
* postRollPaddingSeconds: Double - Post-roll padding in seconds after a lyric line ends.
	* Default: `1`
* horizontalPadding: Int - Horizontal subtitle padding in pixels.
	* Default: `128`
* bottomPadding: Int - Bottom subtitle padding in pixels.
	* Default: `96`
* outputFileExtension: String
	* Default: `mov`

#### Notes

Resolution is a complex structure.  By default several "default" resolutions are supported automatically:

* hd720
* hd1080
* uhd4k

For example:

```
    "resolution" : {
      "kind" : "hd1080"
    },
```

Resolution also provides several custom options.

##### Custom resolution

```
"resolution" : {
  "width" : 100,
  "height" : 100,
  "kind" : "custom"
},
```

##### Custom height with aspect ratio

```
"resolution" : {
  "aspectRatio" : 1.77777778,
  "kind" : "heightRatio",
  "height" : 1080
},
```

##### Custom width with aspect ratio

```
"resolution" : {
  "width" : 1920,
  "kind" : "widthRatio",
  "aspectRatio" : 1.77777778
},
```

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

This reads `Audio/vocals-mono.wav` and writes segment files under `Support/Segments/`.

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
