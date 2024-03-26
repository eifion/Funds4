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
    var transferFund: Fund?
    
    init(name: String, startDate: String, endDate: String, amount: Int) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.amount = amount
    }
    
    @Transient
    var color: Color {
        // If the amount is negative its an outgoing.
        if (self.amount < 0) {
           return Color.red
        }

        // Otherwise it's either an incoming or a transfer.
        return self.transferFund == nil ? Color.green : Color.gray    }
    
    @Transient
    var displayAmount: String {
        amount.asCurrency
    }
    
    @Transient
    var displayDate: String {
        guard let date = startDate.iso8601StringToDate() else {
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
        if (self.transferFund == nil) {
            return self.fund?.name ?? ""
        }
        
        return self.fund == nil ? "" : "\(self.transferFund!.name) → \(self.fund!.name)"
    }
    
    @Transient
    var iconName: String {
        // If the amount is negative its an outgoing.
        if (self.amount < 0) {
            return "arrow.down.circle.fill";
        }
        
        // Otherwise it's either an incoming or a transfer.
        return self.transferFund == nil ? "arrow.up.circle.fill" : "arrow.left.arrow.right.circle.fill"
    }
    
    @Transient
    var startDateAsDate: Date {
        guard let s = startDate.iso8601StringToDate() else {
            fatalError()
        }
        return s
    }
    
    @Transient
    var endDateAsDate: Date {
        guard let e = endDate.iso8601StringToDate() else {
            fatalError()
        }
        return e
    }
}
