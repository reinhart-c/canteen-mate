//
//  Menu.swift
//  CanteenMate
//
//  Created by Reinhart on 27/03/25.
//

import SwiftUI
import SwiftData

enum ActiveSheet {
    case first, second
}


struct Menu: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var menus: [MenuModel]
    @State private var isModalPresented = false
    @State private var selectedItem: MenuModel? = nil
    @State private var activeSheet: ActiveSheet? = .first
    var body: some View {
        NavigationView {
            VStack {
                List(menus) { item in
                    Button(action: {
                        selectedItem = item
                        isModalPresented = true
                        activeSheet = .second
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
                            activeSheet = .first
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }

                    }
                }
            }
            .sheet(isPresented: $isModalPresented) {
                if self.activeSheet == .first {
                    AddMenuModal(isPresented: $isModalPresented).presentationDetents([.medium])
                }else{
                    if let selectedItem = selectedItem {
                        EditMenuModal(item: Binding($selectedItem)!, isPresented: $isModalPresented).presentationDetents([.medium])
                    }
                }
            }
        }
    }
}


#Preview {
    Menu().modelContainer(for: MenuModel.self, inMemory: true)
}
