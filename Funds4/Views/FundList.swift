import SwiftData
import SwiftUI

struct FundList: View {
    @Binding var showAddFund: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Fund.isDefault, order: .reverse), SortDescriptor(\Fund.name)])
        var funds: [Fund]
    
    @State private var fundToEdit: Fund?
    
    var body: some View {
        NavigationView {
            List(funds) { fund in
                FundRow(fund: fund)
                    .swipeActions(allowsFullSwipe: false) {
                        // Edit transaction button
                        Button {
                            fundToEdit = fund
                        }
                    label: {
                        Label("Edit", systemImage: "pencil")
                    }.tint(.indigo)
                    }
            }
            .listStyle(.grouped)
            .navigationTitle("Funds")
            .sheet(isPresented: $showAddFund) {
                FundEditor(fundToEdit: nil)
                    .presentationDetents([.medium])
            }
            .sheet(item: $fundToEdit, onDismiss: {
                // Update balances...
            }) { item in
                FundEditor(fundToEdit: item)
                    .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Fund", systemImage: "plus") {
                        showAddFund = true
                    }
                }
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
