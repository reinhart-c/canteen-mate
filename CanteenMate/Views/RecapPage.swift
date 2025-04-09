import SwiftUI
import SwiftData

struct RecapPage: View {
    @State private var isMonthly = true
    @State private var selectedDate = Date()
    @State private var isShowingTransactionModal = false
    @State private var isEmpty = false

    @Environment(\.modelContext) private var context
    @Query private var transactions: [Transaction]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: { isMonthly = false }) {
                        Text("Daily")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(isMonthly ? Color.gray.opacity(0.2) : Color.accentColor)
                            .foregroundColor(isMonthly ? .primary : .white)
                            .cornerRadius(8)
                    }
                    .padding(.leading, 18)

                    Button(action: { isMonthly = true }) {
                        Text("Monthly")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(isMonthly ? Color.accentColor : Color.gray.opacity(0.2))
                            .foregroundColor(isMonthly ? .white : .primary)
                            .cornerRadius(8)
                    }
                }

                if !isMonthly {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(.horizontal)
                } else {
                    YearMonthPickerView(selectedDate: $selectedDate)
                        .padding(.leading, 18)
                }

                ZStack {
                    if !isEmpty {
                        if isMonthly {
                            MonthlyTransaction(selectedDate: selectedDate, isEmpty: $isEmpty)
                        } else {
                            DailyTransaction(selectedDate: selectedDate, isEmpty: $isEmpty)
                        }
                    }

                    if isEmpty {
                        ContentUnavailableView(label: {
                            Label("No Transactions", systemImage: "list.bullet.rectangle.portrait")
                        }, description: {
                            Text("Start adding expenses to see your list.")
                        })
                        .offset(y: -60)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.systemGray6))
            .sheet(isPresented: $isShowingTransactionModal) {
                TransactionModal()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recap")
                        .font(.title)
                        .fontWeight(.bold)
                }
            
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingTransactionModal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)

    let context = modelContainer.mainContext
    let calendar = Calendar.current
    let now = Date()

    // Sample dates throughout the month
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

    return RecapPage()
        .modelContainer(modelContainer)
}

enum TimeFilter {
    case daily, monthly
}
