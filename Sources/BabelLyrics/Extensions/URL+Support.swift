//
//  URL+Support.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

extension URL {
    
    /// Returns the path with the supplied base path removed from the front.
    func pathDroppingPrefix(of url: URL) -> String {
        path()
            .replacingOccurrences(
                of: url.path(),
                with: ""
            )
    }
    
}
