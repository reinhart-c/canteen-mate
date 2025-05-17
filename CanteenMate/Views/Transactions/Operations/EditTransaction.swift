import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Bindable var transaction: Transaction
    
    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    @State private var showDeleteAlert = false
    @State private var amountText: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: transaction.date) {
                                transaction.date = newDate
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        DatePicker("", selection: $transaction.date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(.horizontal)
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: transaction.date) {
                                transaction.date = newDate
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        
                    }
                    
                    Form {
                        TextField("Title", text: $transaction.name)
                        TextField("Amount", text: $amountText).keyboardType(.decimalPad)
                        ZStack(alignment: .topLeading){
                            TextEditor(text: Binding(
                                get: { transaction.desc ?? "" },
                                set: { transaction.desc = $0.isEmpty ? nil : $0 }
                            )).frame(minHeight: 250, maxHeight: 250)
                            Text("Description").foregroundColor(Color(.systemGray2))
                                .padding(.top, 10)
                                .padding(.leading, 5)
                                .opacity(transaction.desc == "" ? 100 : 0)
                        }
                        Section {
                            Button(action: {
                                if let amount = Int(amountText) {
                                    transaction.amount = amount
                                    if transaction.name.isEmpty || transaction.amount <= 0 {
                                        showMissingFieldsAlert = true
                                    } else {
                                        try? context.save()
                                        dismiss()
                                    }
                                }else{
                                    showMissingFieldsAlert = true
                                }
                            }, label:
                                    {
                                Text("Save")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding([.top, .bottom], 4)
                            }).buttonStyle(.borderedProminent)
                                .listRowBackground(Color.clear)
                        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        Section {
                            Button(role: .destructive, action: {
                                showDeleteAlert = true
                            }, label: {
                                Text("Delete Transaction")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding([.top, .bottom], 4)
                            }).buttonStyle(.borderedProminent)
                                .listRowBackground(Color.clear)
                        }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listSectionSpacing(12)
                    }
                }
                .padding([.top], 48)
            }
            .onAppear {
                amountText = String(transaction.amount)
            }.navigationBarItems(
                leading: Button("Cancel") {
                    showCancelAlert = true
                }
            ).navigationTitle("Edit Transaction")
                .background(Color(.systemGray6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel editing this transaction?")
        }
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Delete this transaction?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                context.delete(transaction)
                try? context.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
