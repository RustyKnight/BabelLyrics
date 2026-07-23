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

extension Configuration {
    struct Intermediate: Codable, Sendable {
        let splitter: Splitter?
        let segmenter: Segmenter?
        let transcriber: Transcriber?
        let renderer: Renderer?

        init(
            splitter: Splitter? = nil,
            segmenter: Segmenter? = nil,
            transcriber: Transcriber? = nil,
            renderer: Renderer? = nil
        ) {
            self.splitter = splitter
            self.segmenter = segmenter
            self.transcriber = transcriber
            self.renderer = renderer
        }

        init(configuration: Configuration) {
            splitter = .init(configuration: configuration.splitter)
            segmenter = .init(configuration: configuration.segmenter)
            transcriber = .init(configuration: configuration.transcriber)
            renderer = .init(configuration: configuration.renderer)
        }

        func resolve(defaults: Configuration = .init()) -> Configuration {
            .init(
                splitter: splitter?.resolve(defaults: defaults.splitter) ?? defaults.splitter,
                segmenter: segmenter?.resolve(defaults: defaults.segmenter) ?? defaults.segmenter,
                transcriber: transcriber?.resolve(defaults: defaults.transcriber) ?? defaults.transcriber,
                renderer: renderer?.resolve(defaults: defaults.renderer) ?? defaults.renderer
            )
        }

        enum CodingKeys: String, CodingKey {
            case splitter
            case segmenter
            case transcriber
            case renderer
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            splitter = try container.decodeIfPresent(Splitter.self, forKey: .splitter)
            segmenter = try container.decodeIfPresent(Segmenter.self, forKey: .segmenter)
            transcriber = try container.decodeIfPresent(Transcriber.self, forKey: .transcriber)
            renderer = try container.decodeIfPresent(Renderer.self, forKey: .renderer)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeOrNil(splitter, forKey: .splitter)
            try container.encodeOrNil(segmenter, forKey: .segmenter)
            try container.encodeOrNil(transcriber, forKey: .transcriber)
            try container.encodeOrNil(renderer, forKey: .renderer)
        }
    }
}

extension Configuration.Intermediate {
    struct Splitter: Codable, Sendable {
        let model: AudioSeparator.DemucsModel?
        let device: AudioSeparator.DemucsDevice?
        let segment: OptionalOverride<Int>
        let overlap: OptionalOverride<Double>
        let shifts: OptionalOverride<Int>
        let jobs: OptionalOverride<Int>

        init(
            model: AudioSeparator.DemucsModel? = nil,
            device: AudioSeparator.DemucsDevice? = nil,
            segment: OptionalOverride<Int> = .missing,
            overlap: OptionalOverride<Double> = .missing,
            shifts: OptionalOverride<Int> = .missing,
            jobs: OptionalOverride<Int> = .missing
        ) {
            self.model = model
            self.device = device
            self.segment = segment
            self.overlap = overlap
            self.shifts = shifts
            self.jobs = jobs
        }

        init(configuration: AudioSeparator.DemucsConfiguration) {
            model = configuration.model
            device = configuration.device
            segment = .from(configuration.segment)
            overlap = .from(configuration.overlap)
            shifts = .from(configuration.shifts)
            jobs = .from(configuration.jobs)
        }

        func resolve(defaults: AudioSeparator.DemucsConfiguration) -> AudioSeparator.DemucsConfiguration {
            .init(
                model: model ?? defaults.model,
                device: device ?? defaults.device,
                shifts: shifts.resolve(defaults.shifts),
                overlap: overlap.resolve(defaults.overlap),
                segment: segment.resolve(defaults.segment),
                jobs: jobs.resolve(defaults.jobs)
            )
        }

        enum CodingKeys: String, CodingKey {
            case model
            case device
            case segment
            case overlap
            case shifts
            case jobs
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            model = try container.decodeIfPresent(AudioSeparator.DemucsModel.self, forKey: .model)
            device = try container.decodeIfPresent(AudioSeparator.DemucsDevice.self, forKey: .device)
            segment = try container.decodeOptionalOverride(Int.self, forKey: .segment)
            overlap = try container.decodeOptionalOverride(Double.self, forKey: .overlap)
            shifts = try container.decodeOptionalOverride(Int.self, forKey: .shifts)
            jobs = try container.decodeOptionalOverride(Int.self, forKey: .jobs)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeOrNil(model, forKey: .model)
            try container.encodeOrNil(device, forKey: .device)
            try container.encodeOptionalOverride(segment, forKey: .segment)
            try container.encodeOptionalOverride(overlap, forKey: .overlap)
            try container.encodeOptionalOverride(shifts, forKey: .shifts)
            try container.encodeOptionalOverride(jobs, forKey: .jobs)
        }
    }

