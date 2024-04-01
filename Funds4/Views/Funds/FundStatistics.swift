import Foundation
import SwiftData
import SwiftDate
import SwiftUI

struct FundStatistics: View {
    var funds: [Fund]    
    
    @State var title: String

    @State var openingBalance = 0
    @State var currentBalance = 0
            
    var body: some View {
            List {
                Section {
                    BalanceRow(text: "Opening balance", amount: $openingBalance)
                    BalanceRow(text: "Current balance", amount: $currentBalance)
                    BalanceChangeRow(text: "Overall change", amount: currentBalance - openingBalance)
                }
                                                
                Section {
                    FundChart(funds: funds, openingBalance: $openingBalance, currentBalance: $currentBalance)
                }
                                                
                if funds.count == 1, let fund = funds.first {
                    FundTransactionsList(fund: fund)
                }
            }
            .onAppear(perform: calculateBalances)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)        
    }
    
    func calculateBalances() {
        // Make sure each fund is up-to-date
        funds.forEach{ fun in
            fun.calculateCurrentBalance()
        }
        
        openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
        currentBalance = funds.reduce(0) { $0 + $1.currentBalance }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationView {
            FundStatistics(funds: [Fund.mainFund], title: "Statistics")
        }
    }
}
