import SwiftUI
import SwiftData

struct DailyTransaction: View {
    @Binding var isEmpty: Bool
    let selectedDate: Date
    
    @State private var selectedTransaction: Transaction?
    @State private var isEditing = false
    
    @State private var showIncome: Bool = true
    @State private var showExpense: Bool = true
    @State private var showTransactions: [Transaction] = []
    
    
    private var startOfDay: Date {
        Calendar.current.startOfDay(for: selectedDate)
    }
    
    private var endOfDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
    
    @Query private var allTransactions: [Transaction]
    private var filteredTransactions: [Transaction] {
        allTransactions.filter { tx in
            tx.date >= startOfDay && tx.date <= endOfDay
        }
    }
    
    private var filteredIncomeTransactions: [Transaction] {
        filteredTransactions.filter { tx in
            tx.date >= startOfDay && tx.date <= endOfDay && tx.type == .income
        }
    }
    
    private var filteredExpenseTransactions: [Transaction] {
        filteredTransactions.filter { tx in
            tx.date >= startOfDay && tx.date <= endOfDay && tx.type == .expense
        }
    }
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 16){
                if !isEmpty {
                    HStack(spacing: 16) {
                        SummaryCard(title: "Income", amount: filteredTransactions.filter{$0.type == .income}.reduce(0){$0 + $1.amount}, color: showIncome ? Color.green : Color.green.opacity(0.5), imageName: "chart.line.uptrend.xyaxis")
                            .onTapGesture {
                                if !showIncome {
                                    showIncome.toggle()
                                }
                                showExpense.toggle()
                                updateTransactions()
                            }
                        SummaryCard(title: "Expenses", amount: filteredTransactions.filter{$0.type == .expense}.reduce(0){$0 + $1.amount}, color: showExpense ? Color.red : Color.red.opacity(0.5), imageName: "chart.line.downtrend.xyaxis")
                            .onTapGesture {
                                if !showExpense {
                                    showExpense.toggle()
                                }
                                showIncome.toggle()
                                updateTransactions()
                            }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .zIndex(1)
                    
                    List(showTransactions) { transaction in
                        HStack {
                            Text(transaction.date, style: .time)
                                .fontWeight(.bold)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text("\(transaction.name)")
//                                Text("Quantity: \(transaction.count)")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
                                if let desc = transaction.desc{
                                    if desc.isEmpty {
                                        Text("Quantity: \(transaction.count)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }else{
                                        if desc.count >= 25 {
                                            Text("\(desc.prefix(25))...")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            
                                        }else{
                                            Text(desc)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }else{
                                    Text("Quantity: \(transaction.count)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Text("Rp\(transaction.amount)")
                                .fontWeight(.bold)
                                .foregroundColor(transaction.type == .expense ? .red : .green)
                        }
                        .padding(.vertical, 8)
                        .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing]
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTransaction = transaction
                            isEditing = true
                        }
                    }
                    .padding(.top, -25)
                    .sheet(item: $selectedTransaction) { transaction in
                        EditTransactionView(transaction: transaction)
                    }
                }
            }
        }
        .background(
            Color(UIColor { trait in
                trait.userInterfaceStyle == .dark ? .black : .systemGray6
            })
        )
        .onAppear {
            isEmpty = filteredTransactions.isEmpty
            updateTransactions()
        }
        .onChange(of: filteredTransactions) {
            isEmpty = filteredTransactions.isEmpty
            updateTransactions()
        }
        .onChange(of: selectedDate) {
            print("selectedDate: \(selectedDate)")
            isEmpty = filteredTransactions.isEmpty
            updateTransactions()
        }
    }
    func updateTransactions() {
        showTransactions = filteredTransactions
        if showIncome && showExpense {
            showTransactions = filteredTransactions
        }else if !showIncome{
            showTransactions = filteredExpenseTransactions
        }else if !showExpense{
            showTransactions = filteredIncomeTransactions
        }else{
            showTransactions = filteredTransactions
        }
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Transaction.self, configurations: config)

    let context = modelContainer.mainContext
    let now = Date()

    let dummyData = [
        Transaction(name: "Lunch", date: now, amount: 25000, type: .expense, count: 1),
        Transaction(name: "Coffee", date: now, amount: 15000, type: .expense, count: 1),
        Transaction(name: "Freelance", date: now, amount: 100000, type: .income, count: 1),
    ]

    dummyData.forEach { context.insert($0) }

    return DailyTransaction(isEmpty: .constant(false), selectedDate: now)
        .modelContainer(modelContainer)
}
