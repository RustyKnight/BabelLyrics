//
//  JSONDecoder+Support.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 14/7/2026.
//

import Foundation

extension JSONDecoder {
    
    static func load<T>(_ type: T.Type, from url: URL) throws -> T where T : Decodable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder.init().decode(type, from: data)
    }
}
