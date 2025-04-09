//
//  IncomeModeCustom.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI

struct IncomeModeCustomView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isCustomMode: Bool
    @Binding var isIncomeMode: Bool
    @State private var selectedDate: Date = Date()
    @State private var amount: Int = 0
    @State private var title: String = ""
    @State private var description: String = ""
    @Environment(\.modelContext) private var context
    
    @State private var showCancelAlert = false
    @State private var showMissingFieldsAlert = false
    
    var body: some View {
        VStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                CancelDoneButtonView(
                                    text: "Cancel",
                                    action: {
                                        if !title.isEmpty || amount > 0 || !description.isEmpty {
                                            showCancelAlert = true
                                        } else {
                                            dismiss()
                                        }
                                    }
                                )
                                Spacer()
                                CancelDoneButtonView(
                                    text: "Done",
                                    action: {
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
                                            dismiss()
                                        }
                                    }
                                )
                            }
                            .padding(20)
                            
                            IncomeExpenseButtonView(isIncomeMode: $isIncomeMode)
                            
                            VStack(spacing: 12) {
                                CustomTextFieldForDate(label: "Date", selectedDate: $selectedDate)
                                CustomTextFieldForString(label: "Title", text: $title)
                                CustomTextFieldForInt(label: "Amount", text: $amount)
                                CustomTextFieldForString(label: "Description", text: $description)
                            }
                            .padding()
                        }
                    }
                    Spacer()
                    
                    ToggleView(isCustomMode: $isCustomMode)
                }
//                .ignoresSafeArea(edges: .bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Clear this entry?", isPresented: $showCancelAlert) {
            Button("Reset and Exit", role: .destructive) {
                resetForm()
                dismiss()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("You have unsaved data. Are you sure you want to cancel?")
        }
        .alert("Please fill in title and amount!", isPresented: $showMissingFieldsAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    func resetForm() {
        title = ""
        amount = 0
        description = ""
        selectedDate = Date()
    }
}

#Preview {
    IncomeModeCustomView(isCustomMode: .constant(false), isIncomeMode: .constant(true))
}
