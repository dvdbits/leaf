import Foundation

final class IOFileManager {

    static func readCommands(from filePath: String) throws -> Commands {
        let fileURL = URL(fileURLWithPath: filePath)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw NSError(
                domain: "IOFileManager",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File not found at path: \(filePath)"]
            )
        }
        
        let data = try Data(contentsOf: fileURL)
        let commands = try JSONDecoder().decode(Commands.self, from: data)
        return commands
    }
    
    static func writeCommands(_ commands: Commands) throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let fileURL = URL(fileURLWithPath: currentDirectory)
            .appendingPathComponent("leaf.json")
        
        let data = try JSONEncoder().encode(commands)
        try data.write(to: fileURL)
    }
}