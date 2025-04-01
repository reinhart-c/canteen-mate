import SwiftUI

struct TransactionRow: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            Text(transaction.name)
                .font(.body)
            Spacer()
            Text(formattedAmount(transaction.amount, type: transaction.type))
                                        .font(.body)
                                        .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}

func formattedAmount(_ amount: Int, type: TransactionType) -> String {
    let formatted = amount.formatted(.currency(code: "IDR"))
    return type == .income ? "\(formatted)" : formatted
}
