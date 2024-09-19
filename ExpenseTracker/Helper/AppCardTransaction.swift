//
//  AppCardTransaction.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct CardTransaction: View {
    var transaction: TransactionModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date)
                    .font(.subheadline)
            }
            Spacer()
            Text(transaction.amount)
                .foregroundColor(transaction.status == .expense ? .red : .green) // Warna tergantung status
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(Color("cardColor"))
        .cornerRadius(12)
    }
}

#Preview {
    CardTransaction(transaction: TransactionModel(title: "gatau beli apa", date: "05/09/2024", amount: "+IDR 2.000.000", status: .expense))
}
