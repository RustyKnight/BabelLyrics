//
//  Configuration.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 22/7/2026.
//

import BabelLyricsLib

struct Configuration {
    
    let splitter: AudioSeparator.DemucsConfiguration
    let segmentation: AudioSegmenterConfiguration
    let transcriber: AudioTranscriberConfiguration
    
    init(
        splitter: AudioSeparator.DemucsConfiguration = .init(),
        segmentation: AudioSegmenterConfiguration = .init(),
        transcriber: AudioTranscriberConfiguration = .init()
    ) {
        self.splitter = splitter
        self.segmentation = segmentation
        self.transcriber = transcriber
    }
}
