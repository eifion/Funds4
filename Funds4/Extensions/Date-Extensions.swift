import Foundation

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    func asISO8601Date() -> String {
        let calendar = Calendar.current
        let day = String(format: "%02d", calendar.component(.day, from: self))
        let month =   String(format: "%02d", calendar.component(.month, from: self))
        let year = calendar.component(.year, from: self)        
        return "\(year)-\(month)-\(day)"
    }
}
