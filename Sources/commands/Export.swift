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
                print("\(red)❌ Error: No commands to export.\(reset)")
                return
            }
            
            var commands = Commands()
            commands.items = commandsDict
            
            try IOFileManager.writeCommands(commands)
            print("\(green)✅ Successfully exported \(commandsDict.count) command(s).\(reset)")
        } catch {
            print("\(red)❌ Error exporting commands: \(error.localizedDescription)\(reset)")
        }
    }
}

