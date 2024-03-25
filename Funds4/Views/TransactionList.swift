import SwiftData
import SwiftUI

struct TransactionList: View {
    @Binding var selectedTab: Int
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
    @Query(sort: \Transaction.startDate, order: .reverse) var transactions: [Transaction]
            
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                       Text("Overall Balance:").bold()
                       Spacer()
                       Text(getOverallBalance())
                   }
                }
            }
        }
        .onAppear(perform: checkForFund)
    }
    
    func checkForFund()
    {
        // If there are no funds on opening the app, switch to the Funds tab
        // so that one can be added.
        if (funds.isEmpty) {
            print("No funds. Switching to Funds view and showing new fund sheet.")
            self.selectedTab = 2;
            self.showAddFund = true
        }
    }
    
    func getOverallBalance() -> String {
        funds.forEach{ fun in fun.calculateCurrentBalance() }
        return funds.reduce(0) { $0 + $1.currentBalance }.asCurrency
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TabView {
            TransactionList(selectedTab: .constant(1), showAddFund: .constant(false))
            .tabItem {
                Label("Transactions", systemImage: "arrow.up.arrow.down") }
        }
    }
}
