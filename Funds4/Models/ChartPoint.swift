import Foundation
import SwiftUI

struct ChartPoint: Identifiable {
    var id = UUID()
    var date: Date
    var openingBalance: Double
    var closingBalance: Double                
    var color: Color
}
