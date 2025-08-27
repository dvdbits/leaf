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
            Color(nsColor: .white)
                .ignoresSafeArea()
            
            NavigationStack {
                ItemListView(
                    items: items,
                    onDelete: { index in
                        items.remove(at: index)
                    },
                    onAdd: { newText in
                        items.append(newText)
                    }
                )
                .navigationTitle("Items")
                .frame(
                    minWidth: 400,
                    idealWidth: 400 ,
                    minHeight: 600,
                    idealHeight: 600
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
