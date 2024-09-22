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
    @State private var showingAddGoal = false
    @Query var goals: [GoalModel]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if(goals.count <= 0) {
                    VStack {
                        Spacer()
                        Text("You have no goals").foregroundColor(.secondary)
                        Spacer()
                    }
                }
                else {
                    ForEach(goals) { g in VStack {
                        AppCardGoals(goal: g)
                            .modelContainer(for: BalanceModel.self)
                            .padding()
                    }}
                }
               
                
                Spacer()
                
                AppButton(title: "Add Your Goal") {
                    showingAddGoal.toggle()
                }
                    
//                    Button(action: {
//                        showingAddGoal.toggle()
//                    }) {
//                        HStack {
//                            Image(systemName: "plus").foregroundColor(.white).bold()
//                            Text("Add Your Goal")
//                                .foregroundColor(.white)
//                                .bold()
//                                .padding()
//                        }
//                        
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(Color("appColor"))
//                    .cornerRadius(10)
//                    .padding()
            }
            .padding()
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(isPresented: $showingAddGoal).modelContainer(for: GoalModel.self)
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalsView().modelContainer(for: GoalModel.self)
}
