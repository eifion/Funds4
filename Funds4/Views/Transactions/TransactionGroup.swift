import SwiftData
import SwiftUI

struct TransactionGroup: View {
    @State var isExpanded: Bool = false
    @Binding var group: TransactionGroupViewModel
    @Binding var transactionToEdit: Transaction?
    
    var body: some View {
            DisclosureGroup(
                group.title,
                isExpanded: $isExpanded)
                {
                    ForEach(group.transactions) { transaction in
                        Button(action: {
                            transactionToEdit = transaction
                        }, label: {
                            TransactionRow(transaction: transaction)
                        })
                        .padding(.bottom, 4.0)
                        .foregroundColor(.primary)
                    }
               }
                .tint(Color.primary)
                .onAppear(perform: setup)
    }
    
    func setup() {
        isExpanded = group.isExpanded
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TransactionGroup(group: .constant(TransactionGroupViewModel(id: 1, title: "Test", transactions: [])), transactionToEdit: .constant(Transaction.book))
    }
}
