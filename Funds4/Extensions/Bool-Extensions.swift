import Foundation

// This is here so that SwiftData can order by a boolean field.
extension Bool: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
