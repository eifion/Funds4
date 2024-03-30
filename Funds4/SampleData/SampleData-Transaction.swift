import Foundation
import SwiftData

extension Transaction {
    static let calendar = Calendar(identifier: .gregorian)
          
    static let salary = Transaction(
        name: "Salary", startDate: Transaction.getRelativeDate(offset: -30).toISO(.withFullDate), endDate: Date.now.toISO(.withFullDate), amount: 100000)
    
    
    
    static let book = Transaction(name: "Penguin", 
                                  startDate: Transaction.getRelativeDate(offset: -2).toISO(.withFullDate)  ,
                                  endDate: Transaction.getRelativeDate(offset: -2).toISO(.withFullDate), amount: -1000)

    static let cd = Transaction(name: "CD", startDate: Transaction.getRelativeDate(offset: -2).toISO(.withFullDate)  , endDate: Transaction.getRelativeDate(offset: -2).toISO(.withFullDate), amount: -999)
    static let loanRepayment = Transaction(name: "Repayment", startDate: Transaction.getRelativeDate(offset: -3).toISO(.withFullDate), endDate: Transaction.getRelativeDate(offset: -3).toISO(.withFullDate), amount: -50000)
    
    static func getRelativeDate(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: Date.now)!
    }
}
