import SwiftUI

//struct CustomToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        HStack {
//            Rectangle()
//                .frame(width: 50, height: 30)
//                .cornerRadius(15)
//                .foregroundColor(configuration.isOn ? .green : .blue) // Green when ON, Blue when OFF
//                .overlay(
//                    Circle()
//                        .frame(width: 26, height: 26)
//                        .foregroundColor(.white)
//                        .offset(x: configuration.isOn ? 10 : -10)
//                        .animation(.easeInOut(duration: 0.3), value: configuration.isOn)
//                )
//                .onTapGesture {
//                    withAnimation {
//                        configuration.isOn.toggle()
//                    }
//                }
//            
//            Text(configuration.isOn ? "Mode Custom" : "Mode Menu")
//                .font(.system(size: 18, weight: .medium))
//                .foregroundColor(.black)
//                .animation(.easeInOut(duration: 0.3), value: configuration.isOn)
//            
//            Spacer()
//        }
//        .padding(.horizontal, 40)
//        .padding(.vertical, 15)
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(radius: 2)
//    }
//}

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
                    .frame(height: 30)
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
                    .frame(height: 30)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isCustomMode ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isCustomMode ? Color.blue : Color.white)
                
            }
        }
        .cornerRadius(0)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
        //        .padding(.horizontal)
//        .padding(.vertical, 20)
    }
}


#Preview {
    ToggleView(isCustomMode: .constant(false))
}
