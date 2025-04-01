import SwiftUI

// ✅ Menu Item Model
class Menu: Identifiable, ObservableObject {
    let id = UUID()
    let name: String
    let price: Double
    @Published var quantity: Int = 0  // Track selected quantity
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}

// ✅ Sample Menu Items (Simulating a Large Menu)
let sampleMenus: [Menu] = [
    Menu(name: "Nasi Goreng", price: 25000),
    Menu(name: "Mie Ayam", price: 20000),
    Menu(name: "Soto Ayam", price: 28000),
    Menu(name: "Bakso", price: 23000),
    Menu(name: "Es Teh", price: 5000),
    Menu(name: "Es Jeruk", price: 7000),
    Menu(name: "Nasi Padang", price: 35000),
    Menu(name: "Ayam Geprek", price: 27000),
    Menu(name: "Sate Ayam", price: 30000),
    Menu(name: "Ikan Bakar", price: 40000),
    Menu(name: "Tahu Sumedang", price: 10000),
    Menu(name: "Martabak Manis", price: 45000)
]

// ✅ Add Transaction View
struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss

    @State private var transactionType: TransactionType = .income
    @State private var searchText: String = ""
    @State private var isCustomExpense: Bool = false
    
    // ✅ Custom Expense Fields
    @State private var customTitle: String = ""
    @State private var customAmount: String = ""
    @State private var customDescription: String = ""
    @State private var customDate: Date = Date()
    
    // ✅ Use @StateObject to track selected menu items
    @StateObject private var menuItems = MenuList()

    var body: some View {
        NavigationView {
            VStack {
                // ✅ Segmented Control for Income vs Expense
                Picker("Transaction Type", selection: $transactionType) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expense").tag(TransactionType.expense)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if transactionType == .expense {
                    // ✅ Search Bar
                    TextField("Search menu...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    // ✅ Filtered Menu List
                    List {
                        ForEach(menuItems.items.filter { menu in
                            searchText.isEmpty || menu.name.localizedCaseInsensitiveContains(searchText)
                        }) { menu in
                            HStack {
                                Text(menu.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                // ✅ Decrease Button
                                Button(action: {
                                    if menu.quantity > 0 {
                                        menu.quantity -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(menu.quantity > 0 ? .red : .gray)
                                }
                                
                                // ✅ Quantity Label
                                Text("\(menu.quantity)")
                                    .frame(width: 40, alignment: .center)
                                
                                // ✅ Increase Button
                                Button(action: {
                                    menu.quantity += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .frame(maxHeight: 250) // Limit height for scrolling
                }

                // ✅ Custom Expense Section
                if transactionType == .expense {
                    Toggle("Custom Expense", isOn: $isCustomExpense)
                        .padding()

                    if isCustomExpense {
                        VStack {
                            TextField("Title", text: $customTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)

                            DatePicker("Select Date", selection: $customDate, displayedComponents: .date)
                                .padding(.horizontal)

                            TextField("Amount (IDR)", text: $customAmount)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)

                            TextField("Description (Optional)", text: $customDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 5)
                    }
                }

                // ✅ Save Button
                Button("Save Transaction") {
                    saveTransaction()
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    func saveTransaction() {
        // ✅ Calculate total expense based on selected menu items
        let total = menuItems.items.reduce(0) { result, menu in
            result + (menu.price * Double(menu.quantity))
        }
        print("Total Expense: Rp \(total)")

        if isCustomExpense {
            print("Custom Order - Title: \(customTitle), Amount: Rp \(customAmount), Date: \(customDate), Description: \(customDescription)")
        }
    }
}

// ✅ Menu List Manager (Observable for Updates)
class MenuList: ObservableObject {
    @Published var items: [Menu] = sampleMenus
}

#Preview {
    AddTransactionView()
}
