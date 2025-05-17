//
//  EditMenuModal.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import SwiftUI

struct EditMenuModal: View {
    @Binding var item: MenuModel
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var showCancelAlert: Bool = false
    @State private var showMissingFieldsAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    init(item: Binding<MenuModel>) {
        self._item = item
        _name = State(initialValue: item.wrappedValue.name)
        _price = State(initialValue: String(item.wrappedValue.price))
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                Section {
                        Button(action: {
                            if let priceValue = Int(price) {
                                if !name.isEmpty && priceValue >= 0{
                                    item.name = name
                                    item.price = priceValue
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
                Section {
                    Button(role: .destructive, action: {
                            showDeleteAlert = true
                    }, label: {
                        Text("Delete Item")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding([.top, .bottom], 4)
                    }).buttonStyle(.borderedProminent)
                        .listRowBackground(Color.clear)
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listSectionSpacing(12)
            }.background(Color(.systemGray6))
            .navigationBarItems(
                leading: Button("Cancel") {
                    showCancelAlert = true
                }
            )
            .navigationTitle("Edit Menu Item")
        }.alert("Clear this entry?", isPresented: $showCancelAlert) {
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
                modelContext.delete(item)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

//#Preview {
//    EditMenuModal()
//}
