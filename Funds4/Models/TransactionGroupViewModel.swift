import Foundation
import Observation

@Observable
class TransactionGroupViewModel : Identifiable {
    var id: Int
    var title: String = ""
    var transactions: [Transaction] = []
    
    var isExpanded: Bool {
        id < 4
    }
    
    init(id: Int, title: String, transactions: [Transaction]) {
        self.id = id
        self.title = title
        self.transactions = transactions
    }
}
