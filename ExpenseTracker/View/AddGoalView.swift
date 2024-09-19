//
//  AddGoalView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 19/09/24.
//

import SwiftUI

struct AddGoalView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Title")
                TextField()
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddGoalView()
}
