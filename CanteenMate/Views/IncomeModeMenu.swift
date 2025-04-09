//
//  IncomeModeMenu.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI
import SwiftData

struct IncomeModeMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isCustomMode: Bool
    @Binding var isIncomeMode: Bool
    @State private var selectedDate: Date = Date()

    @Environment(\.modelContext) private var context
    @Query private var menuModels: [MenuModel]

    @State private var itemQuantities: [UUID: Int] = [:]
    
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
                                CancelDoneButtonView(
                                    text: "Cancel",
                                    action: {
                                        dismiss()
                                    }
                                )
                                Spacer()
                                CancelDoneButtonView(
                                    text: "Done",
                                    action: {
                                        print("Income from menu saved:")
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
                                                print("- \(item.name): \(qty) x \(Int(item.price))")
                                            }
                                        }
                                        print("Total: \(totalPrice)")
                                        dismiss()
                                    }
                                )
                            }
                            .padding(20)

                            IncomeExpenseButtonView(isIncomeMode: $isIncomeMode)

                            DatePickerView(selectedDate: $selectedDate)

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

                        Text("\(totalPrice.formattedWithSeparator())")
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(.darkGray))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    ToggleView(isCustomMode: $isCustomMode)
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


#Preview {
    PreviewContainerView()
}
