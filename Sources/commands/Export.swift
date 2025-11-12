import ArgumentParser
import Foundation

struct Export: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Export commands to a file."
    )

    func run() throws {
        do {
            let commandsDict = try CommandManager.readCommands()
            
            guard !commandsDict.isEmpty else {
                print("❌ Error: No commands to export.")
                return
            }
            
            var commands = Commands()
            commands.items = commandsDict
            
            try IOFileManager.writeCommands(commands)
            print("✅ Successfully exported \(commandsDict.count) command(s).")
        } catch {
            print("❌ Error exporting commands: \(error.localizedDescription)")
        }
    }
}

