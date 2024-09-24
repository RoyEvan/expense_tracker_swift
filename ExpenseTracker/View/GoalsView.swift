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
    @Query(sort: \GoalModel.priority, order: .forward) var goals: [GoalModel]
    var filteredGoals: [GoalModel] {
        goals.filter { $0.status == true }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if(filteredGoals.count <= 0) {
                    VStack {
                        Spacer()
                        Text("You have no goals").foregroundColor(.secondary)
                        Spacer()
                    }
                }
                else {
                    List {
                        ForEach(filteredGoals) {
                            g in HStack {
                                NavigationLink(destination: IncomeView()
            //                        .modelContainer(for: Saving.self)
                                ) {
                                    AppCardGoals(goal: g)
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .onDelete(perform: deleteGoal)
                        .onMove(perform: movePriority)
                    }
//                    .scrollContentBackground(.hidden)
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
                AddGoalView(isPresented: $showingAddGoal)
//                    .modelContainer(for: [GoalModel.self])
            }
        }
            
    }
    
    func deleteGoal(at offsets: IndexSet) {
        for i in offsets {
            let goalToDelete = filteredGoals[i]
            goalToDelete.status = false
        }
        
        
        do {
            try modelContext.save()  // Save the changes
        }
        catch {
            
        }
    }
    
    func movePriority(from source: IndexSet, to destination: Int) {
        var arr = filteredGoals
        arr.move(fromOffsets: source, toOffset: destination)
        
        var loop = 1
        for i in arr {
            i.priority = loop
            
            loop += 1
        }
    }
    
    
    
}

#Preview {
    GoalsView()
        .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self, Saving.self])
}
