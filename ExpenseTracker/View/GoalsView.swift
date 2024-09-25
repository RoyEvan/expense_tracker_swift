//
//  GoalsView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 17/09/24.
//

import SwiftData
import SwiftUI
import ConfettiSwiftUI

struct GoalsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingAddGoal: Bool = false
    @State var insufficientBalance: Bool = false
    
    @State var counter: Int = 0
    
    @Query(sort: \GoalModel.priority, order: .forward) var goals: [GoalModel]
    var filteredGoals: [GoalModel] {
        goals
            .filter { $0.status == true }
            .sorted { $0.priority < $1.priority }
    }
    
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balances: [BalanceModel]
    
    
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
                                NavigationLink(destination: EditGoalView(goal: g)
                                ) {
                                    AppCardGoals(goal: g)
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    finishGoal(goal: g)
                                }) {
                                    Label("Finish", systemImage: "checkmark.circle.fill")
                                }
                                .tint(Color("appColor"))
                                
                            }
                        }
                        .onDelete(perform: deleteGoal)
                        .onMove(perform: movePriority)
                        
                    }
                    .shadow(radius: 10)
                    .scrollContentBackground(.hidden)
                    .background()
                    
                    
                    Text("Drag to change priority").foregroundColor(.secondary)
                    Text("Swipe Left to delete").foregroundColor(.secondary)
                    Text("Swipe Right to finish").foregroundColor(.secondary)
                }
                
                
                
                AppButton(title: "Add Your Goal") {
                    showingAddGoal.toggle()
                }
            }
            .padding()
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(isPresented: $showingAddGoal)
            }
            .navigationTitle("Goals")
            .alert(isPresented: $insufficientBalance) {
                Alert(
                    title: Text("Insufficient Balance"),
                    message: Text("You haven't saved enough money to get that.")
                )
            }
            .confettiCannon(counter: $counter, repetitions: 3)
        }
    }
    
    func finishGoal(goal: GoalModel) {
        if(balances.first!.goals >= goal.amount) {
            goal.status = false
//            balances.first!.goals - goal.amount
            let newBalance = BalanceModel(needs: balances.first!.needs, savings: balances.first!.savings, goals: balances.first!.goals - goal.amount, date_logged: Date())
            
            modelContext.insert(newBalance)
            
            
            var loop = 1
            for i in filteredGoals {
                if(i.status) {
                    i.priority = loop
                    
                    loop += 1
                }
            }
            
            counter += 1
        }
        else {
            insufficientBalance = true
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        for i in offsets {
            let goalToDelete = filteredGoals[i]
            goalToDelete.status = false
        }
        
        
//        do {
//            try modelContext.save()  // Save the changes
//        }
//        catch {
//            
//        }
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
