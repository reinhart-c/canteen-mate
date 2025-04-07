//
//  IncomeModeMenu.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import SwiftUI

struct IncomeModeMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isCustomMode: Bool
    @Binding var isIncomeMode: Bool
    @State var value: String = ""
    
    @State private var menuItems: [MenuItem] = [
        MenuItem(name: "Mie Ayam Dinosaurus", price: 15000, numberOfTotal: 0),
        MenuItem(name: "Bakso Tahu", price: 20000, numberOfTotal: 0),
        MenuItem(name: "Es Teh Manis", price: 5000, numberOfTotal: 0)
    ]
    
    var totalPrice: Int {
        menuItems.reduce(0) { $0 + $1.price * $1.numberOfTotal }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        ZStack {
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
                                            for item in menuItems where item.numberOfTotal > 0 {
                                                print("- \(item.name): \(item.numberOfTotal) x \(item.price)")
                                            }
                                            print("Total: \(totalPrice)")
                                            dismiss()
                                        }
                                    )
                                }
                                .padding(20)
                                
                                IncomeExpenseButtonView(isIncomeMode: $isIncomeMode)
                                
                                VStack {
                                    DatePickerView()
                                    
                                    ForEach($menuItems) { $item in
                                        MenuCashierCard(title: item.name, price: item.price, numberOfTotal: $item.numberOfTotal)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    Spacer()
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
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    struct MenuItem: Identifiable {
        let id = UUID()
        var name: String
        var price: Int
        var numberOfTotal: Int
    }
}

#Preview {
    IncomeModeMenuView(isCustomMode: .constant(false), isIncomeMode: .constant(false))
}
