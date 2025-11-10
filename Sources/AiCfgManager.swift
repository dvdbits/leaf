import Foundation


final class AiCfgManager {
    private static var aiCfgFileURL: URL {
        let folder = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(environment.rawValue, isDirectory: true)
        // Ensure folder exists
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("ai-cfg.json")
    }

    public struct AiCfg: Codable {
        public var model: String?
        public var temperature: Double?
        public var endpoint: String?
        public var apiKey: String?
    }

    public static func readAiCfg() throws -> AiCfg? {
        guard FileManager.default.fileExists(atPath: self.aiCfgFileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: self.aiCfgFileURL)
        let aiCfg = try JSONDecoder().decode(AiCfg.self, from: data)
        return aiCfg
    }

    public static func writeAiCfg<Value: Codable>(
        keyPath: WritableKeyPath<AiCfg, Value?>,
        value: Value?
    ) throws {
        var aiCfg = try readAiCfg() ?? AiCfg()
        aiCfg[keyPath: keyPath] = value
        let data = try JSONEncoder().encode(aiCfg)
        try data.write(to: aiCfgFileURL)
    }
}