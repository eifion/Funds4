import Foundation
import SwiftData
import SwiftUI

@Model
final class Transaction: Identifiable {
    var id =  UUID()
    var name: String
    var startDate: String
    var endDate: String
    var amount: Int
    var fund: Fund?
    var transferTransaction: Transaction?
    
    init(name: String, startDate: String, endDate: String, amount: Int) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.amount = amount
    }
    
    @Transient
    private var calendar: Calendar  = Calendar(identifier: .gregorian)
    
    @Transient
    var color: Color {
        // If the amount is negative its an outgoing.
        if (self.amount < 0) {
            return Color.negativeAmount
        }
        
        // Otherwise it's either an incoming or a transfer.
        return self.transferTransaction == nil ? Color.positiveAmount : Color.zeroAmount
    }
    
    @Transient
    var displayAmount: String {
        amount.asCurrency
    }
    
    @Transient
    var displayDate: String {
        guard let date = startDate.toDate()?.date else {
            return ""
        }
        
        let dayOnlyDateFormatter = DateFormatter()
        let dayAndMonthDateFormatter = DateFormatter()
        dayOnlyDateFormatter.dateFormat = "d"
        dayAndMonthDateFormatter.dateFormat = "d MMM"
        return dayAndMonthDateFormatter.string(from: date)
    }
    
    @Transient
    var fundName: String {
        guard let fund = self.fund else {
            return ""
        }
        
        guard let transferTransaction = self.transferTransaction else {
            return self.fund?.name ?? ""
        }

        return "\(transferTransaction.fund!.name) → \(fund.name)"
    }
    
    @Transient
    var iconName: String {
        // If the amount is negative its an outgoing.
        if (self.amount < 0) {
            return "arrow.down.circle.fill";
        }
        
        // Otherwise it's either an incoming or a transfer.
        return self.transferTransaction == nil ? "arrow.up.circle.fill" : "arrow.left.arrow.right.circle.fill"
    }
    
    @Transient
    var startDateAsDate: Date {
        guard let s = startDate.toDate()?.date else {
            fatalError()
        }
        return s
    }
    
    @Transient
    var endDateAsDate: Date {
        guard let e = endDate.toDate()?.date else {
            fatalError()
        }
        return e
    }
    
    func orderedDisplayDate() -> String {
        let date = startDateAsDate
        
        if (calendar.isDateInToday(date)) {
            return "00_Today"
        }
            
        if (calendar.isDateInYesterday(date)) {
            return "01_Yesterday"
        }
            
        // >= start of week
        let startOfWeek = Date.now.startOfWeek
        if (startOfWeek != nil && date >= startOfWeek!) {
            return "02_This week"
        }
            
        // >= start of month
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date.now))
        if (startOfMonth != nil && date >= startOfMonth!) {
            return "03_This month"
        }
            
        // >= start of year
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date.now))
        if (startOfYear != nil && date >= startOfYear!) {
            return "04_This Year"
        }
            
        // Otherwise year number.
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return "05_\(yearFormatter.string(from: date))"
    }
}
