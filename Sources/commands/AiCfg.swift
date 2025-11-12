import ArgumentParser
import Foundation

struct AiCfg: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Configure the AI."
    )

    @Option(help: "The model to use.")
    var model: String?

    @Option(help: "The temperature to use.")
    var temperature: Double?

    @Option(help: "The endpoint to use.")
    var endpoint: String?

    @Option(help: "The API key to use.")
    var apiKey: String?

    func run() throws {
        var didUpdate = false

        if let model, !model.isEmpty {
            try AiCfgManager.writeAiCfg(keyPath: \.model, value: model)
            didUpdate = true
        }
        if let temperature {
            try AiCfgManager.writeAiCfg(keyPath: \.temperature, value: temperature)
            didUpdate = true
        }
        if let endpoint, !endpoint.isEmpty {
            try AiCfgManager.writeAiCfg(keyPath: \.endpoint, value: endpoint)
            didUpdate = true
        }
        if let apiKey, !apiKey.isEmpty {
            try AiCfgManager.writeAiCfg(keyPath: \.apiKey, value: apiKey)
            didUpdate = true
        }

        if !didUpdate {
            if let existingCfg = try AiCfgManager.readAiCfg() {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
                let data = try encoder.encode(existingCfg)
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                } else {
                    print("\(red)❌ Failed to encode AI configuration as UTF-8.\(reset)")
                }
            } else {
                print("\(yellow)No AI configuration set.\(reset)")
            }
        }
    }
}