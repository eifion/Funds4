import Foundation
import SwiftData

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
}
