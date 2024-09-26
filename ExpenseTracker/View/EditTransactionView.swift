//
//  EditTransactionView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 26/09/24.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Binding var isPresented: Bool
    @Binding var transaction: TransactionModel // Binding to the transaction being edited
    
    @State private var showAlert = false
    @State private var showZeroAlert = false
    @State private var insufficientBalance = false
    @State private var showConfirmationAlert = false
    
    @State private var transactionType: String
    @State private var amount: String
    @State private var category: String
    @State private var transactionDate: Date
    @State private var isMonthly: Bool

    @Environment(\.modelContext) var modelContext
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balance: [BalanceModel]

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter
    }

    init(isPresented: Binding<Bool>, transaction: Binding<TransactionModel>) {
        _isPresented = isPresented
        _transaction = transaction
        _transactionType = State(initialValue: transaction.wrappedValue.status ? "Income" : "Expenses")
        _amount = State(initialValue: String(transaction.wrappedValue.amount))
        _category = State(initialValue: transaction.wrappedValue.category)
        _transactionDate = State(initialValue: transaction.wrappedValue.date)
        _isMonthly = State(initialValue: transaction.wrappedValue.monthly)
    }

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $transactionType) {
                    Text("Income").tag("Income")
                    Text("Expenses").tag("Expenses")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: transactionType) { _ in
                    category = ""
                }

                HStack {
                    Text("Rp").foregroundColor(.black)
                    TextField("Amount", text: $amount)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: amount) { newValue in
                            formatAmountInput()
                        }
                        .keyboardType(.numberPad)
                }

                Picker("Category", selection: $category) {
                    ForEach(categoryOptions(), id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                DatePicker("Date", selection: $transactionDate, displayedComponents: .date)

                Toggle(isOn: $isMonthly) {
                    Text("Monthly")
                }
            }
            .navigationBarTitle("Edit Transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                }.foregroundColor(.red),
                trailing: Button("Save") {
                    if amount.isEmpty {
                        showAlert = true
                    } else if let amountValue = getIntAmount(from: amount), amountValue == 0 {
                        showZeroAlert = true
                    } else {
                        showConfirmationAlert = true
                    }
                }
                .foregroundColor(.blue)
            )
            .alert(isPresented: Binding(
                get: {
                    showAlert || insufficientBalance || showZeroAlert
                },
                set: { _ in }
            )) {
                if showZeroAlert {
                    return Alert(
                        title: Text("Invalid Input"),
                        message: Text("The amount cannot be zero."),
                        dismissButton: .default(Text("OK")) {
                            showZeroAlert = false
                        }
                    )
                } else if insufficientBalance {
                    return Alert(
                        title: Text("Insufficient Balance"),
                        message: Text("Hey, let's save up some money to reach your goals."),
                        dismissButton: .default(Text("OK")) {
                            insufficientBalance = false
                        }
                    )
                } else {
                    return Alert(
                        title: Text("Empty Fields"),
                        message: Text("All fields must be filled."),
                        dismissButton: .default(Text("OK")) {
                            showAlert = false
                        }
                    )
                }
            }
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Confirm Transaction"),
                    message: Text("Are you sure you want to save these changes?"),
                    primaryButton: .destructive(Text("Confirm")) {
                        saveTransaction()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func categoryOptions() -> [String] {
        switch transactionType {
        case "Income":
            return ["Salary", "Pocket Money"]
        case "Expenses":
            return ["Living", "Food & Beverage", "Education", "Fashion"]
        default:
            return []
        }
    }

    private func saveTransaction() {
        if let unformattedAmount = getIntAmount(from: amount) {
            if transactionType.lowercased() == "income" {
                transaction.status = true
                transaction.category = category
                transaction.date = transactionDate
                transaction.amount = unformattedAmount
                transaction.monthly = isMonthly
                
                updateBalance(with: unformattedAmount, isIncome: true)
                self.isPresented = false
            } else if transactionType.lowercased() == "expenses" {
                guard let currentBalance = balance.first, currentBalance.needs >= unformattedAmount else {
                    insufficientBalance = true
                    return
                }
                transaction.status = false
                transaction.category = category
                transaction.date = transactionDate
                transaction.amount = -unformattedAmount
                transaction.monthly = isMonthly
                
                updateBalance(with: unformattedAmount, isIncome: false)
                self.isPresented = false
            }
        }
    }

    private func updateBalance(with amount: Int64, isIncome: Bool) {
        guard let currentBalance = balance.first else { return }
        if isIncome {
            let newNeeds = currentBalance.needs + amount
            let newSavings = currentBalance.savings + Int64(Double(amount) * 0.2)
            let newGoals = currentBalance.goals + Int64(Double(amount) * 0.3)
            
            let updatedBalance = BalanceModel(needs: newNeeds - newSavings - newGoals, savings: newSavings, goals: newGoals, date_logged: transactionDate)
            modelContext.insert(updatedBalance)
        } else {
            let newNeeds = currentBalance.needs - amount
            let updatedBalance = BalanceModel(needs: newNeeds, savings: currentBalance.savings, goals: currentBalance.goals, date_logged: transactionDate)
            modelContext.insert(updatedBalance)
        }
    }

    private func formatAmountInput() {
        let cleanAmount = amount.filter { $0.isNumber }
        if let number = Int(cleanAmount), let formattedAmount = numberFormatter.string(from: NSNumber(value: number)) {
            amount = formattedAmount
        }
    }

    private func getIntAmount(from formattedAmount: String) -> Int64? {
        let cleanAmount = formattedAmount.replacingOccurrences(of: ".", with: "")
        return Int64(cleanAmount)
    }
}
//
//#Preview {
//    EditTransactionView(isPresented: .constant(true), transaction: .)
//}
