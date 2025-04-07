import SwiftUI

struct IncomeExpenseButtonView: View {
    @Binding var isIncomeMode: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                withAnimation {
                    isIncomeMode = false
                }
            }) {
                Text("Income")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(!isIncomeMode ? .white : .blue)
                    .frame(width: 150, height: 45)
                    .background(!isIncomeMode ? Color.blue : Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
            }
            
            Button(action: {
                withAnimation {
                    isIncomeMode = true
                }
            }) {
                Text("Expense")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isIncomeMode ? .white : .blue)
                    .frame(width: 150, height: 45)
                    .background(isIncomeMode ? Color.blue : Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                
            }
        }
        .padding(.horizontal, 20)
        .cornerRadius(0)
        .padding(.bottom, 10)
    }
}

#Preview {
    IncomeExpenseButtonView(isIncomeMode: .constant(false))
}
