import SwiftData
import SwiftUI

struct FundEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query var funds: [Fund]
    
    @State var name = ""
    @State var openingBalance: Decimal?
    @State var startDate = Date.now
    @State var buttonText = "Add"
    @State var showUniqueNameAlert = false
    @State var isDefaultFund = false

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
                        .keyboardType(.numbersAndPunctuation)
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
                        let fundNames = funds.map { $0.name }
                                                    
                        var fundNameIsUnique = false
                        if let fundToEdit {
                            fundNameIsUnique = fundToEdit.name == name || fundNames.contains(name) == false
                        } else {
                            fundNameIsUnique = fundNames.contains(name) == false
                        }
                                                     
                        guard (fundNameIsUnique) else {
                            showUniqueNameAlert = true
                            return;
                        }
                        
                        save()
                        dismiss() 
                    }.disabled(isInvalid)
                }
            }
            .alert("Name must be unique", isPresented: $showUniqueNameAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear(perform: populateFund)
        }.padding()
    }
    
    var isInvalid: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || openingBalance ==  nil
    }
    
    func populateFund() {
        if let fundToEdit {
            name = fundToEdit.name
            openingBalance = Decimal(abs((Double(fundToEdit.openingBalance)) / 100.0))
            startDate = fundToEdit.startDate.toDate(region: .UTC)?.date ?? Date.now
            buttonText = "Update"
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
        let openingBalanceAsInt = Int(truncating: (openingBalance ?? 0) * 100.0 as NSNumber)
        let startDateAsString = startDate.toISO(.withFullDate)
        
        if let fundToEdit {
            fundToEdit.name = name
            fundToEdit.openingBalance = openingBalanceAsInt
            fundToEdit.startDate = startDate.toISO(.withFullDate)
            fundToEdit.calculateCurrentBalance()
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
