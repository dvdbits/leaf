import Foundation

class LeafDataManager: ObservableObject {
    @Published var items: [LeafItem] = []
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
                let decodedItems = try JSONDecoder().decode([LeafItem].self, from: data)
                DispatchQueue.main.async {
                    self.items = decodedItems
                }
            } else {
                // Create empty file if it doesn't exist
                saveItems()
            }
        } catch {
            print("Error loading items: \(error)")
            DispatchQueue.main.async {
                self.items = []
            }
        }
    }
    
    func saveItems() {
        let fileURL = getFileURL()
        
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL)
        } catch {
            print("Error saving items: \(error)")
        }
    }
    
    func addItem(_ item: LeafItem) {
        items.append(item)
        saveItems()
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