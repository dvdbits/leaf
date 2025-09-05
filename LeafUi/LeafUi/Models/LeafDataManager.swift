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
    
    func exportData() -> Data? {
        let leafData = LeafData(version: version, items: items)
        return try? JSONEncoder().encode(leafData)
    }
    
    func exportDataAsString() -> String? {
        guard let data = exportData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func importData(from url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            
            // Try to decode as new format first
            do {
                let leafData = try JSONDecoder().decode(LeafData.self, from: data)
                DispatchQueue.main.async {
                    self.items = leafData.items
                    self.version = leafData.version
                }
                saveItems()
                return true
            } catch {
                // If that fails, try to decode as old array format
                let importedItems = try JSONDecoder().decode([LeafItem].self, from: data)
                print("Importing from old format, converting to new versioned format...")
                
                DispatchQueue.main.async {
                    self.items = importedItems
                    self.version = "1.0.0"
                }
                saveItems()
                return true
            }
        } catch {
            print("Error importing data: \(error)")
            return false
        }
    }
    
    func importDataAndMerge(from url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            var importedItems: [LeafItem] = []
            
            // Try to decode as new format first
            do {
                let leafData = try JSONDecoder().decode(LeafData.self, from: data)
                importedItems = leafData.items
            } catch {
                // If that fails, try to decode as old array format
                importedItems = try JSONDecoder().decode([LeafItem].self, from: data)
            }
            
            // Merge imported items with existing items
            var mergedItems = items
            var addedCount = 0
            
            for importedItem in importedItems {
                // Check if item with same alias already exists
                if !items.contains(where: { $0.alias == importedItem.alias && !importedItem.alias.isEmpty }) {
                    mergedItems.append(importedItem)
                    addedCount += 1
                }
            }
            
            DispatchQueue.main.async {
                self.items = mergedItems
            }
            saveItems()
            
            print("Import completed: \(addedCount) new items added")
            return true
            
        } catch {
            print("Error importing and merging data: \(error)")
            return false
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