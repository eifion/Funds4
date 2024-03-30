import Foundation
import SwiftData
import SwiftDate

extension Transaction {
    
    
    
    static let salary = Transaction(
        name: "Salary", startDate: (Date.now - 30.days).toISO(.withFullDate), endDate: Date.now.toISO(.withFullDate), amount: 10000)
                
    static let book = Transaction(name: "Penguin", 
                                  startDate: (Date.now - 20.days).toISO(.withFullDate),
                                  endDate:(Date.now - 20.days).toISO(.withFullDate),
                                  amount: -1000)

    static let cd = Transaction(
        name: "CD",
        startDate: (Date.now - 10.days).toISO(.withFullDate),
        endDate: (Date.now - 10.days).toISO(.withFullDate),
        amount: -999)
    
    static let loanRepayment = Transaction(
       name: "Repayment",
       startDate: (Date.now - 3.days).toISO(.withFullDate),
       endDate: (Date.now - 3.days).toISO(.withFullDate),
       amount: -500)
}
