import Foundation

class CommandRunner {
    
    /// Executes a shell command, replacing the current process (terminal handles I/O & signals)
    /// - Parameter commandText: The full command as a string, e.g., "npm run start"
    static func run(commandText: String) {
        // Split the command into executable + arguments
        let components = commandText.split(separator: " ").map { String($0) }
        guard let executable = components.first else {
            print("Invalid command")
            return
        }
        
        // Convert to C strings for execvp
        var argv: [UnsafeMutablePointer<CChar>?] = components.map { strdup($0) }
        argv.append(nil)
        
        // Execute the command, replacing the current process
        execvp(executable, argv)
        
        // If execvp returns, an error occurred
        perror("execvp failed")
        
        // Free strdup memory (not strictly needed here because process is replaced)
        for arg in argv {
            free(arg)
        }
    }
}
