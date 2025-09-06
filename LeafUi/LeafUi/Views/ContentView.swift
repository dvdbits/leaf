import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = LeafDataManager()
    @State private var showingExportDialog = false
    @State private var showingImportDialog = false
    @State private var showingImportOptions = false
    @State private var selectedImportURL: URL?
    
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
                    },
                    onExport: {
                        exportData()
                    },
                    onImport: {
                        importData()
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
        .sheet(isPresented: $showingImportOptions) {
            ImportOptionsSheet(
                isPresented: $showingImportOptions,
                onReplace: {
                    if let url = selectedImportURL {
                        let success = dataManager.importData(from: url)
                        if success {
                            print("Data replaced successfully")
                        } else {
                            print("Failed to replace data")
                        }
                    }
                },
                onMerge: {
                    if let url = selectedImportURL {
                        let success = dataManager.importDataAndMerge(from: url)
                        if success {
                            print("Data merged successfully")
                        } else {
                            print("Failed to merge data")
                        }
                    }
                }
            )
        }
    }
    
    private func exportData() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "leaf-export.json"
        panel.allowedContentTypes = [.json]
        panel.title = "Export Leaf Data"
        panel.message = "Choose where to save your Leaf data export"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                guard let data = dataManager.exportData() else {
                    print("Failed to export data")
                    return
                }
                
                do {
                    try data.write(to: url)
                    print("Data exported successfully to: \(url.path)")
                } catch {
                    print("Failed to write export file: \(error)")
                }
            }
        }
    }
    
    private func importData() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.title = "Import Leaf Data"
        panel.message = "Choose a JSON file to import"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                selectedImportURL = url
                showingImportOptions = true
            }
        }
    }
}

#Preview {
    ContentView()
}
