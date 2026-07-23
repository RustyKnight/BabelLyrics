//
//  Configuration.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 22/7/2026.
//

import BabelLyricsLib

struct Configuration: Codable, Sendable {
    
    let splitter: AudioSeparator.DemucsConfiguration
    let segmenter: AudioSegmenterConfiguration
    let transcriber: AudioTranscriberConfiguration
    let renderer: VideoRendererConfiguration
    
    init(
        splitter: AudioSeparator.DemucsConfiguration = .init(),
        segmenter: AudioSegmenterConfiguration = .init(),
        transcriber: AudioTranscriberConfiguration = .init(),
        renderer: VideoRendererConfiguration = .init()
    ) {
        self.splitter = splitter
        self.segmenter = segmenter
        self.transcriber = transcriber
        self.renderer = renderer
    }
}
