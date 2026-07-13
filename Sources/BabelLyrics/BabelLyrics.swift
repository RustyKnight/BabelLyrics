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

        guard arguments.isEmpty == false else {
            print("")
            print(error: "No commands provide")
            print("")
            return
        }

        print("")
        
        let commands = arguments.map { $0.lowercased() }
        
        let recognizedCommands = [
            "--split",
            "--segment",
            "--transcribe",
            "--render"
        ]
        
        let commandSet = Set(commands)
        guard recognizedCommands.contains(where: commandSet.contains) else {
            print("It's official, I have no idea what you're talking about".lightYellow)
            return
        }
        
        let babel = Babel(fileManager: FileManager.default)
        
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

        print("")
    }
}
