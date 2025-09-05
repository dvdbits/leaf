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
    
    private func loadData() -> LeafData? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            // Try to decode as new format first
            do {
                let leafData = try JSONDecoder().decode(LeafData.self, from: data)
                return leafData
            } catch {
                // If that fails, try to decode as old array format
                let items = try JSONDecoder().decode([LeafItem].self, from: data)
                print("Migrating from old format to new versioned format...")
                
                // Create new format with migrated data
                let migratedData = LeafData(version: "1.0.0", items: items)
                
                // Save the migrated data
                try saveData(migratedData)
                print("Migration completed successfully!")
                
                return migratedData
            }
        } catch {
            print("Error reading leaf.json: \(error)")
            return nil
        }
    }
    
    private func saveData(_ leafData: LeafData) throws {
        let data = try JSONEncoder().encode(leafData)
        try data.write(to: fileURL)
    }
    
    func getItem(for alias: String) -> LeafItem? {
        guard let leafData = loadData() else {
            print("Error: leaf.json file not found at \(fileURL.path)")
            return nil
        }
        
        return leafData.items.first { $0.alias == alias }
    }
    
    func getAllItems() -> [LeafItem] {
        guard let leafData = loadData() else {
            return []
        }
        
        return leafData.items
    }
} 