//
//  SeparateAudio.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation
import BabelLyricsLib
import Rainbow

struct SeparateAudio {
    
    let sourceAudio: URL
    
    func execute() {
        do {
            print(info: "Starting audio separation (this will take a while)")
            let stopWatch = StopWatch().start()
            let separator = AudioSeparator(logger: LoggerCallback())
            let separatorResult = try separator.separateAudio(
                at: sourceAudio,
                configuration: .init(
                    model: .htdemucsFT,
                    //overlap: 0.5,
                    //shifts: 5,
                    jobs: 4,
                ),
                destinationDirectory: targetDirectory(for: sourceAudio)
            )
            
            stopWatch.stop()
            
            let sourcePath = sourceAudio.deletingLastPathComponent()
            
            let musicPath = separatorResult
                .musicURL
                .pathDroppingPrefix(of: sourcePath)
            let vocalsPath = separatorResult
                .vocalsURL
                .pathDroppingPrefix(of: sourcePath)

            print("")
            print(info: "Took \(stopWatch.formattedUnitsStyle()) to separate audio tracks")
            print(info: "Audio tracks exported to:")
            print(info: " - Music: \(musicPath)")
            print(info: " - Vocals: \(vocalsPath)")
            print("")
        } catch let error as AudioSeparatorError {
            print(error: "Audio separation failed")
            switch error {
            case .inputMustBeFileURL:
                print(error: "Input must be a file")
            case .destinationDirectoryMustBeFileURL:
                print(error: "Destination must be local reference")
            case .inputFileMissing(_):
                print(error: "Input file is missing")
            case .demucsCommandFailed(let string):
                print(error: "Demucs command failed")
                print(string)
            case .missingDemucsOutput(_):
                print(error: "Demucs failed to produce any output")
            case .failedToRemoveTemporaryDirectory(_, _):
                print(error: "Failed to remove temporary directory")
            case .invalidDemucsConfiguration(let string):
                print(error: "Invalid Demucs configuration".yellow)
                print(string)
            }
        } catch {
            print(error: "Audio separation failed")
            print(error.localizedDescription)
        }
        print(info: "Audio separation completed")
    }
    
    private func targetDirectory(for source: URL) -> URL {
        BabelLyrics.Path.audio.appending(to: source.deletingLastPathComponent())
//        source
//            .deletingLastPathComponent()
//            .appendingPathComponent(Self.audioDirectoryName)
    }
}

fileprivate struct LoggerCallback: LogDelegate {
    func log(_ message: LogMessage) {
        print(debug: message.message)
    }
}

extension SeparateAudio {
    
    static func splitAudio() {
        do {
            let fileManager = FileManager.default
            let currentDirectory = fileManager.currentDirectory
            
            let matches = try fileManager.files(
                withExtension: "mp3",
                in: currentDirectory
            )
            guard matches.isEmpty == false else {
                print(warning: "Unable to find any matching MP3 audio files in current directory")
                return
            }
            guard matches.count == 1, let sourceAudio = matches.first else {
                print(warning: "Directory contains multiple MP3 audio files, Babel can only support a single MP3")
                return
            }
            
            print(info: "Splitting vocal and music tracks for \"\(sourceAudio.lastPathComponent)\"")
            
            let command = SeparateAudio(sourceAudio: sourceAudio)
            command.execute()
        } catch {
            print(error: "Unable to search current directory for MP3 audio files")
            print(error.localizedDescription)
        }
    }
    
}
