//
//  GoalModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//


import Foundation
import SwiftData

@Model
class GoalModel {
    var priority: Int
    var title: String
    var amount: Int64
    var status: Bool
    var date: Date
    
    
    init(priority: Int = 1, title: String = "Sample Goal", amount: Int64 = 1000, status: Bool = true){
        if(title.count <= 0) {
            self.title = "Sample Goal"
        }
        else {
            self.title = title
        }
        
        self.priority = priority
        self.title = title
        self.amount = amount
        self.status = status
        self.date = Date()
    }
}
