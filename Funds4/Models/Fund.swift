import Foundation
import SwiftData

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
}
