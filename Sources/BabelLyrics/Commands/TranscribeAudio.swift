//
//  TranscribeAudio.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 14/7/2026.
//

import Foundation
import BabelLyricsLib

/// Command that transcribes segmented vocal audio into lyric text.
struct TranscribeAudio {
    
    let babel: Babel
    let metaData: AudioSegmenterModel
    
    /// Runs the transcription workflow and persists the result.
    func execute() {
        let currentDirectory = babel.currentDirectory
        let destinationPath = Paths.transcribedAudio.appending(to: currentDirectory)
        let audioSegmentsPath = Paths.audioSegments.appending(to: currentDirectory)

        print(info: "Starting audio transcription")
        
        do {
            let stopWatch = StopWatch().start()
            let transcriber = AudioTranscriber(logger: LoggerCallback())
            let transcribedModel = try transcriber.transcribeAudio(
                from: metaData,
                audioSegmentSourceURL: audioSegmentsPath,
                temporaryDirectory: destinationPath,
                configuration: babel.configuration.transcriber
            ) { progress in
                guard progress.message?.contains("Completed Whisper transcription") == false else {
                    print("")
                    return
                }
                
                
                let totalProgress = progress.fractionCompleted.formatted(.percent.precision(.fractionLength(1)))
                let passProgress = progress.currentSegmentFraction.formatted(.percent.precision(.fractionLength(1)))
                let passCompleted = "\(progress.currentSegmentIndex)-\(progress.totalSegments)"
                let eta = progress.estimatedTimeRemaining?.formatted(
                    .units(
                        allowed: [.minutes, .seconds],
                        width: .narrow
                    )
                ) ?? "--"
                
                print("\u{001B}[2K\r🟢 Segment [\(passCompleted) @ \(passProgress)] Overall: \(totalProgress) [\(eta)]", terminator: "")
                fflush(stdout) // force immediate terminal update
            }

            let segmentCount = metaData.segments.count
            print(info: "Took \(stopWatch.formattedUnitsStyle()) to transcribe \(segmentCount) audio segments")
            let lyrics = transcribedModel.plainLines.joined(separator: "\n")
            print("")
            print(lyrics)
            print("")
            
            let transcriptFile = Paths.vocalAudioTranscriptMetaData.appending(to: currentDirectory)
            let transcriptPath = transcriptFile.pathDroppingPrefix(of: currentDirectory)
            print(debug: "Saving transcript to \(transcriptPath)")
            
            try JSONEncoder.save(
                transcribedModel,
                to: transcriptFile
            )
        } catch {
            
        }
    }
}

private struct LoggerCallback: LogDelegate {
    func log(_ message: BabelLyricsLib.LogMessage) {
        
        switch message.level {
        case .debug:
//            guard Babel.isDebug else { return }
//            print(debug: message.message)
            break
        case .info:
//            print(info: message.message)
            break
        case .warning:
            print(warning: message.message)
        case .error:
            print(error: message.message)
        }
    }
}

extension TranscribeAudio {
    
    /// Loads segmentation metadata and runs transcription.
    static func transcribe(babel: Babel) {
        let fileManager = babel.fileManager
        let currentDirectory = babel.currentDirectory
        let metaDataFile = Paths.vocalSegmentsMetaData.appending(to: currentDirectory)
        
        guard fileManager.fileExists(at: metaDataFile) else {
            print(error: "Vocal audio must have been segment first!")
            return
        }
        
        do {
            print(info: "Loading audio segments meta data")
            let metaData = try JSONDecoder.load(AudioSegmenterModel.self, from: metaDataFile)
            let transcribe = TranscribeAudio(
                babel: babel,
                metaData: metaData
            )
            transcribe.execute()
        } catch {
            print(error: "Unable to load audio segments meta data")
            print(error.localizedDescription)
        }
    }
}
