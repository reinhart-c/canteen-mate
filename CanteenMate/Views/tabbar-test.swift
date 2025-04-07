import SwiftUI

struct Testing: View {
    var body: some View {
        TabView {
            RecapView()
                .tabItem {
                    Label("Recap", systemImage: "chart.bar.doc.horizontal")
                }

            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "menucard")
                }
        }
    }
}

struct RecapView: View {
    var body: some View {
        Text("This is the Recap Page")
    }
}

struct MenuView: View {
    var body: some View {
        Text("This is the Menu Page")
    }
}

#Preview {
    Testing()
}
