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
        
        if commands.contains("--split") {
            SeparateAudio.splitAudio()
        } else if commands.contains("--segment") {
            SegmentAudio.segmentAudio()
        } else {
            print(error: "It's offical, I have no idea what you're talking about.")
        }

        print("")
    }
}
