//
//  AddMenuModal.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import SwiftUI

struct AddMenuModal: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var showCancelAlert: Bool = false
    @State private var showMissingFieldsAlert: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                Section {
                    Button(action: {
                        if let priceValue = Int(price) {
                            if !name.isEmpty && priceValue >= 0 {
                                let newItem = MenuModel(name: name, price: priceValue)
                                modelContext.insert(newItem)
                                try? modelContext.save()
                                dismiss()
                            }else{
                                showMissingFieldsAlert = true
                            }
                        }else {
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
            }.padding([.top], 16)
                .background(Color(.systemGray6))
                .navigationBarItems(
                    leading: Button("Cancel") {
                        if !name.isEmpty || !price.isEmpty {
                            showCancelAlert = true
                        }else {
                            dismiss()
                        }
                    }
                )
                .navigationTitle("Add Menu Item")
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
        }
    }
}
//#Preview {
//    AddMenuModal()
//}
