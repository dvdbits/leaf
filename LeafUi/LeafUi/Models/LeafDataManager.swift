import Foundation

class LeafDataManager: ObservableObject {
    @Published var items: [LeafItem] = []
    @Published var version: String = "1.0.0"
    private let fileName = "leaf.json"
    
    init() {
        loadItems()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    func loadItems() {
        let fileURL = getFileURL()
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                
                // Try to decode as new format first
                do {
                    let leafData = try JSONDecoder().decode(LeafData.self, from: data)
                    DispatchQueue.main.async {
                        self.items = leafData.items
                        self.version = leafData.version
                    }
                } catch {
                    // If that fails, try to decode as old array format
                    let items = try JSONDecoder().decode([LeafItem].self, from: data)
                    print("Migrating from old format to new versioned format...")
                    
                    DispatchQueue.main.async {
                        self.items = items
                        self.version = "1.0.0"
                    }
                    
                    // Save the migrated data
                    saveItems()
                    print("Migration completed successfully!")
                }
            } else {
                // Create empty file if it doesn't exist
                saveItems()
            }
        } catch {
            print("Error loading items: \(error)")
            DispatchQueue.main.async {
                self.items = []
                self.version = "1.0.0"
            }
        }
    }
    
    func saveItems() {
        let fileURL = getFileURL()
        
        do {
            let leafData = LeafData(version: version, items: items)
            let data = try JSONEncoder().encode(leafData)
            try data.write(to: fileURL)
        } catch {
            print("Error saving items: \(error)")
        }
    }
    
    func addItem(_ item: LeafItem) {
        items.append(item)
        saveItems()
    }
    
    func isAliasUnique(_ alias: String, excludingItemId: UUID? = nil) -> Bool {
        if alias.isEmpty { return true }
        return !items.contains { item in
            item.alias == alias && item.id != excludingItemId
        }
    }
    
    func deleteItem(at index: Int) {
        guard index >= 0 && index < items.count else { return }
        items.remove(at: index)
        saveItems()
    }
    
    func updateItem(_ item: LeafItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
} 