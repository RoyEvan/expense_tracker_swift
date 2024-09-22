//
//  AddGoalView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 19/09/24.
//

import SwiftData
import SwiftUI

struct AddGoalView: View {
    @Binding var isPresented: Bool
    @State var showAlert: Bool = false
    
    @State var title: String = ""
    @State var amount: String = ""
    @State var priority: String = ""
    
    @Environment(\.modelContext) var modelContext
    @Query var goals: [GoalModel]
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Title\t")
                        .foregroundColor(.black)
                    TextField("Title", text: $title)
                        
                }
                
                HStack {
                    Text("Rp\t\t")
                        .foregroundColor(.black)
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onChange(of: amount, initial: false) { oldValue, newValue in
                            // Filter the string to allow only numbers
                            amount = newValue.filter { $0.isNumber }
                            amount = String(amount
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .prefix(12)
                            )
                        }
                }

                HStack {
                    Text("Priority\t")
                        .foregroundColor(.black)
                    TextField("Priority", text: $priority)
                        .keyboardType(.numberPad)
                        .onChange(of: priority, initial: false) { oldValue, newValue in
                            // Filter the string to allow only numbers
                            priority = newValue.filter { $0.isNumber }
                            priority = String(priority.prefix(2))
                            
                            if(priority.count <= 0) {
                                priority = ""
                            }
                            else if(Int(priority)! > 3) {
                                priority = "3"
                            }
                            else {
                                priority = priority.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        }
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                }.foregroundColor(.red),
                trailing: Button(action: {
                    
                    if(title.count>0 && amount.count>0 && priority.count>0 && UInt64(amount)!>0 && Int(priority)!>0) {
                        
                        let newGoal = GoalModel(priority: Int(priority)!, title: title, amount: UInt64(amount)!, status: true)
                        
                        modelContext.insert(newGoal)
                        
                        self.isPresented = false
                    }
                    else {
                        showAlert = true
                    }
                }) {
                    Text("Add")

                }
                .foregroundColor(.blue)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Empty Fields"),
                        message: Text("All fields must be filled.")
                    )
                }
            )
        }
    }
}

#Preview {
    AddGoalView(isPresented: .constant(true))
        .modelContainer(for: GoalModel.self)
}
