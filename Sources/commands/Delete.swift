import ArgumentParser

struct Delete: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Delete a command by alias."
    )

    @Argument(help: "The alias of the command to delete.")
    var alias: String

    func run() throws {
        do {
            let deleted = try CommandManager.deleteCommand(alias: alias)
            if deleted {
                print("✅ Command '\(alias)' deleted successfully.")
            } else {
                print("❌ Alias '\(alias)' does not exist.")
            }
        } catch {
            print("❌ Error deleting command: \(error)")
        }
    }
}

