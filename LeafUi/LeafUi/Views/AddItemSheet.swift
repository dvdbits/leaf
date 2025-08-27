import SwiftUI

struct AddItemSheet: View {
    @Binding var isPresented: Bool
    @State private var newItemText = ""
    let onAdd: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.headline)
            
            TextField("Enter item text", text: $newItemText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                    newItemText = ""
                }
                .buttonStyle(.bordered)
                
                Button("Add") {
                    if !newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        onAdd(newItemText.trimmingCharacters(in: .whitespacesAndNewlines))
                        isPresented = false
                        newItemText = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(20)
        .frame(width: 350, height: 150)
    }
}

#Preview {
    AddItemSheet(
        isPresented: .constant(true),
        onAdd: { _ in }
    )
} 