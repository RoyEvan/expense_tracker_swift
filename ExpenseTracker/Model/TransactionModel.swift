//
//  TransactionModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import Foundation
import SwiftData

enum TransactionStatus {
    case income  // true
    case expense // false
}

@Model
class TransactionModel {
    var category: String
//    var id: UUID
    var date: Date
    var amount: Int
    var status: Bool
    var monthly: Bool
    
    init(category: String = "Salary", date: Date = Date(), amount: Int = 1000, status: Bool = false, monthly: Bool = false) {
//        self.id = UUID()
        
        if category.count == 0 {
            self.category = "Salary"
        }
        else {
            self.category = category
        }
        
        self.date = date
        self.amount = amount
        self.status = status
        self.monthly = monthly
    }
}
