import SwiftUI

struct AddItemSheet: View {
    @Binding var isPresented: Bool
    @State private var newItemText = ""
    @State private var newItemAlias = ""
    let onAdd: (LeafItem) -> Void
    let existingAliases: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.headline)
            
            TextField("Enter item text", text: $newItemText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Enter alias (optional)", text: $newItemAlias)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                
                HStack {
                    if !newItemAlias.isEmpty && existingAliases.contains(newItemAlias) {
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
                    isPresented = false
                    newItemText = ""
                    newItemAlias = ""
                }
                .buttonStyle(.bordered)
                
                Button("Add") {
                    if !newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let item = LeafItem(
                            data: newItemText.trimmingCharacters(in: .whitespacesAndNewlines),
                            alias: newItemAlias.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        onAdd(item)
                        isPresented = false
                        newItemText = ""
                        newItemAlias = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || 
                         (!newItemAlias.isEmpty && existingAliases.contains(newItemAlias)))
            }
        }
        .padding(20)
        .frame(width: 350, height: 220)
    }
}

#Preview {
    AddItemSheet(
        isPresented: .constant(true),
        onAdd: { _ in },
        existingAliases: ["existing", "test"]
    )
} 