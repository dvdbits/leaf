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
        
        do {
            command = try await generateCommand(prompt: prompt)
        } catch let configError as LLMClient.LLMClientError {
            print("\(red)❌ \(configError.localizedDescription)\(reset)")
            return
        } catch {
            print("\(red)❌ All attempts failed.\(reset)")
            print("\(red)Error: \(error.localizedDescription)\(reset)")
            return
        }

        if confirmRun(command: command!) {
            CommandRunner.run(commandText: command!)
        } 
    }

    func generateCommand(prompt: String) async throws -> String {
        let llmClient = try LLMClient()
        let maxRetries = 3
        var lastError: Error?
        var command: String? = nil
        
        print("\(blue)Thinking...\(reset)")
        for attempt in 1...maxRetries {            
            do {
                let responseText = try await llmClient.sendPrompt(prompt: prompt)
                let commandJSON = extractJSON(from: responseText)
                if commandJSON != nil {
                    command = commandJSON?["command"]
                    break
                }
            } catch {
                if let configError = error as? LLMClient.LLMClientError {
                    throw configError
                }
                lastError = error
                print("\(yellow)Attempt \(attempt) failed, retrying...\(reset)")
            }
            
            if attempt < maxRetries {
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            }
        }

        guard let finalCommand = command else {
            if let lastError {
                throw lastError
            } else {
                throw NSError(domain: "AiCommand", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to interpret AI response."])
            }
        }

        return finalCommand
    }

    func confirmRun(command: String) -> Bool {
        print("\(yellow)Leaf wants to run: '\(command)'. Proceed? (y/n) \(reset)", terminator: "")
        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return false
        }
        return input == "y" || input == "yes"
    }
}