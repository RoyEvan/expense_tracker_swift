//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftData
import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool
    @State var showAlert: Bool = false
    @State var insufficientBalance: Bool = false
    @State var showConfirmationAlert: Bool = false
    @State var showZeroAlert: Bool = false
    
    @State private var transactionType = "Income"
    @State private var amount: String = ""
    @State private var category: String = "Salary"
    @State private var transactionDate = Date()
    @State private var isMonthly = false

    @Environment(\.modelContext) var modelContext
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balance: [BalanceModel]
    @Query(sort: \GoalModel.priority, order: .forward) var goals: [GoalModel]

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter
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
            .navigationBarTitle("New Transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                }.foregroundColor(.red),
                trailing: Button("Add") {
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
                    message: Text("Are you sure you want to add this transaction?"),
                    primaryButton: .destructive(Text("Confirm")) {
                        addTransaction()
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

    private func addTransaction() {
        if amount.count > 0 {
            guard let unformattedAmount = getIntAmount(from: amount) else { return }
            
            if transactionType.lowercased() == "income" {
                let newTransaction = TransactionModel(category: category, date: transactionDate, amount: unformattedAmount, status: true, monthly: isMonthly)
                
                modelContext.insert(newTransaction)
                
                guard let currentBalance = balance.first else { return }

                var incomeLeft = unformattedAmount + currentBalance.needs
                let additionalSaving = Int64(Double(unformattedAmount) * 0.2)
                let savingSaved = currentBalance.savings + additionalSaving
                incomeLeft -= additionalSaving

                let additionalGoalSaving = Int64(Double(unformattedAmount) * 0.3)
                let goalSaved = currentBalance.goals + additionalGoalSaving
                incomeLeft -= additionalGoalSaving
                
                let newBalance = BalanceModel(needs: incomeLeft, savings: savingSaved, goals: goalSaved, date_logged: transactionDate)
                modelContext.insert(newBalance)

                let month = DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
                let newSaving = Saving(title: "20% from \(month) Income", date: transactionDate, amount: additionalSaving)
                modelContext.insert(newSaving)

                self.isPresented = false
            } else if transactionType.lowercased() == "expenses" {
                let spending = unformattedAmount
                
                guard let currentBalance = balance.first, currentBalance.needs >= spending else {
                    insufficientBalance = true
                    return
                }
                
                let newTransaction = TransactionModel(category: category, date: transactionDate, amount: -spending, status: false, monthly: isMonthly)
                modelContext.insert(newTransaction)
                
                let needsBalance = currentBalance.needs - spending
                let newBalance = BalanceModel(needs: needsBalance, savings: currentBalance.savings, goals: currentBalance.goals, date_logged: transactionDate)
                modelContext.insert(newBalance)
                
                self.isPresented = false
            }
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

#Preview {
    AddTransactionView(isPresented: .constant(true))
}
