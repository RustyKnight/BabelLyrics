//
//  Files.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 23/7/2026.
//

import Foundation

enum Files: String, CaseIterable, Sendable {
    case configuration = "BabelConfiguration.json"

    /// Resolves this output filename within a destination directory.
    ///
    /// - Parameter directory: Target output directory.
    /// - Returns: Full URL for this output file in `directory`.
    public func url(in directory: URL) -> URL {
        directory.appendingPathComponent(rawValue)
    }
}
