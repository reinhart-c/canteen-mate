import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            RecapPage()
                .tabItem {
                    Label("Recap", systemImage: "chart.bar.doc.horizontal")
                }
            
            Menu()
                .modelContainer(for: MenuModel.self, inMemory: true)
                .tabItem {
                    Label("Menu", systemImage: "menucard")
                }
        }
    }
}


#Preview {
    ContentView()
}
