import Charts
import SwiftData
import SwiftUI

struct FundStatistics: View {
    @Query var funds: [Fund]    
    
    @State var openingBalance = 0
    @State var currentBalance = 0
    @State var data: [ChartPoint] = []
    @State var isPreview = false

    private let calendar = Calendar.current
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    BalanceRow(text: "Opening balance", amount: $openingBalance)
                    BalanceRow(text: "Current balance", amount: $currentBalance)
                }
                
                if (data.count > 0) {
                    Section {
                        Chart(data) {
                            LineMark(
                                x: .value("Date", $0.date),
                                y: .value("Balance", $0.balance)
                            )
                        }
                        .padding(.top)
                        .chartXAxis {
                            AxisMarks { value in
                                AxisValueLabel {
                                    if let s = value.as(Date.self)
                                    {
                                        Text(s.getOrdinalDayOfMonth())
                                    }
                                }
                            }
                        }

                        .chartYAxis {
                            AxisMarks { value in
                                AxisValueLabel((value.as(Double.self) ?? 0).formatted(.currency(code: "GBP")), centered: true, anchor: nil, multiLabelAlignment: .trailing, collisionResolution: .automatic, offsetsMarks: false, orientation: .horizontal, horizontalSpacing: nil, verticalSpacing: nil)
                                
                            }
                        }
                    }
                }
                
                Section {
                    BalanceChangeRow(text: "Overall change", amount: currentBalance - openingBalance)
                }
            }
            .listStyle(.grouped)
        }
        .onAppear(perform: calculateBalances)
        .navigationTitle("Statistics")
    }
    
    func calculateBalances() {
        // Make sure each fund is up-to-date
        funds.forEach{ fun in
            fun.calculateCurrentBalance()
        }
        
        if !isPreview {
            data = []
    
            let earliestStartDate = funds.min(by: { $0.startDate < $1.startDate })?.startDateAsDate ?? Date.now
            var startDate = max(calendar.date(byAdding: .day, value: -60, to: Date.now) ?? Date.now, earliestStartDate)
    
    
            while (startDate <= Date.now) {
                let balanceOnDay = funds.reduce(0) { $0 + $1.calculateBalanceOnDate(startDate.asISO8601String())}
                data.append(ChartPoint(date: startDate, balance: Double(balanceOnDay) / 100.0))
                //TODO: No forced unwrapping!
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            }
        }

        openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
        currentBalance = funds.reduce(0) { $0 + $1.currentBalance }
    }
}

struct ChartPoint: Identifiable {
    var id = UUID()
    var date: Date
    var balance: Double
}

#Preview {
        var data = [ChartPoint]()
        let calendar = Calendar.current
        
        var date = calendar.date(byAdding: .day, value: -365, to: Date.now)!
        while (date <= Date.now) {
            let balanceOnDay = -500000 + Int.random(in: 1...1000000)
            data.append(ChartPoint(date: date, balance: Double(balanceOnDay) / 100.0))
            //TODO: No forced unwrapping!
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
                
        return FundStatistics(data: data, isPreview: true)
                                                                    
}
