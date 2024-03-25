import SwiftData
import SwiftUI

struct FundList: View {
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Fund.isDefault, order: .reverse), SortDescriptor(\Fund.name)])
        var funds: [Fund]
    
    var body: some View {
        NavigationView {
            List(funds) { fund in
                FundRow(fund: fund)
            }
            .listStyle(.grouped)
            .navigationTitle("Funds")
            .sheet(isPresented: $showAddFund) {
                FundEditor(fundToEdit: nil)
                    .presentationDetents([.medium])
            } 
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TabView {
            FundList(showAddFund: .constant(false))
                .tabItem { Label("Funds", systemImage: "sterlingsign") }
        }
    }

}
