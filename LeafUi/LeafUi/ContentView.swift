import SwiftUI

struct ContentView: View {
    @State private var items = [
        "Short",
        "Medium length item",
        "This is a much longer item that should wrap to multiple lines when it doesn't fit on a single row",
        "Another short one",
        "This item has a moderate amount of text that might need to wrap depending on the screen size and available space",
        "Tiny",
        "A very long item with lots of descriptive text that will definitely need to wrap across multiple lines to display properly in the interface",
        "Quick",
        "This is an example of text that contains multiple sentences and should demonstrate how the interface handles longer content gracefully"
    ]
    
    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()
            
            NavigationStack {
                List {
                    ForEach(items.indices, id: \.self) { index in
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                                .frame(width: 20)
                            
                            Text(items[index])
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            Button(action: {
                                items.remove(at: index)
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
                .navigationTitle("Items")
                .frame(width: 400, height: 600)
            }
        }
    }
}

#Preview {
    ContentView()
}
