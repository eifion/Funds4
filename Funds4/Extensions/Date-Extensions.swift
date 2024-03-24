import Foundation

extension Date {
    func asISO8601Date() -> String {
        let calendar = Calendar.current;
        
        guard let todayAtMidnight = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self)) else {
           fatalError("Could not get date component of date")
        }

        return (todayAtMidnight.ISO8601Format(.iso8601Date(timeZone: .gmt)))
    }
}
