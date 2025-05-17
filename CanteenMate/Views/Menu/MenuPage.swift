import SwiftUI
import SwiftData

enum ActiveMenuSheet {
    case add, edit
}


struct MenuPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var menus: [MenuModel]
    @State private var isModalPresented = false
    @State private var selectedItem: MenuModel? = nil
    @State private var activeMenuSheet: ActiveMenuSheet? = .add
    var body: some View {
        NavigationView {
            VStack {
                List(menus) { item in
                    Button(action: {
                        selectedItem = item
                        isModalPresented = true
                        activeMenuSheet = .edit
                    }) {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("Rp\(item.price)")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            isModalPresented = true
                            activeMenuSheet = .add
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }

                    }
                }
            }
            .sheet(isPresented: $isModalPresented) {
                if self.activeMenuSheet == .add {
                    AddMenuModal().presentationDetents([.medium])
                }else{
                    if selectedItem != nil {
                        EditMenuModal(item: Binding($selectedItem)!).presentationDetents([.medium])
                    }
                }
            }
            .overlay {
                if menus.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Menu", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding menus to see your list.")
                    })
                    .offset(y: -17)
                }
            }.background(
                Color(UIColor { trait in
                    trait.userInterfaceStyle == .dark ? .black : .systemGray6
                })
            )
        }
    }
}


#Preview {
    MenuPage().modelContainer(for: MenuModel.self, inMemory: true)
}
