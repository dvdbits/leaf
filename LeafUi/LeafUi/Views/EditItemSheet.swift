import SwiftUI

struct EditItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedData: String = ""
    @State private var editedAlias: String = ""
    let item: LeafItem
    let onUpdate: (LeafItem) -> Void
    let existingAliases: [String]
    
    init(item: LeafItem, onUpdate: @escaping (LeafItem) -> Void, existingAliases: [String]) {
        self.item = item
        self.onUpdate = onUpdate
        self.existingAliases = existingAliases
    }
    
    private var isAliasValid: Bool {
        editedAlias.isEmpty || !existingAliases.contains(editedAlias) || editedAlias == item.alias
    }
    
    private var canSave: Bool {
        !editedData.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isAliasValid
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Item")
                .font(.headline)
            
            TextField("Enter item text", text: $editedData)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Enter alias (optional)", text: $editedAlias)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                
                HStack {
                    if !isAliasValid {
                        Text("Alias must be unique")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .frame(height: 16)
            }
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Save") {
                    let updatedItem = LeafItem(
                        id: item.id,
                        data: editedData.trimmingCharacters(in: .whitespacesAndNewlines),
                        alias: editedAlias.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    onUpdate(updatedItem)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)
            }
        }
        .padding(20)
        .frame(width: 350, height: 220)
        .onAppear {
            editedData = item.data
            editedAlias = item.alias
        }
    }
}

#Preview {
    EditItemSheet(
        item: LeafItem(data: "Sample item", alias: "sample"),
        onUpdate: { _ in },
        existingAliases: ["other", "another"]
    )
} 