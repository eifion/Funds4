import SwiftUI

struct BalanceRow: View {
    @State var text = ""
    @Binding var amount: Int
    
    var body: some View {
        HStack {
            Text(text)
                .bold()
            Spacer()
            Text(amount.asCurrency)
        }
    }
}

//#Preview {
//    BalanceRow(text: "Opening balance", amount: .constant(99999))
//}
