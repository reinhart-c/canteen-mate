import SwiftData
import Foundation

class MonthlyTransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    func fetch(for date: Date, context: ModelContext) {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            print("Invalid month interval")
            return
        }
        let start = monthInterval.start
        let end = monthInterval.end.addingTimeInterval(-1)
        print("end value: \(end)")

        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.date >= start && $0.date <= end },
            sortBy: [SortDescriptor(\.date)]
        )

        do {
            transactions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch transactions: \(error)")
        }
    }
}
