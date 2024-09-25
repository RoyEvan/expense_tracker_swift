//
//  EditGoalView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 24/09/24.
//

import SwiftUI

struct EditGoalView: View {
//    @Binding var isPresented: Bool
    
    @State var showAlert: Bool = false
    
    @State var title: String = ""
    @State var amount: String = ""
    
    var goal: GoalModel
    
        
    init(goal: GoalModel = GoalModel()) {
//        self.isPresented = isPresented
        self.goal = goal
        
        _title = State(initialValue: goal.title)
        _amount = State(initialValue: String(goal.amount))
        
    }
        
    var body: some View {
        Form {
            HStack {
                Text("Title\t").foregroundColor(.black)
                
                TextField("Title", text: $title)
                    .onChange(of: title, initial: false) { oldValue, newValue in
                        title = String(title
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .prefix(12)
                        )
                        
                        if(amount.count <= 0) {
                            amount = ""
                        }
                    }
            }
            
            HStack {
                Text("Rp\t\t").foregroundColor(.black)
                
                TextField("Amount", text: $amount)
                .keyboardType(.numberPad)
                .onChange(of: amount, initial: false) { oldValue, newValue in
                    // Filter the string to allow only numbers
                    amount = newValue.filter { $0.isNumber }
                    
                    if(amount.isEmpty) {
                        amount = ""
                    }
                    else if(Int64(amount)! <= 0) {
                        amount = "1"
                    }
                    
                    amount = String(amount
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .prefix(12)
                    )
                }
            }
        }
        .navigationBarTitle("Edit Goal", displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Submit") {
                if(title.count>0 && amount.count>0 && Int64(amount)!>0) {
                    goal.title = title
                    goal.amount = Int64(amount)!
                    
                    
                }
                else {
                    showAlert = true
                }
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

#Preview {
    EditGoalView()
}
