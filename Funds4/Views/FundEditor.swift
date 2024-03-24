import SwiftData
import SwiftUI

struct FundEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
    
    @State var name = ""
    @State var openingBalance: Decimal = 0.0
    @State var startDate = Date.now
    @State var buttonText = "Add"
    @State var showUniqueNameAlert = false
    @State var isDefaultFund: Bool = false

    @FocusState var focusNameField: Bool?
    
    let fundToEdit: Fund?
    let rowHeight: CGFloat = 44
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Name
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Name", text: $name)
                        .multilineTextAlignment(.trailing)
                        .labelStyle(.titleAndIcon)
                        .focused($focusNameField, equals: true)
                }.frame(height: rowHeight)
                
                // Amount
                HStack {
                    Text("Opening Balance")
                    Spacer()
                    Text("£")
                    TextField("Opening Balance", value: $openingBalance, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                }.frame(height: rowHeight)
                
                // Start date
                HStack {
                    Text("Start Date")
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    DatePicker("Date", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                }.frame(height: rowHeight)
                
                Spacer()
            }
            .navigationBarTitle("Fund", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(buttonText) {
                        save()
                    }
                }
            }
            .alert("Name must be unique", isPresented: $showUniqueNameAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear(perform: populateFund)
        }.padding()
    }
    
    func populateFund() {
        if let fundToEdit {
            // Editing existing fund
            name = fundToEdit.name
            // etc.
        } else {
            // New fund
            if (funds.isEmpty) {
                name = "Default fund"
                isDefaultFund = true
            }
        }
        
        focusNameField = true
    }
    
    func save() {
        let openingBalanceAsInt = Int(truncating: (openingBalance * 100.0) as NSNumber)
        let startDateAsString = startDate.asISO8601Date()
        
        if let fundToEdit {
            // Update existing fund.
        }
        else {
            // Add new fund.
            let newFund = Fund(name: name, startDate: startDateAsString, openingBalance: openingBalanceAsInt, transactions: [], isDefault: isDefaultFund)
            modelContext.insert(newFund)
            dismiss()
        }

    }
}

#Preview {
    FundEditor(fundToEdit: nil)
}
