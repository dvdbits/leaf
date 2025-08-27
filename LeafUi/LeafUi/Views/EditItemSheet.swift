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
        let trimmedAlias = editedAlias.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedAlias.isEmpty || !existingAliases.contains(trimmedAlias)
    }
    
    private var canSave: Bool {
        !editedData.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isAliasValid
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Item")
                .font(.headline)
            
            TextEditor(text: $editedData)
                .frame(width: 300, height: 120)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(nsColor: .textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
                )
                .overlay(
                    Group {
                        if editedData.isEmpty {
                            Text("Enter item text")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
                .onTapGesture {
                    // This helps with focus management
                }
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Enter alias (optional)", text: $editedAlias)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 32)
                
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
        .frame(width: 350, height: 320)
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