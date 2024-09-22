//
//  BalanceModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 21/09/24.
//

import Foundation
import SwiftData

@Model
class BalanceModel {
    var needs: Int64
    var savings: Int64
    var goals: Int64
    var date_logged: Date
    
    init(needs: Int64 = 0, savings: Int64 = 0, goals: Int64 = 0, date_logged: Date = Date()) {
        self.needs = needs
        self.savings = savings
        self.goals = goals
        self.date_logged = date_logged
    }
}
