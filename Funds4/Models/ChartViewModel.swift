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
    
    func getChange() -> Int {
        currentBalance - openingBalance
    }
    
    func getChangeColor() -> Color {
        switch getChange().signum() {
            case 1: return Color.positiveAmount
            case -1: return Color.negativeAmount
            default: return Color.zeroAmount
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
        let graphMin = (min(minOpening, minClosing) / graphGranularity * graphGranularity) - (graphGranularity * 2)        
        return graphMin
    }
    
    func getMaxValue() -> Int {
        if (chartPoints.isEmpty) {
            return 0
        }

        let maxOpening = Int(chartPoints.max(by: { $0.openingBalance < $1.openingBalance })?.openingBalance ?? 0)
        let maxClosing = Int(chartPoints.max(by: { $0.closingBalance < $1.closingBalance })?.closingBalance ?? 0)
        let graphMax = (max(maxOpening, maxClosing) / graphGranularity * graphGranularity) + (graphGranularity * 2)
        return graphMax
    }
            
    func updateChartData() {
        let days = 29 //TODO: This will come from a picker control.
        
        openingBalance = funds.reduce(0) { $0 + $1.openingBalance }
        currentBalance = funds.reduce(0) { $0 + $1.currentBalance }
        
        var data = [ChartPoint]()
        
        // Get the earliest date that a fund starts on.
        let minFundStartDate =  funds.min(by: { $0.startDate < $1.startDate })?.startDate.toDate()?.date ?? Date.distantPast
        let graphStartDate = (Date.now - days.days).dateAtStartOf(.day)
                
        var balances = [Int?]()
        var gsd = graphStartDate
        var runningBalance = 0
        while(gsd <= Date.now.dateAtStartOf(.day)) {
            runningBalance += funds.reduce(0) { $0 + $1.getBalanceOnDate((gsd).toISO(.withFullDate))}
            if (gsd <= minFundStartDate) {
                balances.append(nil)
            } else {
                balances.append(runningBalance)
            }
                        
            gsd = gsd + 1.days
        }
                
        let min = balances.compactMap {$0}.min()
        let max = balances.compactMap {$0}.max()
        
        // If we can't get a min and max out of the data something's odd
        // and we won't get a useful graph, so bail out.
        guard let min, let max else {
            chartPoints = data
            return
        }
        
        // Generate a value for days earlier than the earliest fund date that
        // won't affect the graph's range.
        let avg = Double((min + max) / 2) / 100.0
        
        // If the daily range is less than 1% of the graph range we'll draw a
        // thin grey line.
        let minBarLimit = Double(max - min) / 100.0 / 100.0
        
        gsd = graphStartDate
        var o = Double(funds.reduce(0) { $0 + $1.calculateBalanceOnDate((gsd - 1.days).toISO(.withFullDate))}) / 100.0
        for balance in balances {
            // From before the start date, generate an invisible bar.
            if (balance == nil) {
                data.append(ChartPoint(
                    date: gsd,
                    openingBalance: avg,
                    closingBalance: avg,
                    color: .clear
                ))
            } 
            else
            {
                let c = Double(funds.reduce(0) { $0 + $1.calculateBalanceOnDate((gsd).toISO(.withFullDate))}) / 100.0
                let range = abs(c - o)
                
                if range < minBarLimit {                    
                    data.append(ChartPoint(
                        date: gsd,
                        openingBalance: o - minBarLimit,
                        closingBalance: o + minBarLimit,
                        color: .zeroAmount
                    ))
                }
                else {
                    data.append(ChartPoint(
                        date: gsd,
                        openingBalance: o,
                        closingBalance: c,
                        color: c > o ? .positiveAmount : .negativeAmount
                    ))
                }
                
                o = c
            }
            gsd = gsd + 1.days
        }
                                
        chartPoints = data
    }
}
