import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    var id: UUID
    var name: String
    var date: Date
    var amount: Int
    var type: TransactionType
    var count: Int
    var desc: String?
    
    init(id:UUID = UUID(), name: String, date: Date, amount: Int, type: TransactionType, count: Int, desc: String? = nil) {
        self.id = id
        self.name = name
        self.date = date
        self.amount = amount
        self.type = type
        self.count = count
        self.desc = desc
    }
}

enum TransactionType: String, CaseIterable, Codable {
    case income = "Income"
    case expense = "Expense"
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case preset = "Preset"
    case custom = "Custom"
}
