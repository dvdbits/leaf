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
                print("\(green)✅ Command '\(alias)' deleted successfully.\(reset)")
            } else {
                print("\(red)❌ Alias '\(alias)' does not exist.\(reset)")
            }
        } catch {
            print("\(red)❌ Error deleting command: \(error)\(reset)")
        }
    }
}

