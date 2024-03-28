import SwiftUI

struct BalanceRow: View {
    @State var text = ""
    @State var amount = 0
    
    var body: some View {
        HStack {
            Text(text)
                .bold()
            Spacer()
            Text(amount.asCurrency)
        }.padding(.horizontal)
    }
}

#Preview {
    BalanceRow(text: "Opening balance", amount: 99999)
}
