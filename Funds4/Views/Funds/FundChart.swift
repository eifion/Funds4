import Charts
import SwiftData
import SwiftDate
import SwiftUI

struct FundChart: View {
    @Binding var chartViewModel: ChartViewModel
    
    var body: some View {
        ZStack {
            Color(Color.Chart.background)
                VStack {
                    HStack {
                        Spacer()
                        Text("\(chartViewModel.currentBalance.asCurrency) (\((chartViewModel.currentBalance - chartViewModel.openingBalance).asCurrency))")
                    }
                    .font(.title3)
                    .bold()
                    .foregroundStyle(chartViewModel.getBalanceColor())
                    .padding([.top, .trailing], 8)

    
                    Chart(chartViewModel.chartPoints) {
                        BarMark(
                            x: .value("Date", $0.date, unit: .day),
                            yStart: .value("Balance", $0.openingBalance),
                            yEnd: .value("Balance", $0.closingBalance),
                            width: .automatic
                        )
                        .foregroundStyle($0.color)
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            AxisValueLabel()
                            AxisGridLine()
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel((value.as(Double.self) ?? 0).formatted(.currency(code: "GBP")), centered: false, anchor: nil, multiLabelAlignment: .trailing, collisionResolution: .automatic, offsetsMarks: false, orientation: .horizontal, horizontalSpacing: nil, verticalSpacing: nil)
                            AxisGridLine()
                        }
                        
                    }
                    .chartYScale(domain: [chartViewModel.getMinValue(), chartViewModel.getMaxValue()])
                    .padding([.leading, .trailing, .bottom ],8)
                }
            
        }
        .cornerRadius(8)
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        let cvm = ChartViewModel()
        cvm.chartPoints.append(ChartPoint(date: Date.now, openingBalance: 0, closingBalance: 100, color: .positiveAmount))
        
        return FundChart(chartViewModel: .constant(cvm))
            .frame(height: 200)
    }
}

