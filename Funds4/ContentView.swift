import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TransactionList(selectedTab: $selectedTab)
                .tabItem { Label("Transactions", systemImage: "arrow.up.arrow.down") }
                .tag(1)
            FundList()
                .tabItem { Label("Funds", systemImage: "sterlingsign") }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
