import SwiftUI

struct ItemListView: View {
    let items: [String]
    let onDelete: (Int) -> Void
    let onAdd: (String) -> Void
    @State private var copiedIndex: Int? = nil
    @State private var showingAddSheet = false
    @State private var newItemText = ""
    
    private func copyToClipboard(_ text: String, at index: Int) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        
        copiedIndex = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            copiedIndex = nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Add button separated from list
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
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                Spacer()
            }
            .background(Color(nsColor: .controlBackgroundColor))
            
            // List of items
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
                    .frame(width: 20)
                    
                    Text(items[index])
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button(action: {
                        onDelete(index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 20)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showingAddSheet) {
            VStack(spacing: 20) {
                Text("Add New Item")
                    .font(.headline)
                
                TextField("Enter item text", text: $newItemText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        showingAddSheet = false
                        newItemText = ""
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Add") {
                        if !newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onAdd(newItemText.trimmingCharacters(in: .whitespacesAndNewlines))
                            showingAddSheet = false
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
}

#Preview {
    ItemListView(
        items: [
            "Short",
            "Medium length item",
            "This is a much longer item that should wrap to multiple lines"
        ],
        onDelete: { _ in },
        onAdd: { _ in }
    )
} 