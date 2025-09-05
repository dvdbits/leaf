import SwiftUI

struct ImportOptionsSheet: View {
    @Binding var isPresented: Bool
    let onReplace: () -> Void
    let onMerge: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Import Options")
                .font(.headline)
            
            Text("How would you like to import the data?")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Replace All Data") {
                    onReplace()
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .frame(width: 200)
                
                Text("This will replace all your current items with the imported data")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button("Merge with Existing") {
                    onMerge()
                    isPresented = false
                }
                .buttonStyle(.bordered)
                .frame(width: 200)
                
                Text("This will add new items from the import, skipping duplicates")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Cancel") {
                isPresented = false
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding(20)
        .frame(width: 350, height: 300)
    }
}

#Preview {
    ImportOptionsSheet(
        isPresented: .constant(true),
        onReplace: { },
        onMerge: { }
    )
} 