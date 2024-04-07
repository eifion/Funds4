import SwiftUI

struct TransactionGroup: View {
    @State var title: String
    @State var transactions: [Transaction]
    @State var isExpanded: Bool

    @Binding var transactionToEdit: Transaction?
    
    
    var body: some View {
        DisclosureGroup(
            title,
            isExpanded: $isExpanded)
            {
            ForEach(transactions) { transaction in
                Button(action: {
                    transactionToEdit = transaction
                }, label: {
                    TransactionRow(transaction: transaction)
                })
                .padding(.bottom, 4.0)
                .foregroundColor(.primary)
            }
            }.tint(Color.primary)
    }
}

#Preview {
    TransactionGroup(title: "01_Yesterday", transactions: [], isExpanded: true,  transactionToEdit: .constant(nil))
}
