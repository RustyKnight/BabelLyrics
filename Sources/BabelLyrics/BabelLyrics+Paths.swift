//
//  BabelLyrics+Paths.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

extension BabelLyrics {
    
    enum Path: String {
        case audio = "Audio"
        case support = "Support"
        case audioSegments = "Support/Segments"
    }
    
}

extension BabelLyrics.Path {
    
    func appending(to url: URL) -> URL {
        url.appendingPathComponent(self.rawValue, isDirectory: true)
    }
}
