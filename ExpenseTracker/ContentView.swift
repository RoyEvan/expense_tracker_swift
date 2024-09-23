//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        SplashScreenView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self, Saving.self])
}
