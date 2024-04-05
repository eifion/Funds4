import Foundation
import Observation
import SwiftDate
import SwiftUI

@Observable class ChartViewModel {
    var chartPoints: [ChartPoint] = []
    var openingBalance: Int = 0
    var currentBalance: Int = 0
    var graphGranularity: Int = 100
            
    var funds: [Fund] = [] {
        didSet {
            updateChartData()
        }
    }
                
    func getBalanceColor() -> Color {
        switch currentBalance.signum() {
        case 1: return Color.positiveAmount
        case -1: return Color.negativeAmount
        default: return Color.zeroAmount
        }
    }
    
    func getMinValue() -> Int {
        if (chartPoints.isEmpty) {
            return 0
        }

        let minOpening = Int(chartPoints.min(by: { $0.openingBalance < $1.openingBalance })?.openingBalance ?? 0)
        let minClosing = Int(chartPoints.min(by: { $0.closingBalance < $1.closingBalance })?.closingBalance ?? 0)
        return (minOpening < minClosing ? minOpening : minClosing) - graphGranularity
    }
    
    func getMaxValue() -> Int {
        if (chartPoints.isEmpty) {
            return 0
        }

        let maxOpening = Int(chartPoints.max(by: { $0.openingBalance < $1.openingBalance })?.openingBalance ?? 0)
        let maxClosing = Int(chartPoints.max(by: { $0.closingBalance < $1.closingBalance })?.closingBalance ?? 0)
        return  (maxOpening > maxClosing ? maxOpening : maxClosing) + graphGranularity
    }
            
    func updateChartData() {
        var data = [ChartPoint]()
        
        let minFundStartDate =  funds.min(by: { $0.startDate < $1.startDate })?.startDate.toDate()?.date ?? Date.distantPast
        let minStartDate = Date.now - 30.days
        var startDate = minFundStartDate.laterDate(minStartDate)
                
        openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
        currentBalance = funds.reduce(0) { $0 + $1.currentBalance }
        
        let diff = abs(Double(currentBalance - openingBalance) / 100.0)
        let exp = floor(log10(diff))
        graphGranularity = Int(pow(Double(10.0), exp))
        if (graphGranularity == 0) {
            graphGranularity = 1
        }
        
        let minimumDifference = Double(graphGranularity) / 100.0
        var startBalance = Double(openingBalance / 100)
        while (startDate <= Date.now) {
            let balanceOnDay = Double(funds.reduce(0) { $0 + $1.calculateBalanceOnDate(startDate.toISO(.withFullDate))} / 100)
            
            // If the start and end values are the same, alter them slightly so that a line shows.
            if startBalance.distance(to: balanceOnDay) < minimumDifference {
                data.append(ChartPoint(date: startDate, openingBalance: startBalance + minimumDifference, closingBalance: balanceOnDay - minimumDifference, color: .zeroAmount))
            }
            else {
                data.append(ChartPoint(date: startDate, openingBalance: startBalance, closingBalance: balanceOnDay, color: balanceOnDay > startBalance ? .positiveAmount : .negativeAmount))
            }
            startDate = startDate + 1.days
            startBalance = balanceOnDay
        }
        
        chartPoints = data
    }
}
