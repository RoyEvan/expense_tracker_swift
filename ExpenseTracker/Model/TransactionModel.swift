//
//  TransactionModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import Foundation
import SwiftData

enum TransactionStatus {
    case income
    case expense
}

@Model
class TransactionModel {
//    var id: UUID
    var title: String
    var date: String
    var amount: Int
    var status: Bool
    
    init(title: String = "Sample Transaction", date: String = "1970/01/01", amount: Int = 1000, status: Bool = false) {
//        self.id = UUID()
        self.title = title
        self.date = date
        self.amount = amount
        self.status = status
    }
}
