import Foundation

final class CommandManager {
    private static var commandsFileURL: URL {
        let folder = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(environment.rawValue, isDirectory: true)
        // Ensure folder exists
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("commands.json")
    }

    private struct Commands: Codable {
        var items: [String: String] = [:]
    }


    static func addCommand(alias: String, command: String) throws {
        var commands = Commands()
        
        if FileManager.default.fileExists(atPath: commandsFileURL.path) {
            let data = try Data(contentsOf: commandsFileURL)
            commands = try JSONDecoder().decode(Commands.self, from: data)
        }
        
        commands.items[alias] = command
        
        let data = try JSONEncoder().encode(commands)
        try data.write(to: commandsFileURL)
    }

    static func readCommands() throws -> [String: String] {
        guard FileManager.default.fileExists(atPath: commandsFileURL.path) else {
            return [:]
        }
        let data = try Data(contentsOf: commandsFileURL)
        let commands = try JSONDecoder().decode(Commands.self, from: data)
        return commands.items
    }
}
