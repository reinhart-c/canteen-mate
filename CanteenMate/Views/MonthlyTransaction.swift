import SwiftUI
import SwiftData

struct MonthlyTransaction: View {
    @Environment(\.modelContext) private var context
    @Environment(\.calendar) private var calendar
    @Binding var isEmpty: Bool
    
    let selectedDate: Date
    
    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
    }
    
    private var endOfMonth: Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    }
    
    @Query private var transactions: [Transaction]
    init(selectedDate: Date, isEmpty: Binding<Bool>) {
        self._isEmpty = isEmpty
        self.selectedDate = selectedDate
        
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            print("Invalid month interval")
            return
        }
        let start = monthInterval.start
        let end = monthInterval.end.addingTimeInterval(-1)
        
        _transactions = Query(filter: #Predicate { transaction in
            transaction.date >= start && transaction.date <= end
        }, sort: [SortDescriptor(\.date)])
    }
    
    var groupedTransactions: [(String, Int)] {
        let grouped = Dictionary(grouping: transactions, by: { transaction in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: transaction.date)
        }).mapValues { transactions in
            transactions.reduce(0) {
                $0 + ($1.type == .income ? $1.amount : -$1.amount)
            }
        }
        
        return grouped.sorted(by: { $0.0 < $1.0 })
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                if !isEmpty {
                    let totalIncome = groupedTransactions
                        .map { $0.1 }
                        .filter { $0 > 0 }
                        .reduce(0, +)

                    let totalExpense = groupedTransactions
                        .map { $0.1 }
                        .filter { $0 < 0 }
                        .reduce(0, +)
                    
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "Income",
                            amount: totalIncome,
                            color: .green,
                            imageName: "chart.line.uptrend.xyaxis"
                        )
                        SummaryCard(
                            title: "Expenses",
                            amount: abs(totalExpense),
                            color: .red,
                            imageName: "chart.line.downtrend.xyaxis"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .zIndex(1)
                    
                    List(groupedTransactions, id: \.0) { date, total in
                        HStack {
                            Text(date)
                                .frame(width: 80, alignment: .leading)
                            Spacer()
                            Text("Rp\(abs(total))")
                                .bold()
                                .frame(width: 100, alignment: .trailing)
                                .foregroundColor(total < 0 ? .red : .green)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .allowsTightening(true)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.top, -30)
                }
            }
        }
        .background(
            Color(UIColor { trait in
                trait.userInterfaceStyle == .dark ? .black : .systemGray6
            })
        )

        .onAppear {
            isEmpty = groupedTransactions.isEmpty
        }
        .onChange(of: groupedTransactions.count, { _, _ in
            isEmpty = groupedTransactions.isEmpty
        })
        .onChange(of: selectedDate) {
            isEmpty = groupedTransactions.isEmpty
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)
    
    let context = modelContainer.mainContext
    let calendar = Calendar.current
    let now = Date()

    let sampleDates = [
        now,
        calendar.date(byAdding: .day, value: -1, to: now)!,
        calendar.date(byAdding: .day, value: -2, to: now)!,
        calendar.date(byAdding: .day, value: -7, to: now)!,
        calendar.date(byAdding: .day, value: -14, to: now)!
    ]

    let dummyData = [
        Transaction(name: "Salary", date: sampleDates[0], amount: 5000000, type: .income, count: 1),
        Transaction(name: "Lunch", date: sampleDates[1], amount: 25000, type: .expense, count: 1),
        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
        Transaction(name: "Internet", date: sampleDates[2], amount: 150000, type: .expense, count: 1),
        Transaction(name: "Side Job", date: sampleDates[3], amount: 1000000, type: .income, count: 1),
        Transaction(name: "Groceries", date: sampleDates[4], amount: 200000, type: .expense, count: 1),
    ]

    dummyData.forEach { context.insert($0) }

    return MonthlyTransaction(selectedDate: now, isEmpty: .constant(false))
        .modelContainer(modelContainer)
}
