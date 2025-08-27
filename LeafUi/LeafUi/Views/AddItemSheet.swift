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
            
            TextEditor(text: $newItemText)
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
                        if newItemText.isEmpty {
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
                TextField("Enter alias (optional)", text: $newItemAlias)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 32)
                
                HStack {
                                if !newItemAlias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && existingAliases.contains(newItemAlias.trimmingCharacters(in: .whitespacesAndNewlines)) {
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
                         (!newItemAlias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && existingAliases.contains(newItemAlias.trimmingCharacters(in: .whitespacesAndNewlines))))
            }
        }
        .padding(20)
        .frame(width: 350, height: 320)
    }
}

#Preview {
    AddItemSheet(
        isPresented: .constant(true),
        onAdd: { _ in },
        existingAliases: ["existing", "test"]
    )
} 