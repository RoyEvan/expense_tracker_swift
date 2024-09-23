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
                            g in VStack {
                                HStack {
                                    AppCardGoals(goal: g)
    //                                    .modelContainer(for: BalanceModel.self)
                                        .padding()
    //                                AppCardGoals()
    //                                    .modelContainer(for: BalanceModel.self)
    //                                    .padding()
                                    
                                    
                                    VStack {
                                        Button(action: {
                                            // Ubah Prioritas
                                            
                                            
                                        }) {
                                            Image(systemName: "arrow.up").bold()
                                        }
                                        .padding(2)
                                    }
                                }
                                
                            
                            }
                        }
                        
//                        .onDelete(perform: {})
//                        .onMove(perform: { indices, newOffset in
//                            move(from: indices, to: newOffset, arr: updatableGoals)
//                        })
                    }
                    .scrollContentBackground(.hidden)
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
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
//    func move(goal: GoalModel, offset: Int) {
//        let currentPriority = goal.priority
//        let destinationPriority = currentPriority + offset
//        var destinationGoal = filteredGoals.filter { $0.priority == destinationPriority }.first
//        
//        destinationGoal!.priority = currentPriority
//        
//        goal.priority = destinationPriority
//        
//        modelContext.save()
//    }
}

#Preview {
    GoalsView()
        .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self, Saving.self])
}
