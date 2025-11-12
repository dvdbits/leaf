import ArgumentParser

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List all commands."
    )

    func run() throws {
        let commands = try CommandManager.readCommands()
        for (alias, command) in commands.sorted(by: { $0.key < $1.key }) {
            print("\(alias): \(command)")
        }
    }
}