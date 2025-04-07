import SwiftUI

struct TestView: View {
    
    var label: String = "Total"
    var value: String = "Rp50.000,00"
    
    var body: some View {
        HStack {
            Text("Total: ")
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(.darkGray))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}



#Preview {
    TestView(label: "Total", value: "Rp50.000")
}
