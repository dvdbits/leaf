import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = LeafDataManager()
    
    var body: some View {
        ZStack {
            Color(nsColor: .white)
                .ignoresSafeArea()
            
            NavigationStack {
                ItemListView(
                    items: dataManager.items,
                    onDelete: { index in
                        dataManager.deleteItem(at: index)
                    },
                    onAdd: { newItem in
                        dataManager.addItem(newItem)
                    },
                    onUpdate: { updatedItem in
                        dataManager.updateItem(updatedItem)
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
