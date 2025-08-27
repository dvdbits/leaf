import Foundation

class CommandExecutor {
    func execute(_ command: String) -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            // Read output
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
                print(output)
            }
            
            // Read errors
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
                print("Error: \(error)")
            }
            
            return process.terminationStatus
        } catch {
            print("Error executing command: \(error)")
            return 1
        }
    }
} 