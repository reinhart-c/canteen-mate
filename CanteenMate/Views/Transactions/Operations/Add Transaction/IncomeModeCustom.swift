//
//  IncomeModeCustom.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI

struct IncomeModeCustomView: View {
    @Binding var isCustomMode: Bool
    @Binding var isAddingIncome: Bool
    
    @State private var selectedDate: Date = Date()
    @State private var amountText: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showMissingFieldsAlert = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack{
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
                                selectedDate = newDate
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(.horizontal)
                        Button(action: {
                            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
                                selectedDate = newDate
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    Form{
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
                                                date: selectedDate,
                                                amount: amount,
                                                type: .income,
                                                count: 1,
                                                desc: description
                                            )
                                            context.insert(newTransaction)
                                            try? context.save()
                                            isAddingIncome = false
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
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

//#Preview {
////    IncomeModeCustomView(isCustomMode: .constant(false))
//}
