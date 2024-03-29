import Foundation

extension Date {
    var startOfWeek: Date? {
        let calendar = Calendar.current
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }
    
    func asISO8601String() -> String {
        let calendar = Calendar.current
        let day = String(format: "%02d", calendar.component(.day, from: self))
        let month =   String(format: "%02d", calendar.component(.month, from: self))
        let year = calendar.component(.year, from: self)        
        return "\(year)-\(month)-\(day)"
    }
    
    func getOrdinalDayOfMonth() -> String {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        if let ordinal = ordinalFormatter.string(from: NSNumber(value: day)) {
            return ordinal
        }
        return ""
    }
}
