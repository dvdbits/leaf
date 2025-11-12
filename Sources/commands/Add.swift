import ArgumentParser

struct Add: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Add a new command for a given alias."
    )

    @Argument(help: "The alias of the command to add.")
    var alias: String

    @Argument(help: "The command to add.")
    var command: String

    func run() throws {
        do {
            try CommandManager.addCommand(alias: alias, command: command)
            print("✅ Command '\(alias)' added successfully.")
        } catch {
            print("❌ Error adding command: \(error)")
        }
    }
}