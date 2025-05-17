//
//  IncomeModeMenu.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI
import SwiftData

struct IncomeModeMenuView: View {
    @Binding var isCustomMode: Bool
    @Binding var isAddingIncome: Bool
    
    @State private var itemQuantities: [UUID: Int] = [:]
    @State private var selectedDate: Date = Date()

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var menuModels: [MenuModel]

    
    var totalPrice: Int {
        menuModels.reduce(0) { total, item in
            let qty = itemQuantities[item.id] ?? 0
            return total + item.price * qty
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
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

                            }.padding(.bottom)
                            

                            ForEach(menuModels) { item in
                                MenuCashierCard(
                                    title: item.name,
                                    price: item.price,
                                    numberOfTotal: Binding(
                                        get: { itemQuantities[item.id] ?? 0 },
                                        set: { itemQuantities[item.id] = $0 }
                                    )
                                )
                            }

                            Spacer()
                        }
                    }

                    HStack {
                        Text("Total: ")
                            .font(.body)
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(totalPrice.formattedWithSeparator())\t\(Image(systemName: "chevron.right"))")
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(totalPrice > 0 ? Color.blue : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .onTapGesture {
                        if totalPrice > 0 {
                            for item in menuModels {
                                let qty = itemQuantities[item.id] ?? 0
                                if qty > 0 {
                                    let newTransaction = Transaction(
                                        name: item.name,
                                        date: selectedDate,
                                        amount: item.price * qty,
                                        type: .income,
                                        count: qty
                                    )
                                    context.insert(newTransaction)
                                    try? context.save()
                                    print("- \(item.name): \(qty) x \(Int(item.price))")
                                }
                            }
                            print("Total: \(totalPrice)")
                            isAddingIncome = false
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            for item in menuModels {
                if itemQuantities[item.id] == nil {
                    itemQuantities[item.id] = 0
                }
            }
        }
    }
}

//
//#Preview {
//    IncomeModeMenuView()
//}
