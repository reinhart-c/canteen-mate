import SwiftUI

struct RecapPage: View {
    @State private var isMonthly = true
    @State private var selectedDate = Date()
    
    let transactions: [Transaction] = generateRobustTransactions()

    var body: some View {

        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: { isMonthly = false }) {
                        Text("Daily")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(isMonthly ? Color.gray.opacity(0.2) : Color.blue)
                            .foregroundColor(isMonthly ? .black : .white)
                            .cornerRadius(8)
                    }
                    .padding(.leading, 18)
                    
                    Button(action: { isMonthly = true }) {
                        Text("Monthly")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(isMonthly ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(isMonthly ? .white : .black)
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
                if !isMonthly {
                    DailyTransaction(transactions: transactions, selectedDate: selectedDate)
                } else {
                    MonthlyTransaction(transactions: transactions, selectedDate: selectedDate)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recent")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("Add button tapped")
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .background(Color(uiColor: .systemGray6))
        }
    }
}

#Preview {
    RecapPage()
}

enum TimeFilter {
    case daily, monthly
}
