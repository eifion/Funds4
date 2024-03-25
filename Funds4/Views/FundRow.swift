import Foundation
import SwiftData
import SwiftUI

struct FundRow: View {
    let fund:Fund
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(fund.name).bold(fund.isDefault)
                HStack {
                    Text(fund.displayDate).font(.subheadline)
                    Text(fund.openingDisplayBalance).font(.subheadline)
                }
            }
            Spacer()
            Text(fund.currentDisplayBalance).foregroundStyle(fund.currentDisplayColour)
        }
    }
}

#Preview("Single Row") {
    ModelContainerPreview(ModelContainer.sample) {
        FundRow(fund: Fund.mainFund)
    }
}
