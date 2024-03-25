import Foundation
import SwiftData
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
    
    func calculateCurrentBalance() {
        //var today = Date.now.asISO8601Date()
        
        var balance = openingBalance
        for transaction in transactions {
            balance += transaction.amount
        }
        
        currentBalance = balance                       
    }
}
