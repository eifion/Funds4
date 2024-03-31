import Foundation
import SwiftData
import SwiftDate
import SwiftUI

struct FundStatistics: View {
    var funds: [Fund]    
    
    @State var title: String

    @State var openingBalance = 0
    @State var currentBalance = 0

    private let calendar = Calendar.current
            
    var body: some View {
        NavigationView {
            List {
                Section {
                    BalanceRow(text: "Opening balance", amount: $openingBalance)
                    BalanceRow(text: "Current balance", amount: $currentBalance)
                }
                                
                Section {
                    FundChart(funds: funds, openingBalance: $openingBalance, currentBalance: $currentBalance)
                }
                
                Section {
                    BalanceChangeRow(text: "Overall change", amount: currentBalance - openingBalance)
                }
            }
            .listStyle(.grouped)
        }
        .onAppear(perform: calculateBalances)
        .navigationTitle(title)
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
        FundStatistics(funds: [Fund.mainFund, Fund.house, Fund.bankLoan], title: "Statistics")
    }
}
