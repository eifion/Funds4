import Foundation
import SwiftData
import SwiftDate

extension Fund {
    
    
    static let mainFund = Fund(name: "Main Fund", startDate: (Date.now - 30.days).date.toISO(.withFullDate), openingBalance: -85000, transactions: [], isDefault: true)
    static let bankLoan = Fund(name: "Bank loan", startDate: Date.now.toISO(.withFullDate), openingBalance: 0, transactions: [], isDefault: false)
    static let house = Fund(name: "House repairs", startDate: Date.now.toISO(.withFullDate), openingBalance: 0, transactions: [], isDefault: false)
    
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
