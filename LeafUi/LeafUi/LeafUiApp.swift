import SwiftUI

@main
struct LeafUiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 400, height: 600)
    }
}
