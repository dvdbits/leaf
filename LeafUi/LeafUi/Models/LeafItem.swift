import Foundation

struct LeafItem: Identifiable, Codable, Equatable {
    let id: UUID
    let data: String
    let alias: String
    
    init(data: String, alias: String = "") {
        self.id = UUID()
        self.data = data
        self.alias = alias
    }
    
    init(id: UUID, data: String, alias: String) {
        self.id = id
        self.data = data
        self.alias = alias
    }
} 