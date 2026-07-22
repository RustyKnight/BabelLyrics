//
//  SegmentAudio.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation
import BabelLyricsLib

/// Command that segments the extracted vocals track by silence.
struct SegmentAudio {
    
    let babel: Babel
    let sourceAudio: URL
    
    /// Runs the vocal segmentation workflow.
    func execute() {
        let currentDirectory = babel.currentDirectory
        let targetDirectory = Paths.audioSegments.appending(to: currentDirectory)
        
        print(debug: "targetDirectory = \(targetDirectory.path())")
        
        do {
            let segmenter = AudioSegmenter(logger: LoggerCallback())
            let stopWatch = StopWatch().start()
            let results = try segmenter.segmentAudio(
                at: sourceAudio,
                outputDirectory: targetDirectory
//                ,
//                configuration: .init(
//                    silenceThresholdDecibels: -20,
//                    minimumSegmentDurationSeconds: 0.7
//                )
            )
            print("")
            print(info: "Took \(stopWatch.formattedUnitsStyle()) to segment vocals audio")
            print(info: "Generated \(results.segments.count) segments")
            
//            let segmentFile = Self.appendingSegmentsFile(to: currentDirectory)
            let segmentFile = Paths.vocalSegmentsMetaData.appending(to: currentDirectory)
            let segmentPath = segmentFile.pathDroppingPrefix(of: currentDirectory)
            print(debug: "Saving segments meta data to \(segmentPath)")
            
            try JSONEncoder.save(results, to: segmentFile)
            
            print(info: "Completed audio segmentation")
        } catch let error as AudioSegmenterError {
            switch error {
            case .inputMustBeFileURL:
                print(error: "Invalid audio source")
            case .inputFileMissing(_):
                print(error: "Audio source is missing")
            case .ffmpegCommandFailed(let string):
                print(error: "FFMPEG execution failed")
                print(string.white)
            case .sourceDurationMissing:
                print(error: "Missing audio source duration")
            }
        } catch {
            print(error: "Failed while attempting to segment vocal audio")
            print(error.localizedDescription.white)
        }
    }
}

fileprivate struct LoggerCallback: LogDelegate {
    func log(_ message: LogMessage) {
        guard Babel.isDebug else { return }
        // May want to pick up on the segment progress...
        print(debug: message.message)
    }
}
//
//extension SegmentAudio {
//    
//    static let segmentsFileName = "VocalSegments.json"
//    
//    static func appendingSegmentsFile(to url: URL) -> URL {
//        BabelLyrics
//            .Path
//            .support
//            .appending(to: url)
//            .appendingPathComponent(Self.segmentsFileName)
//    }
//}

extension SegmentAudio {
    
    /// Locates `Audio/vocals.wav` and runs segmentation.
    static func segmentAudio(babel: Babel) {
        let fileManager = babel.fileManager
        let currentDirectory = babel.currentDirectory
        
        let audioPath = Paths.audio.appending(to: currentDirectory)
        guard fileManager.directoryExists(at: audioPath) else {
            print(error: "Missing Audio directory")
            print(error: "Ensure source audio has been split first")
            return
        }
        
        let vocalAudio = audioPath.appendingPathComponent("vocals-mono.wav")
        guard fileManager.fileExists(at: vocalAudio) else {
            print(error: "Missing Audio/vocals-mono.wav")
            print(error: "Ensure source audio has been split first")
            return
        }
        
        print(info: "Segmenting vocals audio")
        
        let command = SegmentAudio(
            babel: babel,
            sourceAudio: vocalAudio
        )
        command.execute()
    }
    
}
