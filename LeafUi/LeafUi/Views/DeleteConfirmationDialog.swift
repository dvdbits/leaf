import SwiftUI

struct DeleteConfirmationDialog: View {
    @Environment(\.dismiss) private var dismiss
    let item: LeafItem
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 40))
            
            Text("Delete Item")
                .font(.headline)
            
            Text("Are you sure you want to delete this item?")
                .font(.body)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Data: \(item.data)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !item.alias.isEmpty {
                    Text("Alias: \(item.alias)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Delete") {
                    onConfirm()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        .padding(20)
        .frame(width: 350, height: 280)
    }
}

#Preview {
    DeleteConfirmationDialog(
        item: LeafItem(data: "Sample item to delete", alias: "sample"),
        onConfirm: {}
    )
} 