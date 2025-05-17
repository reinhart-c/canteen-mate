import SwiftUI

struct SummaryCard: View {
    let title: String
    let amount: Int
    let color: Color
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) { 
            HStack(spacing: 4) {
                Image(systemName: imageName)
                Text(title)
                    .font(.headline)
                    .bold()
            }
            Text("Rp\(formattedAmount)")
                .font(.title)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 75, maxHeight: 75, alignment: .leading)
        .padding()
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(12)
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "\(abs(amount))"
    }
}

#Preview {
    SummaryCard(
        title: "Testing",
        amount: 100000,
        color: Color.red,
        imageName: "chart.line.uptrend.xyaxis"
    )
}
