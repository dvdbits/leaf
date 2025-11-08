import ArgumentParser

struct Leaf: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "leaf",
        subcommands: [Run.self, List.self, Add.self],
    )
}

Leaf.main()