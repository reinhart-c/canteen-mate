import SwiftUI

struct CancelDoneButtonView: View {
    
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
        }
//        .foregroundStyle(.primary)
    }
}

#Preview {
    CancelDoneButtonView(
        text: "Cancel",
        action: {
            print("Cancel button tapped!")
        }
    )
}
