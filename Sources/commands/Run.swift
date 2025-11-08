import ArgumentParser

struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Run a command."
    )

    @Argument(help: "The alias of the command to run.")
    var alias: String

    func run() throws {
        let commands = try CommandManager.readCommands()
        if let command = commands[alias] {
            CommandRunner.run(commandText: command)
        } else {
            print("Command '\(alias)' not found.")
        }
    }
}