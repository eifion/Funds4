import SwiftUI

struct BalanceChangeRow: View {
    @State var text = ""
    @State var amount = 0

    
    var body: some View {
        HStack {
            Text(text)
                .bold()
            Spacer()
            Text(amount.asCurrency)
                .foregroundStyle(getColor())
        }.padding(.horizontal)
    }
    
    func getColor() -> Color {
        switch(amount.signum()) {
        case -1:
            return Color.red
        case 1:
            return Color.green
        default:
            return Color.gray
        }
    }
}

#Preview {
    return VStack {
        BalanceChangeRow(text: "Overall", amount: 1000)
        BalanceChangeRow(text: "Overall", amount: 0)
        BalanceChangeRow(text: "Overall", amount: -10000)
    }
    
}
