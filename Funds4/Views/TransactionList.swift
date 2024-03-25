import SwiftData
import SwiftUI

struct TransactionList: View {
    @Binding var selectedTab: Int
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
    @Query(sort: \Transaction.startDate, order: .reverse) var transactions: [Transaction]
    
    @State private var overallBalance: String = "0.00"
    @State var showAddTransaction = false
            
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                       Text("Overall Balance:").bold()
                       Spacer()
                       Text(overallBalance)
                   }
                }
                
                if (transactions.isEmpty) {
                    Section {
                        Text("No transactions to display")
                    }
                }
                else {
                    Section {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction, onDismiss: updateOverallBalance) {
                let defaultFund = funds.first(where: { $0.isDefault })
                TransactionEditor(fund: defaultFund!, transactionToEdit: nil as Transaction?)
                    .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Transaction", systemImage: "plus") {
                        showAddTransaction = true
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
            self.selectedTab = 2;
            self.showAddFund = true
        }
        
        updateOverallBalance()
    }
    
    func updateOverallBalance() {
        funds.forEach{ fun in fun.calculateCurrentBalance() }
        overallBalance = funds.reduce(0) { $0 + $1.currentBalance }.asCurrency
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

