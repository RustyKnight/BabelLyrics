//
//  Babel.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 14/7/2026.
//

import Foundation

/// Shared runtime context for the BabelLyrics CLI.
struct Babel {
    /// Filesystem helper used by commands and support utilities.
    let fileManager: FileManager
    
    let configuration: Configuration

    /// The process working directory as a file URL.
    var currentDirectory: URL {
        fileManager.currentDirectory
    }
}

extension Babel {
    /// Enables verbose debug logging for CLI workflows.
    nonisolated(unsafe) static var isDebug = true
}
