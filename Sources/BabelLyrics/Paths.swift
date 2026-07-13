//
//  BabelLyrics+Paths.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

/// Well-known project directories and metadata file locations.
enum Paths {
    case audio
    case video
    case support
    case audioSegments
    case transcribedAudio
    
    case vocalSegmentsMetaData
    case vocalAudioTranscriptMetaData
    
    // Add vocal and music audio?
}

extension Paths {
    
    /// Returns the relative path for the path case.
    var path: String {
        switch self {
        case .audio: "Audio"
        case .video: "Video"
        case .support: "Support"
        case .audioSegments:
            "\(Paths.support.path)/Segments"
        case .transcribedAudio:
            "\(Paths.support.path)/Transcriptions"
        case .vocalSegmentsMetaData:
            "\(Paths.support.path)/VocalSegments.json"
        case .vocalAudioTranscriptMetaData:
            "\(Paths.support.path)/VocalAudioTranscript.json"
        }
    }
}

extension Paths {
    
    /// Appends the relative path to a base URL.
    func appending(to url: URL) -> URL {
        url.appendingPathComponent(self.path)
    }
}
