import SwiftData
import SwiftUI

struct TransactionDaySection: View {
    var date: String
    var transactions: [Transaction]
    var delete: (_ tranaction: Transaction) -> Void
    
    @Binding
    var transactionToEdit: Transaction?
    
    var body: some View {
        Section(date.dropFirst(3)) {
            ForEach(transactions) { transaction in                               
               TransactionRow(transaction: transaction)
                .swipeActions(allowsFullSwipe: false) {
                        // Delete transaction button
                        Button(role: .destructive) {
                            delete(transaction)
                        }
                        label: {
                            Label("Delete", systemImage: "trash")
                        }

                    // Edit transaction button
                    Button {
                        transactionToEdit = transaction
                    }
                    label: {
                        Label("Edit", systemImage: "pencil")
                    }.tint(.indigo)
                }
           }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        List {
            TransactionDaySection(
                date: "05_2023",
                transactions: [Transaction.book, Transaction.cd],
                delete: {tranaction in },
                transactionToEdit: .constant(nil)
            )
        }
    }
}
