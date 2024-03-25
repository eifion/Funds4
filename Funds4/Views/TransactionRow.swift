import SwiftData
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.iconName).foregroundColor(transaction.color)
            VStack(alignment: .leading) {
                Text(transaction.displayDate).font(.caption)
                Text("\(transaction.name)")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(transaction.fundName).font(.caption)
                Text(transaction.displayAmount)
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TransactionRow(transaction: Transaction.book)
    }
}
