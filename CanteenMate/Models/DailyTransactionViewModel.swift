import SwiftData
import Foundation

class DailyTransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    func fetch(for date: Date, context: ModelContext) {
        let calendar = Calendar.current

        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!

        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { transaction in
                transaction.date >= startOfDay && transaction.date <= endOfDay
            },
            sortBy: [SortDescriptor(\.date)]
        )

        do {
            transactions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch transactions: \(error)")
        }
    }
}
