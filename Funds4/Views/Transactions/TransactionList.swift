import SwiftData
import SwiftUI

struct TransactionList: View {
    @AppStorage("LastDayUpdate") private var lastDayUpdate = 0
    
    @Binding var selectedTab: Int
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    
    @Query var funds: [Fund]
    @Query(sort: \Transaction.startDate, order: .reverse) var transactions: [Transaction]
        
    @State var showAddTransaction = false
    @State var showAddTransfer = false
    @State var transactionToEdit: Transaction?
    @State var chartViewModel: ChartViewModel = ChartViewModel()
    @State var groupedTransactions: [TransactionGroupViewModel] = []
            
    var body: some View {
        // Filter out the outgoing part of transfer transactions.
        NavigationView {
            ScrollView {
                VStack {
                    FundChart(chartViewModel: $chartViewModel)
                    
                    HStack {
                        Text("Transactions")
                            .font(.title)
                            .bold()
                            .padding(.vertical)
                        Spacer()
                    }
                    
                    ForEach($groupedTransactions.sorted(by: { $0.id < $1.id })) { group in
                        TransactionGroup(
                            group: group,
                            transactionToEdit: $transactionToEdit)
                    }
                }

            }
            .padding()
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
            .navigationTitle("Overview")
            .onAppear(perform: checkForFund)
            .onChange(of: scenePhase) {
                if (scenePhase == .active) {
                    updateOverallBalance()
                }
            }
        }
    }
    
    func checkForFund()
    {
        // If there are no funds on opening the app, switch to the Funds tab
        // so that one can be added.
        if (funds.isEmpty) {
            self.selectedTab = 2;
            self.showAddFund = true
        }
        // If this is the first time that the list is being displayed today, update the balances.
        let currentDayOfYear = Date.now.dayOfYear
        if lastDayUpdate != currentDayOfYear {
            updateOverallBalance()
            lastDayUpdate = currentDayOfYear
        }
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
        let groupedTransactionsDictionary = Dictionary(grouping: transactions.filter{ $0.amount > 0 || ($0.transferTransaction == nil && $0.amount < 0) }, by: {$0.orderedDisplayDate()})
        groupedTransactions = []
        groupedTransactionsDictionary.keys.forEach { key in
            
            let keyParts = key.components(separatedBy: "_")
            let transactions = groupedTransactionsDictionary[key] ?? []
            if (keyParts.count == 2 && transactions.count > 0) {
                groupedTransactions.append(TransactionGroupViewModel(
                    id: Int(keyParts[0], radix: 10) ?? 0,
                    title: keyParts[1],
                    transactions: groupedTransactionsDictionary[key] ?? []))
            }
        }
                        
        funds.forEach{ fun in fun.calculateCurrentBalance() }
        chartViewModel.funds = funds
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

