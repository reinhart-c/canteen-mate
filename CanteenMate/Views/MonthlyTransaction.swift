import SwiftUI

struct MonthlyTransaction: View {
    let transactions: [Transaction]
    let selectedDate: Date
    
    var groupedTransactions: [(String, Int)] {
        let calendar = Calendar.current
        let filteredTransactions = transactions.filter {
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: selectedDate) &&
            calendar.component(.month, from: $0.date) == calendar.component(.month, from: selectedDate)
        }
        
        let grouped = Dictionary(grouping: filteredTransactions, by: { transaction in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: transaction.date)
        }).mapValues { transactions in
            transactions.reduce(0) {
                $0 + ($1.type == .income ? $1.amount : -$1.amount)
            }
        }
        
        return grouped.sorted(by: { $0.0 < $1.0 }) // Sort by date
    }
    
    var body: some View {
        ZStack {
                List(groupedTransactions, id: \.0) { date, total in
                    HStack {
                        Text(date)
                            .frame(width: 80, alignment: .leading)
                        Spacer()
                        Text("Rp \(total)")
                            .bold()
                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(total < 0 ? .red : .green)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .allowsTightening(true)
                    }
                }
                
                if groupedTransactions.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    })
                    .offset(y: -60)
                }
            }
    }
}

#Preview {
    MonthlyTransaction(transactions: [Transaction(name: "test", date: Date(), amount: 10000, type: .income, count: 2)], selectedDate: Date())
}
