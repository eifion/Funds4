import Charts
import SwiftData
import SwiftDate
import SwiftUI

struct FundChart: View {
    @State var funds: [Fund]
    @Binding var openingBalance: Int
    @Binding var currentBalance: Int
        
    @State private var graphGranularity = 100
    @State private var data = [ChartPoint]()
    
    var body: some View {
        ZStack {
            Color(Color.Chart.background)
            VStack {
                HStack {
                    Spacer()
                    Text("\(currentBalance.asCurrency) (\((currentBalance - openingBalance).asCurrency))")
                }
                .font(.title3)
                .bold()
                .foregroundStyle(balanceColor)
                .padding([.top, .trailing], 8)
                
                Chart(data) {
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
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.currency(code: "GBP")), centered: false, anchor: nil, multiLabelAlignment: .trailing, collisionResolution: .automatic, offsetsMarks: false, orientation: .horizontal, horizontalSpacing: nil, verticalSpacing: nil)
                    }
                }
                .chartYScale(domain: [getMinValue(), getMaxValue()])
                .padding([.leading, .trailing, .bottom ],8)
            }
        }
        .cornerRadius(8)
        .onAppear(perform: calculateChartData)
    }
    
    var balanceColor : Color {
        switch currentBalance.signum() {
        case 1: return Color.positiveAmount
        case -1: return Color.negativeAmount
        default: return Color.zeroAmount
        }
    }        
        
    func calculateChartData() {
        data = []
        
         let minStartDate =  funds.min(by: { $0.startDate < $1.startDate })?.startDate.toDate()?.date
         var startDate = minStartDate ?? Date.now

         openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
         currentBalance = funds.reduce(0) { $0 + $1.currentBalance }

         var startBalance = Double(openingBalance / 100)
         while (startDate <= Date.now) {
             let balanceOnDay = funds.reduce(0) { $0 + $1.calculateBalanceOnDate(startDate.toISO(.withFullDate))}
             data.append(ChartPoint(date: startDate, openingBalance: startBalance, closingBalance: Double(balanceOnDay) / 100.0))
             
             startDate = startDate + 1.days
             startBalance = Double(balanceOnDay) / 100.0
         }
                         
        let diff = abs(Double(currentBalance - openingBalance) / 100.0)
         let exp = floor(log10(diff))
         graphGranularity = Int(pow(Double(10.0), exp))
         if (graphGranularity == 0) {
             graphGranularity = 1
         }
    }
    
    func getMinValue() -> Int {
        if (data.isEmpty) {
            return 0
        }
        
        let minOpening = Int(data.min(by: { $0.openingBalance < $1.openingBalance })?.openingBalance ?? 0)
        let minClosing = Int(data.min(by: { $0.closingBalance < $1.closingBalance })?.closingBalance ?? 0)
        return (minOpening < minClosing ? minOpening : minClosing) - graphGranularity
    }
    
    func getMaxValue() -> Int {
        if (data.isEmpty) {
            return 0
        }
        
        let maxOpening = Int(data.max(by: { $0.openingBalance < $1.openingBalance })?.openingBalance ?? 0)
        let maxClosing = Int(data.max(by: { $0.closingBalance < $1.closingBalance })?.closingBalance ?? 0)
        return  (maxOpening > maxClosing ? maxOpening : maxClosing) + graphGranularity
    }
}

struct ChartPoint: Identifiable {
    var id = UUID()
    var date: Date
    var openingBalance: Double
    var closingBalance: Double
                
    var color: Color {
        closingBalance < openingBalance ? Color.negativeAmount :
            Color.positiveAmount
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        FundChart(funds: [Fund.mainFund], openingBalance: .constant(-1000), currentBalance: .constant(-1000))
            .frame(height: 200)
    }
}