    struct Segmenter: Codable, Sendable {
        let silenceThresholdDecibels: Double?
        let minimumSilenceDurationSeconds: Double?
        let minimumSegmentDurationSeconds: Double?
        let segmentPaddingSeconds: Double?

        init(
            silenceThresholdDecibels: Double? = nil,
            minimumSilenceDurationSeconds: Double? = nil,
            minimumSegmentDurationSeconds: Double? = nil,
            segmentPaddingSeconds: Double? = nil
        ) {
            self.silenceThresholdDecibels = silenceThresholdDecibels
            self.minimumSilenceDurationSeconds = minimumSilenceDurationSeconds
            self.minimumSegmentDurationSeconds = minimumSegmentDurationSeconds
            self.segmentPaddingSeconds = segmentPaddingSeconds
        }

        init(configuration: AudioSegmenterConfiguration) {
            silenceThresholdDecibels = configuration.silenceThresholdDecibels
            minimumSilenceDurationSeconds = configuration.minimumSilenceDurationSeconds
            minimumSegmentDurationSeconds = configuration.minimumSegmentDurationSeconds
            segmentPaddingSeconds = configuration.segmentPaddingSeconds
        }

        func resolve(defaults: AudioSegmenterConfiguration) -> AudioSegmenterConfiguration {
            .init(
                silenceThresholdDecibels: silenceThresholdDecibels ?? defaults.silenceThresholdDecibels,
                minimumSilenceDurationSeconds: minimumSilenceDurationSeconds ?? defaults.minimumSilenceDurationSeconds,
                minimumSegmentDurationSeconds: minimumSegmentDurationSeconds ?? defaults.minimumSegmentDurationSeconds,
                segmentPaddingSeconds: segmentPaddingSeconds ?? defaults.segmentPaddingSeconds
            )
        }
    }

    struct Transcriber: Codable, Sendable {
        let model: AudioTranscriberConfiguration.Model?
        let language: AudioTranscriberConfiguration.Language?
        let task: AudioTranscriberConfiguration.Task?
        let beamSize: Int?
        let temperature: Double?
        let bestOf: OptionalOverride<Int>
        let conditionOnPreviousText: Bool?
        let initialPrompt: OptionalOverride<String>
        let threads: OptionalOverride<Int>

        init(
            model: AudioTranscriberConfiguration.Model? = nil,
            language: AudioTranscriberConfiguration.Language? = nil,
            task: AudioTranscriberConfiguration.Task? = nil,
            beamSize: Int? = nil,
            temperature: Double? = nil,
            bestOf: OptionalOverride<Int> = .missing,
            conditionOnPreviousText: Bool? = nil,
            initialPrompt: OptionalOverride<String> = .missing,
            threads: OptionalOverride<Int> = .missing
        ) {
            self.model = model
            self.language = language
            self.task = task
            self.beamSize = beamSize
            self.temperature = temperature
            self.bestOf = bestOf
            self.conditionOnPreviousText = conditionOnPreviousText
            self.initialPrompt = initialPrompt
            self.threads = threads
        }

        init(configuration: AudioTranscriberConfiguration) {
            model = configuration.model
            language = configuration.language
            task = configuration.task
            beamSize = configuration.beamSize
            temperature = configuration.temperature
            bestOf = .from(configuration.bestOf)
            conditionOnPreviousText = configuration.conditionOnPreviousText
            initialPrompt = .from(configuration.initialPrompt)
            threads = .from(configuration.threads)
        }

        func resolve(defaults: AudioTranscriberConfiguration) -> AudioTranscriberConfiguration {
            .init(
                model: model ?? defaults.model,
                language: language ?? defaults.language,
                task: task ?? defaults.task,
                beamSize: beamSize ?? defaults.beamSize,
                temperature: temperature ?? defaults.temperature,
                bestOf: bestOf.resolve(defaults.bestOf),
                conditionOnPreviousText: conditionOnPreviousText ?? defaults.conditionOnPreviousText,
                initialPrompt: initialPrompt.resolve(defaults.initialPrompt),
                threads: threads.resolve(defaults.threads)
            )
        }

