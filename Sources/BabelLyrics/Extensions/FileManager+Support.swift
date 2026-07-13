//
//  Untitled.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

extension FileManager {
    
    var currentDirectory: URL {
        URL(
            fileURLWithPath: currentDirectoryPath,
            isDirectory: true
        )
    }
}
 
extension FileManager {

    func files(
        withExtension ext: String,
        in directory: URL
    ) throws -> [URL] {
        let urls = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )

        return try urls.filter { url in
            let values = try url.resourceValues(forKeys: [.isRegularFileKey])
            return values.isRegularFile == true && url.pathExtension.lowercased() == ext.lowercased()
        }
    }
}

extension FileManager {
    
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    func fileExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue == false
    }
}
