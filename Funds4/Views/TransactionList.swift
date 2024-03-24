import SwiftData
import SwiftUI

struct TransactionList: View {
    @Binding var selectedTab: Int
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
            
    var body: some View {
        NavigationView {
            Text("Hello, world!")
        }
        .onAppear(perform: checkForFund)
    }
    
    func checkForFund()
    {
        // If there are no funds on opening the app, switch to the Funds tab
        // so that one can be added.
        if (funds.isEmpty) {
            print("No funds. Switching to Funds view and showing new fund sheet.")
            self.selectedTab = 2;
            self.showAddFund = true
        }
    }
}

//#Preview {
//    TransactionList()
//}
