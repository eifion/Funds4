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
        }
    }
    
    func getColor() -> Color {
        switch(amount.signum()) {
        case -1:
            return Color.negativeAmount
        case 1:
            return Color.positiveAmount
        default:
            return Color.zeroAmount
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
