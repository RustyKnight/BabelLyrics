// The Swift Programming Language
// https://docs.swift.org/swift-book

import Rainbow
import Foundation

/// Entry point for the BabelLyrics command-line interface.
@main
struct BabelLyrics {
    /// Parses command-line arguments and dispatches requested workflows.
    static func main() {
        let arguments = CommandLine.arguments.dropFirst()

        print("")
        
        let commands = arguments.map { $0.lowercased() }
        
        if commands.contains("--config") {
            outputConfig()
            return
        }
        
        let recognizedCommands = [
            "--split",
            "--segment",
            "--transcribe",
            "--render"
        ]
        
        let commandSet = Set(commands)
        guard arguments.isEmpty == false && recognizedCommands.contains(where: commandSet.contains) else {
            print("It's official, I have no idea what you're talking about".lightYellow)
            
            print("")
            print("--split".lightWhite + " splits a MP3 audio file, separating the vocal and music tracks".white)
            print("  - The file must exist in the current directory".white)
            print("  - Only supports a single MP3".white)
            print("  - The separated tracks are stored in the \"Audio\" directory".white)
            print("--segment".lightWhite + " segments the vocal audio".white)
            print("  - Isolates the audio components from the surrounding silence in the vocal audio track".white)
            print("--transcribe".lightWhite + " transcribes the audio segments to text".white)
            print("--render".lightWhite + " renders the transcript into a \"karaoke\" like, transparent video".white)
            return
        }
        
        do {
            let configuration = try loadConfiguration()
            
            let babel = Babel(
                fileManager: FileManager.default,
                configuration: configuration
            )
            
            if commands.contains("--split") {
                SeparateAudio.splitAudio(babel: babel)
            }
            if commands.contains("--segment") {
                SegmentAudio.segmentAudio(babel: babel)
            }
            if commands.contains("--transcribe") {
                TranscribeAudio.transcribe(babel: babel)
            }
            if commands.contains("--render") {
                VideoRenderer.render(babel: babel)
            }
        } catch {
            print(error: "Could not initialise configuration")
            print(error.localizedDescription)
        }
        
        print("")
    }
}

extension BabelLyrics {
    static func loadConfiguration() throws -> Configuration {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectory
        
        let url = Files.configuration.url(in: currentDirectory)
        
        guard fileManager.fileExists(at: url) else {
            return .init()
        }
        
        print(info: "Loading custom configuration")
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let intermediate = try decoder.decode(Configuration.Intermediate.self, from: data)
            return intermediate.resolve()
        }
    }
}

extension BabelLyrics {
    static func outputConfig() {
        let fileManager = FileManager.default
        let currentDirectory = fileManager.currentDirectory
        
        let config = Configuration.Intermediate(
            configuration: .init()
        )
        
        print(info: "Generating sample configuration")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            let data = try encoder.encode(config)
            
            let target = Files.configuration.url(in: currentDirectory)
            try data.write(to: target)
        } catch {
            print(error: "Unable to generate configuration example")
            print(error.localizedDescription)
        }
    }
}
