import SwiftData
import SwiftUI

struct FundTransactionsList: View {
    @State var fund: Fund
    
    var body: some View {
        
        // Filter out the outgoing part of transfer transactions.
        let filteredTransactions = fund.transactions.filter{ $0.amount > 0 || ($0.transferTransaction == nil && $0.amount < 0) }
        let groupedTransactions = Dictionary(grouping: filteredTransactions, by: {$0.orderedDisplayDate()})
        
        ForEach(groupedTransactions.sorted(by: { $0.key < $1.key }), id: \.key) { group in
            ForEach(group.value) { transaction in
                TransactionRow(transaction: transaction)
            }            
       }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        FundTransactionsList(fund: Fund.mainFund)
    }
}
