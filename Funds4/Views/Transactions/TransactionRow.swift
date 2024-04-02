import SwiftData
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        VStack {
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
            .padding(8)
        }
        .background(Color.Chart.background)
        .cornerRadius(8)        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TransactionRow(transaction: Transaction.book)
    }
}
