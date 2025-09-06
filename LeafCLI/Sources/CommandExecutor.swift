import Foundation

class CommandExecutor {
    private var isRunning = false
    private var process: Process?
    private var inputQueue = DispatchQueue(label: "input.queue", qos: .userInteractive)
    
    func execute(_ command: String) -> Int32 {
        return executeWithStreaming(command, interactive: true)
    }
    
    func executeWithStreaming(_ command: String, interactive: Bool = true) -> Int32 {
        let process = Process()
        self.process = process
        
        // Configure process
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        
        // Set up pipes for output and error
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        let inputPipe = Pipe()
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        process.standardInput = inputPipe
        
        // Set up streaming for stdout
        setupStreaming(for: outputPipe.fileHandleForReading, isError: false)
        
        // Set up streaming for stderr
        setupStreaming(for: errorPipe.fileHandleForReading, isError: true)
        
        // Set up interactive input if requested
        if interactive {
            setupInteractiveInput(inputPipe.fileHandleForWriting)
        }
        
        do {
            isRunning = true
            try process.run()
            
            // Wait for process to complete
            process.waitUntilExit()
            isRunning = false
            
            return process.terminationStatus
        } catch {
            print("Error executing command: \(error)")
            isRunning = false
            return 1
        }
    }
    
    private func setupStreaming(for fileHandle: FileHandle, isError: Bool) {
        fileHandle.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if !data.isEmpty {
                if let output = String(data: data, encoding: .utf8) {
                    // Print immediately for real-time streaming
                    if isError {
                        fputs(output, stderr)
                    } else {
                        print(output, terminator: "")
                        fflush(stdout)
                    }
                }
            } else {
                // End of file
                handle.readabilityHandler = nil
            }
        }
    }
    
    private func setupInteractiveInput(_ inputHandle: FileHandle) {
        // Set up a background queue to handle user input
        inputQueue.async { [weak self] in
            while self?.isRunning == true {
                // Read from stdin and forward to the process
                if let input = readLine() {
                    let inputData = (input + "\n").data(using: .utf8)
                    inputHandle.write(inputData ?? Data())
                }
            }
        }
    }
    
    func terminate() {
        process?.terminate()
        isRunning = false
    }
    
    func isProcessRunning() -> Bool {
        return isRunning
    }
} 