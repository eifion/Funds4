import SwiftData
import SwiftUI

struct FundDetails: View {
    @Environment(\.modelContext) private var modelContext
    
    var fund: Fund
    var body: some View {
        Text("Hello, \(fund.name)!")
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TabView {
            FundDetails(fund: Fund.mainFund)
        }
    }
}
