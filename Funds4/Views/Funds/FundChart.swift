import Charts
import SwiftData
import SwiftDate
import SwiftUI

struct FundChart: View {
    @Binding var chartViewModel: ChartViewModel
    
    @State private var changeBalance: String = ""
    @State private var changeColor: Color = Color.black
    @State private var show30DaysChanges: Bool = true
    
    var body: some View {
        ZStack {
            Color(Color.Chart.background)
                VStack {
                    HStack {
                        Spacer()
                        Text("\(chartViewModel.currentBalance.asCurrency)")
                            .foregroundStyle(chartViewModel.getBalanceColor())

                        Text(changeBalance)
                            .foregroundStyle(changeColor)
                            .onTapGesture(perform: updateChanges)
                            .onChange(of: chartViewModel.chartPoints.count, updateChanges)

                    }
                    .font(.headline)
                    .bold()
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
                            AxisValueLabel((value.as(Double.self) ?? 0).formatted(.currency(code: "GBP").precision(.fractionLength(0...0))), centered: false, anchor: nil, multiLabelAlignment: .trailing, collisionResolution: .automatic, offsetsMarks: false, orientation: .horizontal, horizontalSpacing: nil, verticalSpacing: nil)
                            AxisGridLine()
                        }
                        
                    }
                    .chartYScale(domain: [chartViewModel.getMinValue(), chartViewModel.getMaxValue()])
                    .padding([.leading, .trailing, .bottom ],8)
                }
            
        }
        .cornerRadius(8)
    }
    
    private func updateChanges() {
        if (show30DaysChanges) {
            changeBalance = chartViewModel.getChange(daysAgo: 30).asCurrency
            changeColor = chartViewModel.getChangeColor(daysAgo: 30)
        }
        else {
            changeBalance = chartViewModel.getChange().asCurrency
            changeColor = chartViewModel.getChangeColor()
        }
        show30DaysChanges.toggle()
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

