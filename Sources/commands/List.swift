import ArgumentParser

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List all commands."
    )

    func run() throws {
        let commands = try CommandManager.readCommands()
        for (alias, command) in commands {
            print("\(alias): \(command)")
        }
    }
}