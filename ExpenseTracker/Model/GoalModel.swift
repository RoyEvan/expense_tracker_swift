//
//  GoalModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//

import Foundation
import SwiftData

@Model
struct GoalModel: Identifiable {
    @Attribute(.unique) let id: UUID = UUID()
    let priority: Int = 1
    let title: String = "Sample Goal"
    let date: Date = Date()
    let amount: Int = 1000
    let saved: Int = 500
    let status: Bool = true
}
