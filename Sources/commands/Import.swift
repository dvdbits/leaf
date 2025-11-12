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
                print("❌ Error: The file at '\(path)' contains no commands to import.")
                return
            }
            
            try CommandManager.bulkAddCommands(importedCommands.items)
            print("✅ Successfully imported \(importedCommands.items.count) command(s).")
        } catch let error as NSError where error.domain == "IOFileManager" && error.code == 404 {
            print("❌ Error: File not found at path '\(path)'.")
        } catch let decodingError as DecodingError {
            print("❌ Error: Invalid JSON format in file '\(path)'. \(decodingError.localizedDescription)")
        } catch {
            print("❌ Error importing commands: \(error.localizedDescription)")
        }
    }
}

