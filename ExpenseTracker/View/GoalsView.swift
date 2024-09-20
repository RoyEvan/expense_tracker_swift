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
            VStack{
                ForEach(goals) { g in VStack {
                    AppCardGoals(goal: g).padding()
                }}
                
                Spacer()
                
                NavigationLink(destination: AddGoalView(isPresented: $showingAddGoal)) {
                    Button(action: {
                        showingAddGoal.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus").foregroundColor(.white).bold()
                            Text("Add Your Goal")
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("appColor"))
                    .cornerRadius(10)
                    .padding()
                    
                }
                
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(isPresented: $showingAddGoal)
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalsView().modelContainer(for: GoalModel.self)
}
