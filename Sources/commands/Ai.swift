import ArgumentParser
import Foundation

struct Ai: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Ask the AI to generate a command."
    )

    @Argument(help: "The prompt to ask the AI.")
    var prompt: String

    func run() async throws {
        var command: String?
        
        print("\(blue)Thinking...\(reset)")
        do {
            command = try await generateCommand(prompt: prompt)
        } catch {
            print("\(red)❌ All attempts failed.\(reset)")
            print("Last error: \(error.localizedDescription)")
            return
        }

        if confirmRun(command: command!) {
            CommandRunner.run(commandText: command!)
        } 
    }

    func generateCommand(prompt: String) async throws -> String {
        let llmClient = LLMClient()
        let maxRetries = 3
        var lastError: Error?
        var command: String? = nil
        
        for attempt in 1...maxRetries {            
            do {
                let responseText = try await llmClient.sendPrompt(prompt: prompt)
                let commandJSON = extractJSON(from: responseText)
                if commandJSON != nil {
                    command = commandJSON?["command"]
                    break
                }
            } catch {
                lastError = error
                print("Attempt \(attempt) failed, retrying...")
            }
            
            if attempt < maxRetries {
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            }
        }

        if command == nil {
            throw lastError!
        }

        return command!
    }

    func confirmRun(command: String) -> Bool {
        print("\(yellow)Leaf wants to run: '\(command)'. Proceed? (y/n) \(reset)", terminator: "")
        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return false
        }
        return input == "y" || input == "yes"
    }
}