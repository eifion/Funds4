import Foundation
import SwiftData
import SwiftDate
import SwiftUI

struct FundStatistics: View { 
    @State var title: String
    @Binding var fund: Fund
            
    var body: some View {
            List {
                Section {
                    BalanceRow(text: "Opening balance", amount: $fund.openingBalance)
                    BalanceRow(text: "Current balance", amount: $fund.currentBalance)
                    BalanceChangeRow(text: "Overall change", amount: fund.currentBalance - fund.openingBalance)
                }
                                                
                Section {
                    //FundChart(funds: [fund], openingBalance: $fund.openingBalance, currentBalance: $fund.currentBalance)
                }
                
                FundTransactionsList(fund: fund)
            }
           
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationView {
            FundStatistics(title: "Statistics", fund: .constant(Fund.mainFund))
        }
    }
}
