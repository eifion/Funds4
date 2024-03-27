import SwiftData
import SwiftUI

struct TransferEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Fund.isDefault, order: .reverse), SortDescriptor(\Fund.name)])
        var funds: [Fund]
    
    @State var sourceFund: Fund?
    @State var destinationFund: Fund?
    @State var name = ""
    @State var amount = 0.00
    @State var date: Date = Date.now
    
    let rowHeight: CGFloat = 44

    var body: some View {
        NavigationView {
            VStack {
                
                // Source Fund
                HStack {
                    Text("Source Fund:")
                    
                    Spacer()
                    
                    Picker("From:", selection: $sourceFund) {
                        Text("Select").tag(nil as Fund?)
                        ForEach(funds) { fund in
                            Text(fund.name).tag(fund as Fund?)
                        }
                    }.pickerStyle(.menu)
                }.frame(height: rowHeight)
                
                // Destination Fund
                HStack {
                    Text("Destination Fund:")
                    
                    Spacer()
                    
                    Picker("From:", selection: $destinationFund) {
                        Text("Select").tag(nil as Fund?)
                        ForEach(funds) { fund in
                            Text(fund.name).tag(fund as Fund?)
                        }
                    }.pickerStyle(.menu)
                }.frame(height: rowHeight)
                
                // Name
                HStack {
                    Text("Name:")
                    Spacer()
                    TextField("", text: $name)
                }
                .frame(height: rowHeight)
                
                // Amount
                HStack {
                    Text("£")
                    TextField("Amount", value: $amount, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }.frame(height: rowHeight)

                
                HStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }.frame(height: rowHeight)
            }
            .navigationBarTitle("Transfer", displayMode: .inline)
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {
                       dismiss()
                    })
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: {
                        save()
                        dismiss()
                    }).disabled(isInvalid())
                }
            }
            .navigationBarTitle("Transfer", displayMode: .inline)
            
            Spacer()
        }
    }
    
    func isInvalid() -> Bool {
        if (amount <= 0.0) {
            return true
        }
        
        if (name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return true
        }
        
        guard let sourceFund = sourceFund else {
            return true
        }
        
        guard let destinationFund = destinationFund else {
            return true
        }
        
        return sourceFund.name == destinationFund.name
    }
    
    func save()
    {
        // A transfer is saved as a new outgoing and a new incoming, to keep the amounts balanced.
        // One is then hidden in the list.
        let amountAsInt = Int(truncating: (amount * 100.0) as NSNumber)
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateAsString = date.asISO8601Date()


        let newOutgoing = Transaction(name: trimmedName, startDate: dateAsString, endDate: dateAsString, amount: amountAsInt * -1)
        newOutgoing.fund = sourceFund
        modelContext.insert(newOutgoing)

        let newIncoming = Transaction(name: trimmedName, startDate: dateAsString, endDate: dateAsString, amount: amountAsInt)
        newIncoming.fund = destinationFund
        modelContext.insert(newIncoming)
        
        newOutgoing.transferTransaction = newIncoming
        newIncoming.transferTransaction = newOutgoing
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TransferEditor()
    }
}
