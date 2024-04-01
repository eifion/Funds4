//
//  FundTransactionsList.swift
//  Funds4
//
//  Created by Eifion Bedford on 31/03/2024.
//

import SwiftUI

struct FundTransactionsList: View {
    @State var fund: Fund
    
    var body: some View {
        
        // Filter out the outgoing part of transfer transactions.
        let filteredTransactions = fund.transactions.filter{ $0.amount > 0 || ($0.transferTransaction == nil && $0.amount < 0) }
        let groupedTransactions = Dictionary(grouping: filteredTransactions, by: {$0.orderedDisplayDate()})
        
        ForEach(groupedTransactions.sorted(by: { $0.key < $1.key }), id: \.key) { group in
            Section(group.key.dropFirst(3)) {
                ForEach(group.value) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
       }
    }
}

//#Preview {
//    FundTransactionsList()
//}
