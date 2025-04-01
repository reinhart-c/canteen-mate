import Foundation
//import SwiftData
//
//@Model
class Transaction: Identifiable {
    var id: UUID
    var name: String
    var date: Date
    var amount: Int
    var type: TransactionType
    var count: Int
    var description: String?
    
    init(name: String, date: Date, amount: Int, type: TransactionType, count: Int, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.amount = amount
        self.type = type
        self.count = count
        self.description = description
    }
}

enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

enum ExpenseCategory: String, CaseIterable {
    case preset = "Preset"
    case custom = "Custom"
}

func generateRobustTransactions() -> [Transaction] {
    var transactions: [Transaction] = []
    let calendar = Calendar.current
    let startDate = calendar.date(from: DateComponents(year: 2025, month: 2, day: 1))!
    let today = Date()
    
    let transactionNames = ["Breakfast Sale", "Lunch Sale", "Snack Sale", "Ingredient Purchase", "Equipment Maintenance", "Miscellaneous Expense"]
    
    var date = startDate
    while date <= today {
        let transactionCount = Int.random(in: 2...5)
        
        for _ in 0..<transactionCount {
            let randomHour = Int.random(in: 8...18)
            let randomMinute = Int.random(in: 0...59)
            let randomAmount = Int.random(in: 5000...100000)
            let randomType: TransactionType = Bool.random() ? .income : .expense
            let randomName = transactionNames.randomElement()!
            
            var components = calendar.dateComponents([.year, .month, .day], from: date)
            components.hour = randomHour
            components.minute = randomMinute
            let randomTimestamp = calendar.date(from: components)!
            
            let transaction = Transaction(
                name: randomName,
                date: randomTimestamp,
                amount: randomAmount,
                type: randomType,
                count: Int.random(in: 1...5), // Random quantity
                description: Bool.random() ? "Additional notes" : nil
            )
            transactions.append(transaction)
        }
        
        // Move to the next day
        date = calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    return transactions
}
