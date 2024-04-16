import Foundation
import SwiftData
import SwiftDate
import SwiftUI

struct FundStatistics: View { 
    @State var title: String
    @State var chartViewModel: ChartViewModel = ChartViewModel()
    @Binding var fund: Fund
            
    var body: some View {
        ScrollView {
            VStack {
                FundChart(chartViewModel: $chartViewModel)
                    .frame(height: 200)
                FundTransactionsList(fund: fund)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                chartViewModel.funds = [fund]
            })
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationView {
            FundStatistics(title: "Statistics", fund: .constant(Fund.mainFund))
        }
    }
}
