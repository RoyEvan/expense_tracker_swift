//
//  TransactionModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import Foundation

enum TransactionStatus {
    case income
    case expense
}


struct TransactionModel: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let amount: String
    let status: TransactionStatus
}
