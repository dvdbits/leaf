import SwiftUI

struct ItemListView: View {
    let items: [LeafItem]
    let onDelete: (Int) -> Void
    let onAdd: (LeafItem) -> Void
    let onUpdate: (LeafItem) -> Void
    let onExport: () -> Void
    let onImport: () -> Void
    @State private var copiedIndex: Int? = nil
    @State private var showingAddSheet = false
    @State private var itemToEdit: LeafItem? = nil
    @State private var itemToDelete: LeafItem? = nil
    
    private func copyToClipboard(_ item: LeafItem, at index: Int) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.data, forType: .string)
        
        copiedIndex = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            copiedIndex = nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with centered Add button
            HStack {
                Spacer()
                
                Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                }
                .buttonStyle(PlainButtonStyle())
                .help("Add new item")
                
                Spacer()
            }
            .padding(.vertical, 16)
            .background(Color(nsColor: .controlBackgroundColor))
            
            // List of items (main content area)
            List {
                ForEach(items.indices, id: \.self) { index in
                HStack(alignment: .center, spacing: 12) {
                    Button(action: {
                        copyToClipboard(items[index], at: index)
                    }) {
                        Image(systemName: "doc.on.clipboard")
                            .foregroundColor(copiedIndex == index ? .green : .blue)
                            .font(.system(size: 18))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(items[index].data.count > 100 ? String(items[index].data.prefix(100)) + "..." : items[index].data)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if !items[index].alias.isEmpty {
                            Text(items[index].alias.count > 20 ? String(items[index].alias.prefix(20)) + "..." : items[index].alias)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        itemToEdit = items[index]
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 30)
                    
                    Button(action: {
                        itemToDelete = items[index]
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 30)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        
        // Bottom bar with Import and Export buttons
        HStack(spacing: 20) {
            Spacer()
            
            // Import button
            Button(action: {
                onImport()
            }) {
                Image(systemName: "square.and.arrow.down")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            .help("Import JSON")
            
            // Export button
            Button(action: {
                onExport()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.green)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            .help("Export JSON")
            
            Spacer()
        }
        .padding(.vertical, 16)
        .background(Color(nsColor: .controlBackgroundColor))
        }
        .sheet(isPresented: $showingAddSheet) {
            AddItemSheet(
                isPresented: $showingAddSheet,
                onAdd: onAdd,
                existingAliases: items.map { $0.alias }.filter { !$0.isEmpty }
            )
        }
        .sheet(item: $itemToEdit) { item in
            EditItemSheet(
                item: item,
                onUpdate: onUpdate,
                existingAliases: items.filter { $0.id != item.id }.map { $0.alias }.filter { !$0.isEmpty }
            )
        }
        .sheet(item: $itemToDelete) { item in
            DeleteConfirmationDialog(
                item: item,
                onConfirm: {
                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                        onDelete(index)
                    }
                }
            )
        }
    }
}

#Preview {
    ItemListView(
        items: [
            LeafItem(data: "Short", alias: "quick"),
            LeafItem(data: "Medium length item", alias: "medium"),
            LeafItem(data: "This is a much longer item that should wrap to multiple lines", alias: "long")
        ],
        onDelete: { _ in },
        onAdd: { _ in },
        onUpdate: { _ in },
        onExport: { },
        onImport: { }
    )
} 
