//
//  GoalsView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 17/09/24.
//

import SwiftData
import SwiftUI

struct GoalsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var goals: [GoalModel]
    
    
    var body: some View {
        NavigationStack {
            VStack{
                ForEach(goals) { g in VStack {
                    AppCardGoals(goal: g).padding()
                }}
                
                Spacer()
                
                NavigationLink(destination: Example()) {
                    AppButton(title: "Add Your Goals").padding()
                }
            }
            
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalsView().modelContainer(for: GoalModel.self)
}
