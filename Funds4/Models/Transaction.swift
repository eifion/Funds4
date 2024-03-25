import Foundation
import SwiftData
import SwiftUI

@Model
final class Transaction {
    var name: String
    var startDate: String
    var endDate: String
    var amount: Int
    var fund: Fund?
    
    init(name: String, startDate: String, endDate: String, amount: Int) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.amount = amount
    }
    
    @Transient
    var color: Color {
        return amount < 0 ? Color.red : Color.green
    }
    
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
        self.fund?.name ?? ""
    }
    
    @Transient
    var iconName: String {
        return amount < 0 ? "arrow.left.circle.fill" : "arrow.right.circle.fill"
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
