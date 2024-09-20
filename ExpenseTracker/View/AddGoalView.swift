//
//  AddGoalView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 19/09/24.
//

import SwiftUI

struct AddGoalView: View {
    @Binding var isPresented: Bool
    
    @State var title: String = ""
    @State var amount: String = ""
    @State var priority: String = ""
    
    
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
                }

                HStack {
                    Text("Priority\t")
                        .foregroundColor(.black)
                    TextField("Priority", text: $priority)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                }.foregroundColor(.red),
                trailing: Button("Add") {
                    self.isPresented = false
                }.foregroundColor(.blue)
            )
        }
    }
}

#Preview {
    AddGoalView(isPresented: .constant(true))
}
