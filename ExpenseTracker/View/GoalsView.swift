//
//  GoalsView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 17/09/24.
//

import SwiftUI

struct GoalsView: View {
    var goals: [GoalModel] = [GoalModel()]
    var body: some View {
        NavigationStack {
            VStack{
                VStack {
                    AppCardGoals().padding()
                }
                
                Spacer()
                
                AppButton(title: "Add Your Goals").padding()
            }
            
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalsView()
}
