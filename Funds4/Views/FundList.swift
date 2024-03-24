import SwiftUI

struct FundList: View {
    @Binding var showAddFund: Bool
    
    var body: some View {
        Text("Hello, Funds!")
            .sheet(isPresented: $showAddFund) {
               FundEditor(fundToEdit: nil)
                   .presentationDetents([.medium])
           }
        
    }
}

#Preview {
    FundList(showAddFund: .constant(false))
}
