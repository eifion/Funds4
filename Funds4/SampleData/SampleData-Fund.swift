import Foundation
import SwiftData

extension Fund {
    static let mainFund = Fund(name: "Main Fund", startDate: Date.now.asISO8601Date(), openingBalance: 10000, transactions: [], isDefault: true)
    static let bankLoan = Fund(name: "Bank loan", startDate: Date.now.asISO8601Date(), openingBalance: -50000, transactions: [], isDefault: false)
    static let house = Fund(name: "House repairs", startDate: Date.now.asISO8601Date(), openingBalance: -25000, transactions: [], isDefault: false)
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add funds
        modelContext.insert(mainFund)
        modelContext.insert(bankLoan)
        modelContext.insert(house)
        
        // Add transactions
        modelContext.insert(Transaction.salary)
        modelContext.insert(Transaction.book)
        modelContext.insert(Transaction.cd)
        modelContext.insert(Transaction.loanRepayment)
        
        // Set the fund for each transaction
        Transaction.salary.fund = mainFund
        Transaction.loanRepayment.fund = bankLoan
        Transaction.book.fund = mainFund
    }
    
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Transaction.self)
            try modelContext.delete(model: Fund.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
