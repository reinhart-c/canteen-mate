//
//  ContentView.swift
//  CanteenMate
//
//  Created by Ahmed Nizhan Haikal on 26/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isCustomMode: Bool = false
    @State private var isIncomeMode: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if !isIncomeMode {
                    ZStack {
                        if isCustomMode {
                            IncomeModeCustomView(isCustomMode: $isCustomMode, isIncomeMode: $isIncomeMode)
                                .transition(.identity)
                        } else {
                            IncomeModeMenuView(isCustomMode: $isCustomMode, isIncomeMode: $isIncomeMode)
                                .transition(.identity)
                        }
                    }
                    .animation(.linear, value: isCustomMode)
                } else {
                    ExpenseView(isIncomeMode: $isIncomeMode)
                        .transition(.identity)
                }
            }
//            .animation(.linear, value: isIncomeMode)
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
