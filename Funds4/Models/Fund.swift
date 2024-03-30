import Foundation
import SwiftData
import SwiftDate
import SwiftUI

@Model
final class Fund {
    @Attribute(.unique)
    var name: String
    var startDate: String
    var openingBalance: Int
    var currentBalance: Int
    var isDefault: Bool = false
    @Relationship(deleteRule: .deny, inverse: \Transaction.fund)
    var transactions: [Transaction]
    
    init(name: String, startDate: String, openingBalance: Int, transactions: [Transaction], isDefault: Bool) {
        self.name = name
        self.startDate = startDate
        self.openingBalance = openingBalance
        self.currentBalance = openingBalance
        self.transactions = transactions
        self.isDefault = isDefault
    }
    
    @Transient
    var currentDisplayColour: Color {
        switch(currentBalance.signum()) {
        case -1:
            return Color.red
        case 1:
            return Color.green
        default:
            return Color.black
        }
    }
    
    @Transient
    var displayDate: String {
        guard let date = self.startDate.iso8601StringToDate() else {
            return ""
        }
        
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    @Transient
    var openingDisplayBalance: String {
        openingBalance.asCurrency
    }
    
    @Transient
    var currentDisplayBalance: String {
        currentBalance.asCurrency
    }
    
    @Transient
    var startDateAsDate: Date {
        guard let s = startDate.iso8601StringToDate() else {
            fatalError()
        }
        return s
    }
    
    func calculateBalanceOnDate(_ dateString: String) -> Int {
        guard let date = dateString.iso8601StringToDate() else {
            fatalError("Couldn't calculate the end date")
        }
        
        let calendar = Calendar.current
        
        if (dateString < startDate) {
            return 0
        }

        var balance = openingBalance
        for transaction in transactions {
            // Ignore transactions with future dates.
            if (transaction.startDate > dateString) {
                continue
            }
                        
            // If transaction is an outgoing, add it.
            if (transaction.amount < 0) {
                balance += transaction.amount
                continue
            }
                        
            // If transaction is an completed incoming, add it.
            if (transaction.endDate <= dateString) {
                balance += transaction.amount
                continue
            }
            
            // If transaction is a current incoming, add the relevant fraction.
            guard let startDate = transaction.startDate.iso8601StringToDate() else {
                fatalError("Couldn't get start date for incoming.")
            }
            guard let endDate = transaction.endDate.iso8601StringToDate() else {
                fatalError("Couldn't get start date for incoming.")
            }
            
            guard let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day else {
                fatalError("Couldn't calculate day range for incoming")
            }
                        
            guard let days = calendar.dateComponents([.day], from: startDate, to: date).day else {
                fatalError("Couldn't calculate days")
            }
            
            let fractionToAdd = Double(days + 1) / Double(totalDays + 1)
            balance += Int(fractionToAdd * Double(transaction.amount))
        }
        
        return balance
    }
    
    func calculateCurrentBalance() {                
        currentBalance = calculateBalanceOnDate(Date.now.toISO(.withFullDate))
    }
}
