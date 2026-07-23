import Testing
import Foundation
@testable import BabelLyrics

@Test func intermediateResolvesPartialValuesWithDefaults() throws {
    let json = """
    {
      "renderer": {
        "framesPerSecond": 30
      }
    }
    """

    let intermediate = try JSONDecoder().decode(
        Configuration.Intermediate.self,
        from: Data(json.utf8)
    )
    let resolved = intermediate.resolve()

    #expect(resolved.renderer.framesPerSecond == 30)
    #expect(resolved.renderer.renderSize.width == 1920)
    #expect(resolved.renderer.renderSize.height == 1080)
    #expect(resolved.segmenter.silenceThresholdDecibels == -35)
}

@Test func intermediateTreatsExplicitNullAsOverride() throws {
    let json = """
    {
      "splitter": {
        "segment": null,
        "overlap": null
      }
    }
    """

    let intermediate = try JSONDecoder().decode(
        Configuration.Intermediate.self,
        from: Data(json.utf8)
    )
    let resolved = intermediate.resolve()

    #expect(resolved.splitter.segment == nil)
    #expect(resolved.splitter.overlap == nil)
}

@Test func intermediateExportIncludesNilProperties() throws {
    let config = Configuration()
    let intermediate = Configuration.Intermediate(configuration: config)
    let data = try JSONEncoder().encode(intermediate)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    let splitter = json?["splitter"] as? [String: Any]
    let transcriber = json?["transcriber"] as? [String: Any]

    #expect(splitter?["jobs"] is NSNull)
    #expect(splitter?["shifts"] is NSNull)
    #expect(transcriber?["bestOf"] is NSNull)
    #expect(transcriber?["initialPrompt"] is NSNull)
    #expect(transcriber?["threads"] is NSNull)
}

@Test func intermediateCanBeInitializedFromExistingConfiguration() {
    let config = Configuration(
        renderer: .init(
            framesPerSecond: 29.97,
            outputFileExtension: "mp4"
        )
    )

    let intermediate = Configuration.Intermediate(configuration: config)
    let resolved = intermediate.resolve()

    #expect(resolved.renderer.framesPerSecond == 29.97)
    #expect(resolved.renderer.outputFileExtension == "mp4")
}
