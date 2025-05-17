//
//  SpotlightIntent.swift
//  CanteenMate
//
//  Created by Reinhart on 16/05/25.
//

import Foundation
import AppIntents
import SwiftData

struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: AddIncomeIntent(),
                    phrases: ["Add income in \(.applicationName)"]
                    ,shortTitle: "Add Income", systemImageName: "chart.line.uptrend.xyaxis")
        
        AppShortcut(intent: AddExpenseIntent(),
                    phrases: ["Add expense in \(.applicationName)"]
                    ,shortTitle: "Add Expense", systemImageName: "chart.line.downtrend.xyaxis")
        
        AppShortcut(intent: AddMenuIntent(),
                    phrases: ["Add menu in \(.applicationName)"]
                    ,shortTitle: "Add Menu", systemImageName: "menucard")
        
    }

}

struct AddIncomeIntent: AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add Income")
    
    @Parameter(title: "Title") var title: String
    @Parameter(title: "Amount") var amount: Int
    @Parameter(title: "Description") var description: String
    
    func perform() async throws -> some IntentResult{
        guard let container = try? ModelContainer(for: Transaction.self, MenuModel.self) else {
                    throw NSError(domain: "SwiftDataError", code: 1)
                }
        let context = ModelContext(container)
        let date: Date = Date()
        let newTransaction = Transaction(
            name: title,
            date: date,
            amount: amount,
            type: .income,
            count: 1,
            desc: description
        )
        context.insert(newTransaction)
        try? context.save()
        return .result()
    }
}

struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add Expense")
    
    @Parameter(title: "Title") var title: String
    @Parameter(title: "Amount") var amount: Int
    @Parameter(title: "Description") var description: String
    
    func perform() async throws -> some IntentResult{
        guard let container = try? ModelContainer(for: Transaction.self, MenuModel.self) else {
                    throw NSError(domain: "SwiftDataError", code: 1)
                }
        let context = ModelContext(container)
        let date: Date = Date()
        let newTransaction = Transaction(
            name: title,
            date: date,
            amount: amount,
            type: .expense,
            count: 1,
            desc: description
        )
        context.insert(newTransaction)
        try? context.save()
        return .result()
    }
}

struct AddMenuIntent: AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add Menu")
    
    @Parameter(title: "Name") var name: String
    @Parameter(title: "Price") var price: Int
    
    func perform() async throws -> some IntentResult{
        guard let container = try? ModelContainer(for: Transaction.self, MenuModel.self) else {
                    throw NSError(domain: "SwiftDataError", code: 1)
                }
        let context = ModelContext(container)
        let newMenu = MenuModel(
            name: name,
            price: price
        )
        context.insert(newMenu)
        try? context.save()
        return .result()
    }
}
