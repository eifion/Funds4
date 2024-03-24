import SwiftUI

@main
struct Funds4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Fund.self)
    }
}
