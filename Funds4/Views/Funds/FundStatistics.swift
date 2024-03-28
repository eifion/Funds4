import SwiftData
import SwiftUI

struct FundStatistics: View {
    @Query var funds: [Fund]    
    
    @State var openingBalance = 0
    @State var currentBalance = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    BalanceRow(text: "Opening balance", amount: openingBalance)
                    BalanceRow(text: "Current balance", amount: currentBalance)
                }
                
                Section {
                    BalanceChangeRow(text: "Overall change", amount: currentBalance - openingBalance)
                }
            }
            .listStyle(.grouped)
        }
        .onAppear(perform: calculateBalances)
        .navigationTitle("Statistics")
    }
    
    func calculateBalances() {
        funds.forEach{ fun in fun.calculateCurrentBalance() }

        openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
        currentBalance = funds.reduce(0) { $0 + $1.currentBalance }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {        
        FundStatistics()
    }
}
