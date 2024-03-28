import SwiftData
import SwiftUI

struct TransactionList: View {
    @Binding var selectedTab: Int
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
    @Query(sort: \Transaction.startDate, order: .reverse) var transactions: [Transaction]
    
    @State private var overallBalance = 0
    @State var showAddTransaction = false
    @State var showAddTransfer = false
    @State var transactionToEdit: Transaction?
            
    var body: some View {
        // Filter out the outgoing part of transfer transactions.
        let filteredTransactions = transactions.filter{ $0.amount > 0 || ($0.transferTransaction == nil && $0.amount < 0) }
        let groupedTransactions = Dictionary(grouping: filteredTransactions, by: {$0.orderedDisplayDate()})
        
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: FundStatistics(), label: {
                        BalanceRow(text: "Overall balance:", amount: overallBalance)
                    })
                }
                
                if (transactions.isEmpty) {
                    Section {
                        Text("No transactions to display")
                    }
                }
                else {
                    ForEach(groupedTransactions.sorted(by: { $0.key < $1.key }), id: \.key) { group in
                        TransactionDaySection(
                           date: group.key,
                           transactions: group.value,
                           delete: self.deleteTransaction(_:),
                           transactionToEdit: $transactionToEdit)
                   }
                }
            }
            .sheet(isPresented: $showAddTransaction, onDismiss: updateOverallBalance) {
                let defaultFund = funds.first(where: { $0.isDefault })
                TransactionEditor(fund: defaultFund!, transactionToEdit: nil as Transaction?)
                    .presentationDetents([.medium])
            }
            .sheet(item: $transactionToEdit, onDismiss: updateOverallBalance) { item in
                TransactionEditor(fund: item.fund!, transactionToEdit: item)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAddTransfer, onDismiss: updateOverallBalance) {
                TransferEditor()
                    .presentationDetents([.medium])
            }
            .toolbar {
                if (funds.count > 1) {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add Transaction", systemImage: "arrow.left.arrow.right") {
                            showAddTransfer = true
                        }
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Transaction", systemImage: "plus") {
                        showAddTransaction = true
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Transactions")
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
    
    private func deleteTransaction(_ transaction: Transaction) {  
        // If this is a transfer we need to delete both transactions.
        let transferTransaction = transactions.first { t in t.transferTransaction?.id == transaction.id }
        if let transferTransaction = transferTransaction {
            modelContext.delete(transferTransaction)
        }
        
        // Now delete the transaction itself and update the balances.
        modelContext.delete(transaction)
        updateOverallBalance()
    }

    func updateOverallBalance() {
        funds.forEach{ fun in fun.calculateCurrentBalance() }                        
        overallBalance = funds.reduce(0) { $0 + $1.currentBalance }
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

