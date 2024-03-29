import Foundation

extension Int {
    var asCurrency: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "GBP"
        let amount = Decimal(self) / pow(10, currencyFormatter.minimumFractionDigits)
        return currencyFormatter.string(from: NSDecimalNumber(decimal: amount)) ?? "-.--"
    }       
}
