//
//  VideoRenderer.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 14/7/2026.
//

import Foundation
import BabelLyricsLib

/// Command that renders a lyrics video from transcription metadata.
struct VideoRenderer {
    
    let babel: Babel
    let model: AudioTranscriberModel
    
    /// Runs the video rendering workflow.
    func execute() {
        let currentDirectory = babel.currentDirectory
        
        let destination = Paths.video.appending(to: currentDirectory)
        
        do {
            print(info: "Starting lyrics video rendering")
            let stopWatch = StopWatch().start()
            let renderer = BabelLyricsLib.VideoRenderer(logger: LoggerCallback())
            let videoURL = try renderer.renderVideo(
                from: model,
                destinationDirectory: destination
            )
            print(info: "Took \(stopWatch.formattedUnitsStyle()) to render lyrics video")
            let path = videoURL.pathDroppingPrefix(of: currentDirectory)
            print(info: "Rendered lyrics video to \(path)")
        } catch {
            print(error: "Failed to render lyrics video")
            print(error.localizedDescription)
        }
    }
}

private struct LoggerCallback: LogDelegate {
    func log(_ message: BabelLyricsLib.LogMessage) {
        guard Babel.isDebug else { return }
        print(debug: message.message)
    }
}
extension VideoRenderer {
    
    /// Loads transcription metadata and renders the final video.
    static func render(babel: Babel) {
        let fileManager = babel.fileManager
        let currentDirectory = babel.currentDirectory

        let transcriptFile = Paths.vocalAudioTranscriptMetaData.appending(to: currentDirectory)
        guard fileManager.fileExists(at: transcriptFile) else {
            print(error: "Vocal audio must been transcribed first!")
            return
        }
        
        do {
            let model = try JSONDecoder.load(
                AudioTranscriberModel.self,
                from: transcriptFile
            )
            let renderer = VideoRenderer(
                babel: babel,
                model: model
            )
            
            renderer.execute()
        } catch {
            print(error: "Unable to load transcript")
            print(error.localizedDescription)
        }
    }
}
