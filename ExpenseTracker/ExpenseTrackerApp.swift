//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self, Saving.self])
//            TestCustomListView()
        }
//        .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self])
    }
}
