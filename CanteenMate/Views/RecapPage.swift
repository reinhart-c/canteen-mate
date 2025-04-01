//
//  TransactionList.swift
//  CanteenMate
//
//  Created by Ahmed Nizhan Haikal on 27/03/25.
//

import SwiftUI

struct TransactionList: View {
    let transactions: [Transaction] = [
        Transaction(name: "Testing", date: Date(), amount: 100000, type: 1),
        Transaction(name: "Testing2", date: Date(), amount: 12312321, type: 2)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 16) {
                    SummaryCard(title: "Income", amount: 50000, color: Color.green, imageName: "chart.line.uptrend.xyaxis")
                    SummaryCard(title: "Expenses", amount: 25000, color: Color.red, imageName: "chart.line.downtrend.xyaxis")
                }
                .padding(.horizontal)

                
                List(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .systemGray6))
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
