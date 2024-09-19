//
//  GoalModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//


import Foundation
import SwiftData

@Model
class GoalModel: Identifiable {
    var id: UUID
    var priority: Int
    var title: String
    var date: Date
    var amount: Int
    var saved: Int
    var status: Bool
    
    
    init(id: UUID = UUID(), priority: Int = 1, title: String = "Sample Goal", date: Date = Date(), amount: Int = 1000, saved: Int = 500, status: Bool = true) {
        self.id = id
        self.priority = priority
        self.title = title
        self.date = date
        self.amount = amount
        self.saved = saved
        self.status = status
    }
}
