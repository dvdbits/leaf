import Foundation

class LeafCLI {
    private let dataManager = DataManager()
    private let commandExecutor = CommandExecutor()
    
    func run() {
        let arguments = CommandLine.arguments
        
        guard arguments.count >= 2 else {
            printUsage()
            exit(1)
        }
        
        let command = arguments[1]
        
        switch command {
        case "run":
            guard arguments.count >= 3 else {
                print("Error: Missing alias for 'run' command")
                print("Usage: leaf run <alias>")
                exit(1)
            }
            executeCommand(for: arguments[2])
            
        case "list":
            listAllItems()
            
        case "show":
            guard arguments.count >= 3 else {
                print("Error: Missing alias for 'show' command")
                print("Usage: leaf show <alias>")
                exit(1)
            }
            showItem(for: arguments[2])
            
        case "help":
            printUsage()
            
        default:
            print("Error: Unknown command '\(command)'")
            printUsage()
            exit(1)
        }
    }
    
    private func executeCommand(for alias: String) {
        guard let item = dataManager.getItem(for: alias) else {
            print("Error: No item found with alias '\(alias)'")
            exit(1)
        }
        
        print("Executing command for alias '\(alias)':")
        print("Command: \(item.data)")
        print("Mode: Interactive streaming (use Ctrl+C to terminate)")
        print("---")
        
        // Set up signal handling for graceful termination
        setupSignalHandling()
        
        // Always use interactive streaming
        let exitCode = commandExecutor.executeWithStreaming(item.data, interactive: true)
        
        if exitCode != 0 {
            print("\nCommand exited with code: \(exitCode)")
            exit(exitCode)
        }
    }
    
    private func setupSignalHandling() {
        // Handle Ctrl+C gracefully
        signal(SIGINT) { _ in
            print("\n\nReceived interrupt signal. Terminating...")
            exit(0)
        }
        
        // Handle termination signal
        signal(SIGTERM) { _ in
            print("\n\nReceived termination signal. Terminating...")
            exit(0)
        }
    }
    
    private func showItem(for alias: String) {
        guard let item = dataManager.getItem(for: alias) else {
            print("Error: No item found with alias '\(alias)'")
            exit(1)
        }
        
        print("Alias: \(item.alias)")
        print("Data: \(item.data)")
    }
    
    private func listAllItems() {
        let items = dataManager.getAllItems()
        
        if items.isEmpty {
            print("No items found in leaf.json")
            return
        }
        
        print("Available aliases:")
        print("---")
        
        for item in items.sorted(by: { $0.alias < $1.alias }) {
            let truncatedData = item.data.count > 50 ? String(item.data.prefix(50)) + "..." : item.data
            print("\(item.alias): \(truncatedData)")
        }
    }
    
    private func printUsage() {
        print("""
        Leaf CLI - Execute commands stored in your Leaf app
        
        Usage:
            leaf run <alias>     Execute the command with interactive streaming
            leaf show <alias>    Show the command associated with the alias
            leaf list           List all available aliases
            leaf help           Show this help message
        
        Examples:
            leaf run my-script
            leaf show my-script
            leaf list
        """)
    }
} 