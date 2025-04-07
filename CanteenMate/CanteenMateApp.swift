import SwiftUI
import SwiftData

@main
struct CanteenMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [MenuModel.self, Transaction.self])
    }
}
