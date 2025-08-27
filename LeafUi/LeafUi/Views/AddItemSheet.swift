import SwiftUI

struct AddItemSheet: View {
    @Binding var isPresented: Bool
    @State private var newItemText = ""
    @State private var newItemAlias = ""
    let onAdd: (LeafItem) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.headline)
            
            TextField("Enter item text", text: $newItemText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            TextField("Enter alias (optional)", text: $newItemAlias)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
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
                .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(20)
        .frame(width: 350, height: 200)
    }
}

#Preview {
    AddItemSheet(
        isPresented: .constant(true),
        onAdd: { _ in }
    )
} 