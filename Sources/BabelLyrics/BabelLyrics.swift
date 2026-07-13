// The Swift Programming Language
// https://docs.swift.org/swift-book

import Rainbow
import Foundation

@main
struct BabelLyrics {
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
        
        let babel = Babel(fileManager: FileManager.default)
        
        if commands.contains("--split") {
            SeparateAudio.splitAudio(babel: babel)
        } else if commands.contains("--segment") {
            SegmentAudio.segmentAudio(babel: babel)
        } else if commands.contains("--transcribe") {
            TranscribeAudio.transcribe(babel: babel)
        } else {
            print(error: "It's offical, I have no idea what you're talking about.")
        }

        print("")
    }
}
