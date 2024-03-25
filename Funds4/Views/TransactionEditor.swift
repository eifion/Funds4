import SwiftData
import SwiftUI

struct TransactionEditor: View {
    @State var fund: Fund
    @State var transactionToEdit: Transaction?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @FocusState var focusNameField: Bool?
    
    @Query var funds: [Fund]
    
    @State var isOutgoing = true
    @State var name = ""
    @State var amount: Decimal = 0.00
    @State var startDate = Date.now
    @State var endDate = Date.now
    @State var buttonText = "Add"
    
    let rowHeight: CGFloat = 44
        
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Incoming / Outgoing
                    Picker("", selection: $isOutgoing) {
                        Text("Outgoing").tag(true)
                        Text("Incoming").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                .frame(height: rowHeight)
                
                // Fund
                HStack {
                    Text("Fund:")
                    Spacer()
                    Picker("Fund", selection: $fund) {
                        ForEach(funds) { fund in
                            Text(fund.name).tag(fund)
                        }
                    }.pickerStyle(.menu)
                }
                .frame(height: rowHeight)
                
                // Name
                HStack {
                    Text("Name:")
                    Spacer()
                    TextField("", text: $name)
                }
                .frame(height: rowHeight)
                .focused($focusNameField, equals: true)
                
                // Amount
                HStack {
                    Text("Amount")
                    Spacer()
                    Text("£")
                    TextField("Amount", value: $amount, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }
                .frame(height: rowHeight)

                // Dates
                HStack {
                    DatePicker("Date", selection: $startDate, in: getPickerDateRange(), displayedComponents: .date)
                }
                .frame(height: rowHeight)

                if (!isOutgoing) {
                    HStack {
                        DatePicker("End Date", selection: $endDate, in: getPickerDateRange(), displayedComponents: .date)
                    }
                    .frame(height: rowHeight)
                }
                
                Spacer()
                            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(buttonText) {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }.disabled(isInvalid())
                }
            }
            .navigationBarTitle("Transaction", displayMode: .inline)
            .padding()
            .onAppear {
                if let transactionToEdit {
                    name = transactionToEdit.name
                    startDate = transactionToEdit.startDateAsDate
                    endDate = transactionToEdit.endDateAsDate
                    amount = Decimal(abs((Double(transactionToEdit.amount)) / 100.0))
                    isOutgoing = transactionToEdit.amount <= 0
                    fund = transactionToEdit.fund!
                    buttonText = "Update"
                }
                
                focusNameField = true
            }
        }
    }
    
    private func getPickerDateRange() -> PartialRangeFrom<Date> {
        fund.startDateAsDate...
    }
    
    private func isInvalid() -> Bool {
        // The entered value must always be > 0. Negative incomings or outgoings make no sense.
        let amountIsInvalid = amount <= 0
        return name.isEmpty || amountIsInvalid || startDate > endDate
    }
    
    private func save() {
        var amountAsInt = Int(truncating: (amount * 100.0) as NSNumber)
        if (isOutgoing) {
            amountAsInt *= -1
            endDate = startDate
        }
        
        if let transactionToEdit {
            // Update
            transactionToEdit.name = name
            transactionToEdit.startDate = startDate.asISO8601Date()
            transactionToEdit.endDate = endDate.asISO8601Date()
            transactionToEdit.amount = amountAsInt
            transactionToEdit.fund = fund
        } else {
            // Add
            let newTransaction = Transaction(name: name, startDate: startDate.asISO8601Date(), endDate: endDate.asISO8601Date(), amount: amountAsInt)
            newTransaction.fund = fund
            modelContext.insert(newTransaction)
        }
        fund.calculateCurrentBalance()
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TransactionEditor(fund: Fund.mainFund, transactionToEdit: nil as Transaction?)
    }
}
