import Foundation

struct LeafData: Codable {
    let version: String
    var items: [LeafItem]
    
    init(version: String = "1.0.0", items: [LeafItem] = []) {
        self.version = version
        self.items = items
    }
} 