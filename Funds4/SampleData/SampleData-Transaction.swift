import Foundation
import SwiftData

extension Transaction {
    static let calendar = Calendar(identifier: .gregorian)
          
    static let salary = Transaction(
        name: "Salary", startDate: Transaction.getRelativeDate(offset: -30).asISO8601String(), endDate: Date.now.asISO8601String(), amount: 100000)
    
    
    
    static let book = Transaction(name: "Penguin", 
                                  startDate: Transaction.getRelativeDate(offset: -2).asISO8601String()  ,
                                  endDate: Transaction.getRelativeDate(offset: -2).asISO8601String(), amount: -1000)

    static let cd = Transaction(name: "CD", startDate: Transaction.getRelativeDate(offset: -2).asISO8601String()  , endDate: Transaction.getRelativeDate(offset: -2).asISO8601String(), amount: -999)
    static let loanRepayment = Transaction(name: "Repayment", startDate: Transaction.getRelativeDate(offset: -3).asISO8601String(), endDate: Transaction.getRelativeDate(offset: -3).asISO8601String(), amount: -50000)
    
    static func getRelativeDate(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: Date.now)!
    }
}
