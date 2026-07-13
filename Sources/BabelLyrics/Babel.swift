//
//  Babel.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 14/7/2026.
//

import Foundation

struct Babel {
    let fileManager: FileManager
    var currentDirectory: URL {
        fileManager.currentDirectory
    }
}

extension Babel {
    nonisolated(unsafe) static var isDebug = true
}
