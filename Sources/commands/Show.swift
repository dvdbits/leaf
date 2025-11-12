import ArgumentParser

struct Show: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Show the text stored for an alias."
    )

    @Argument(help: "The alias of the command to show.")
    var alias: String

    func run() throws {
        do {
            let commands = try CommandManager.readCommands()
            if let command = commands[alias] {
                print(command)
            } else {
                print("❌ Alias '\(alias)' does not exist.")
            }
        } catch {
            print("❌ Error reading commands: \(error)")
        }
    }
}

