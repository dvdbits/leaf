import Foundation

class DataManager {
    private let fileURL: URL
    
    init() {
        let containerPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library")
            .appendingPathComponent("Containers")
            .appendingPathComponent("dvdbits.LeafUi")
            .appendingPathComponent("Data")
            .appendingPathComponent("Documents")
            .appendingPathComponent("leaf.json")
        
        self.fileURL = containerPath
    }
    
    func getItem(for alias: String) -> LeafItem? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Error: leaf.json file not found at \(fileURL.path)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode([LeafItem].self, from: data)
            
            return items.first { $0.alias == alias }
        } catch {
            print("Error reading leaf.json: \(error)")
            return nil
        }
    }
    
    func getAllItems() -> [LeafItem] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([LeafItem].self, from: data)
        } catch {
            print("Error reading leaf.json: \(error)")
            return []
        }
    }
} 