        enum CodingKeys: String, CodingKey {
            case model
            case language
            case task
            case beamSize
            case temperature
            case bestOf
            case conditionOnPreviousText
            case initialPrompt
            case threads
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            model = try container.decodeIfPresent(AudioTranscriberConfiguration.Model.self, forKey: .model)
            language = try container.decodeIfPresent(AudioTranscriberConfiguration.Language.self, forKey: .language)
            task = try container.decodeIfPresent(AudioTranscriberConfiguration.Task.self, forKey: .task)
            beamSize = try container.decodeIfPresent(Int.self, forKey: .beamSize)
            temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
            bestOf = try container.decodeOptionalOverride(Int.self, forKey: .bestOf)
            conditionOnPreviousText = try container.decodeIfPresent(Bool.self, forKey: .conditionOnPreviousText)
            initialPrompt = try container.decodeOptionalOverride(String.self, forKey: .initialPrompt)
            threads = try container.decodeOptionalOverride(Int.self, forKey: .threads)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeOrNil(model, forKey: .model)
            try container.encodeOrNil(language, forKey: .language)
            try container.encodeOrNil(task, forKey: .task)
            try container.encodeOrNil(beamSize, forKey: .beamSize)
            try container.encodeOrNil(temperature, forKey: .temperature)
            try container.encodeOptionalOverride(bestOf, forKey: .bestOf)
            try container.encodeOrNil(conditionOnPreviousText, forKey: .conditionOnPreviousText)
            try container.encodeOptionalOverride(initialPrompt, forKey: .initialPrompt)
            try container.encodeOptionalOverride(threads, forKey: .threads)
        }
    }

    struct Renderer: Codable, Sendable {
        let resolution: VideoRendererResolution?
        let framesPerSecond: Double?
        let preRollPaddingSeconds: Double?
        let postRollPaddingSeconds: Double?
        let horizontalPadding: Int?
        let bottomPadding: Int?
        let outputFileExtension: String?

        init(
            resolution: VideoRendererResolution? = nil,
            framesPerSecond: Double? = nil,
            preRollPaddingSeconds: Double? = nil,
            postRollPaddingSeconds: Double? = nil,
            horizontalPadding: Int? = nil,
            bottomPadding: Int? = nil,
            outputFileExtension: String? = nil
        ) {
            self.resolution = resolution
            self.framesPerSecond = framesPerSecond
            self.preRollPaddingSeconds = preRollPaddingSeconds
            self.postRollPaddingSeconds = postRollPaddingSeconds
            self.horizontalPadding = horizontalPadding
            self.bottomPadding = bottomPadding
            self.outputFileExtension = outputFileExtension
        }

        init(configuration: VideoRendererConfiguration) {
            resolution = configuration.resolution
            framesPerSecond = configuration.framesPerSecond
            preRollPaddingSeconds = configuration.preRollPaddingSeconds
            postRollPaddingSeconds = configuration.postRollPaddingSeconds
            horizontalPadding = configuration.horizontalPadding
            bottomPadding = configuration.bottomPadding
            outputFileExtension = configuration.outputFileExtension
        }

        func resolve(defaults: VideoRendererConfiguration) -> VideoRendererConfiguration {
            .init(
                resolution: resolution ?? defaults.resolution,
                framesPerSecond: framesPerSecond ?? defaults.framesPerSecond,
                preRollPaddingSeconds: preRollPaddingSeconds ?? defaults.preRollPaddingSeconds,
                postRollPaddingSeconds: postRollPaddingSeconds ?? defaults.postRollPaddingSeconds,
                horizontalPadding: horizontalPadding ?? defaults.horizontalPadding,
                bottomPadding: bottomPadding ?? defaults.bottomPadding,
                outputFileExtension: outputFileExtension ?? defaults.outputFileExtension
            )
        }
    }
}

extension Configuration.Intermediate {
    enum OptionalOverride<Value: Codable & Sendable>: Sendable {
        case missing
        case null
        case value(Value)

        static func from(_ value: Value?) -> OptionalOverride<Value> {
            guard let value else {
                return .null
            }
            return .value(value)
        }

        func resolve(_ defaultValue: Value?) -> Value? {
            switch self {
            case .missing:
                return defaultValue
            case .null:
                return nil
            case .value(let value):
                return value
            }
        }
    }
}

private extension KeyedDecodingContainer {
    func decodeOptionalOverride<T: Codable & Sendable>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> Configuration.Intermediate.OptionalOverride<T> {
        guard contains(key) else {
            return .missing
        }
        if try decodeNil(forKey: key) {
            return .null
        }
        return .value(try decode(type, forKey: key))
    }
}

private extension KeyedEncodingContainer {
    mutating func encodeOrNil<T: Encodable>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value {
            try encode(value, forKey: key)
        } else {
            try encodeNil(forKey: key)
        }
    }

    mutating func encodeOptionalOverride<T: Encodable & Sendable>(
        _ value: Configuration.Intermediate.OptionalOverride<T>,
        forKey key: KeyedEncodingContainer<K>.Key
    ) throws {
        switch value {
        case .value(let value):
            try encode(value, forKey: key)
        case .missing, .null:
            try encodeNil(forKey: key)
        }
    }
}
