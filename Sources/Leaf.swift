import ArgumentParser

enum CLIEnvironment: String {
    case dev = ".leaf-dev"
    case prod = ".leaf"
}

@main
struct Leaf: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "leaf",
        subcommands: [
            Run.self,
            List.self,
            Add.self,
            Delete.self,
            Edit.self,
            Show.self,
            Ai.self,
            AiCfg.self,
            Import.self,
            Export.self,
        ],
    )
}