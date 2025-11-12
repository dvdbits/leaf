import ArgumentParser
import Foundation

struct Import: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Import commands from a file."
    )

    @Argument(help: "The path to the file to import.")
    var path: String

    func run() throws {
        do {
            let importedCommands = try IOFileManager.readCommands(from: path)
            
            guard !importedCommands.items.isEmpty else {
                print("\(red)❌ Error: The file at '\(path)' contains no commands to import.\(reset)")
                return
            }
            
            try CommandManager.bulkAddCommands(importedCommands.items)
            print("\(green)✅ Successfully imported \(importedCommands.items.count) command(s).\(reset)")
        } catch let error as NSError where error.domain == "IOFileManager" && error.code == 404 {
            print("\(red)❌ Error: File not found at path '\(path)'.\(reset)")
        } catch let decodingError as DecodingError {
            print("\(red)❌ Error: Invalid JSON format in file '\(path)'. \(decodingError.localizedDescription)\(reset)")
        } catch {
            print("\(red)❌ Error importing commands: \(error.localizedDescription)\(reset)")
        }
    }
}

