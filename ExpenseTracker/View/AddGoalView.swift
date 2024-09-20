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
                VStack {
                    HStack {
                        Text("Title")
                            .foregroundColor(.black)
                        TextField("Title", text: $title)
                            
                    }
                    
                    HStack {
                        Text("Rp")
                            .foregroundColor(.black)
                        TextField("Amount", text: $amount)
                            .keyboardType(.numberPad)
                    }

                    HStack {
                        Text("Priority")
                            .foregroundColor(.black)
                        TextField("Priority", text: $priority)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
        }
    }
}

#Preview {
    AddGoalView(isPresented: .constant(true))
}
