import SwiftData
import SwiftDate
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedTab = 1
    @State private var showAddFund = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TransactionList(selectedTab: $selectedTab, showAddFund: $showAddFund)
                .tabItem { Label("Transactions", systemImage: "arrow.up.arrow.down") }
                .tag(1)
            FundList(showAddFund: $showAddFund)
                .tabItem { Label("Funds", systemImage: "sterlingsign") }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
