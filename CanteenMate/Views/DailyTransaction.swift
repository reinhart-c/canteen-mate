import SwiftUI

struct DailyTransaction: View {
    let transactions: [Transaction]
    let selectedDate: Date
    
    var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        return transactions.filter {
            calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            SummaryCard(title: "Income", amount: filteredTransactions.filter{$0.type == .income}.reduce(0){$0 + $1.amount}, color: Color.green, imageName: "chart.line.uptrend.xyaxis")
            SummaryCard(title: "Expenses", amount: filteredTransactions.filter{$0.type == .expense}.reduce(0){$0 + $1.amount}, color: Color.red, imageName: "chart.line.downtrend.xyaxis")
        }
        .padding(.horizontal)
        
        List(filteredTransactions) { transaction in
            HStack {
                Text(transaction.date, style: .time)
                    .fontWeight(.bold)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text("\(transaction.name)")
                    Text("Quantity: \(transaction.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Rp \(transaction.amount)")
                    .fontWeight(.bold)
                    .foregroundColor(transaction.type == .expense ? .red : .green)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    DailyTransaction(transactions: [Transaction(name: "test", date: Date(), amount: 10000, type: .expense, count: 1)], selectedDate: Date())
}
