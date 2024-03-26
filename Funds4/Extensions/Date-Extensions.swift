import Foundation

extension Date {
    func asISO8601Date() -> String {
        let calendar = Calendar.current
        let day = String(format: "%02d", calendar.component(.day, from: self))
        let month =   String(format: "%02d", calendar.component(.month, from: self))
        let year = calendar.component(.year, from: self)        
        return "\(year)-\(month)-\(day)"
    }
}
