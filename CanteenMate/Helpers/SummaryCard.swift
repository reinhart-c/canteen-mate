//
//  SummaryCard.swift
//  CanteenMate
//
//  Created by Ahmed Nizhan Haikal on 27/03/25.
//

import SwiftUI

struct SummaryCard: View {
    let title: String
    let amount: Int
    let color: Color
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: imageName)
                Text(title)
                    .font(.headline)
                    .bold()
            }
            Text(amount, format: .currency(code: "IDR"))
                .font(.title)
                .bold()
                .lineLimit(1) // Prevents multiline
                .minimumScaleFactor(0.5) // Allows shrinking if needed
                .allowsTightening(true) // Helps squeeze text slightly before breaking
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

#Preview {
    SummaryCard(title: "Testing", amount: 10, color: Color.red, imageName: "chart.line.uptrend.xyaxis")
}
