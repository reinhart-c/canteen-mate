import SwiftUI

struct ToggleView: View {
    @Binding var isCustomMode: Bool

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    isCustomMode = false
                }
            }) {
                Label("Menu", systemImage: "fork.knife")
                    .frame(height: 50)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(!isCustomMode ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(!isCustomMode ? Color.blue : Color.white)
            }

            Button(action: {
                withAnimation {
                    isCustomMode = true
                }
            }) {
                Label("Custom", systemImage: "pencil.and.outline")
                    .frame(height: 50)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isCustomMode ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isCustomMode ? Color.blue : Color.white)
                
            }
        }
        .cornerRadius(0)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
}


#Preview {
    ToggleView(isCustomMode: .constant(false))
}
