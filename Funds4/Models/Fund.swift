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
            return Color.negativeAmount
        case 1:
            return Color.positiveAmount
        default:
            return Color.zeroAmount
        }
    }
    
    @Transient
    var displayDate: String {
        guard let date = self.startDate.toDate(region: .UTC)?.date else {
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
        guard let s = startDate.toDate()?.date else {
            fatalError()
        }
        return s
    }
    
    func getBalanceOnDate(_ dateString: String) -> Int {
        // Get all current transactions:
        let daysOutgoings = transactions.filter({ $0.amount < 0 && $0.startDate == dateString}).reduce(0) { $0 + $1.amount }
        let daysIncomings = transactions.filter({$0.isCurrentIncoming}).reduce(0) { $0 + $1.amountPerDay }
        print("\(dateString) \(daysIncomings) \(daysOutgoings)")
        return daysIncomings + daysOutgoings
    }
    
    func calculateBalanceOnDate(_ dateString: String) -> Int {
        guard let date = dateString.toDate()?.date else {
            fatalError("Couldn't calculate the end date")
        }
        
        let calendar = Calendar.current
        
        if (dateString < startDate) {
            return 0
        }

        var balance = openingBalance
        for transaction in transactions
        {
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
            guard let startDate = transaction.startDate.toDate()?.date else {
                fatalError("Couldn't get start date for incoming.")
            }
            guard let endDate = transaction.endDate.toDate()?.date else {
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
