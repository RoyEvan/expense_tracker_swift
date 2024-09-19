//
//  AppCardTransaction.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//
import SwiftData
import SwiftUI

struct CardTransaction: View {
    var transaction: TransactionModel = TransactionModel()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date)
                    .font(.subheadline)
            }
            Spacer()
            Text(String(transaction.amount))
                .foregroundColor(transaction.status == false ? .red : .green) // Warna tergantung status
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(Color("cardColor"))
        .cornerRadius(12)
    }
}

#Preview {
    CardTransaction(transaction: TransactionModel())
}
