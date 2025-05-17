import Foundation
import SwiftUI

struct AddExpenseModal: View {
    @State private var date = Date()
    @State private var amountText: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date) {
                                date = newDate
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(.horizontal)
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) {
                                date = newDate
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }

                    }
                    
                    Form {
                        TextField("Title", text: $title)
                        TextField("Amount", text: $amountText).keyboardType(.decimalPad)
                        ZStack(alignment: .topLeading){
                            TextEditor(text: $description).frame(minHeight: 250, maxHeight: 250)
                            Text("Description").foregroundColor(Color(.systemGray2))
                                .padding(.top, 10)
                                .padding(.leading, 5)
                                .opacity(description == "" ? 100 : 0)
                        }
                        
                        Section {
                                Button(action: {
                                    if let amount = Int(amountText){
                                        if title.isEmpty || amount <= 0 {
                                            showMissingFieldsAlert = true
                                        } else {
                                            let newTransaction = Transaction(
                                                name: title,
                                                date: date,
                                                amount: amount,
                                                type: .expense,
                                                count: 1,
                                                desc: description
                                            )
                                            context.insert(newTransaction)
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
                    }
                }.padding([.top], 48)
            }
            .alert("Clear this entry?", isPresented: $showCancelAlert) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                Button("Stay", role: .cancel) {}
            } message: {
                Text("You have unsaved data. Are you sure you want to cancel?")
            }
            .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
                Button("OK", role: .cancel) {}
            }.navigationBarItems(
                leading: Button("Cancel") {
                    if let amount = Int(amountText){
                        if !title.isEmpty || amount > 0 || !description.isEmpty {
                            showCancelAlert = true
                        } else {
                            dismiss()
                        }
                    }else{
                        dismiss()
                    }
                }
            ).navigationTitle("Add Expense")
                .background(Color(.systemGray6))
        }
    }
}

//#Preview {
//    AddExpenseModal()
//}
