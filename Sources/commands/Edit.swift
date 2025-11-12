import ArgumentParser

struct Edit: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Rename an alias."
    )

    @Argument(help: "The current alias to rename.")
    var oldAlias: String

    @Argument(help: "The new alias name.")
    var newAlias: String

    func run() throws {
        do {
            let renamed = try CommandManager.renameAlias(oldAlias: oldAlias, newAlias: newAlias)
            if renamed {
                print("✅ Alias '\(oldAlias)' renamed to '\(newAlias)' successfully.")
            } else {
                print("❌ Alias '\(oldAlias)' does not exist.")
            }
        } catch {
            print("❌ Error renaming alias: \(error)")
        }
    }
}

