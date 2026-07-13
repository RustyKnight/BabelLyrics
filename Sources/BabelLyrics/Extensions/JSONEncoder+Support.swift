//
//  JSONEncoder+Support.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

extension JSONEncoder {
    /// Encodes a value as pretty-printed JSON and writes it to disk.
    static func save<T>(_ value: T, to url: URL) throws where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(value)
        
        try data.write(to: url)
    }
}
