//
//  AddTransaction.swift
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
    
    @State private var transactionType = "Income"
    @State private var amount: String = ""
    @State private var category: String = "Salary"
    @State private var transactionDate = Date()
    @State private var isMonthly = false
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balance: [BalanceModel]

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
    
    private func updateBalance(type: Int8 = 1, isNew: Bool = false, currentBalance: BalanceModel) -> Void {
        // type = -1 -> expense same month
        // type = 1 -> income same month
        
        // isNew = true -> new month
        // isNew = false -> same month
        
        if isNew {
            var incomeLeft = Int64(amount)!;
            
            let savingSaved: Int64 = currentBalance.savings + Int64(Double(amount)! * 0.2)
            incomeLeft = incomeLeft - savingSaved
            
            let goalSaved: Int64 = currentBalance.goals + Int64(Double(amount)! * 0.3)
            incomeLeft = incomeLeft - goalSaved
            
            
            let newBalance = BalanceModel(needs: incomeLeft, savings: savingSaved, goals: goalSaved, date_logged: transactionDate)
            
            modelContext.insert(newBalance)
        }
        else {
            
        }
        
        
        
        
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
                        .onChange(of: amount, initial: false) { oldValue, newValue in
                            // Filter the string to allow only numbers
                            amount = newValue.filter { $0.isNumber }
                            amount = String(amount.prefix(12))
                            amount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
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
                    
                    if(amount.count > 0) {
                        if(String(transactionType).lowercased() == "income") {
                            let newTransaction = TransactionModel(category: category, date: transactionDate, amount: Int64(amount)!, status: true, monthly: isMonthly)
                            
                            // Insert to DB (SwiftData)
                            modelContext.insert(newTransaction)
                            
                            // Cek apakah bulannya sama,
                            let currentBalance = balance.first!
                            
                            let calendar = Calendar.current
                            let lastBalanceMonth = calendar.component(.month, from: currentBalance.date_logged)
                            let currentMonth = calendar.component(.month, from: Date())
                            
                            // Jika sama maka gabung income baru dengan income bulan ini
                            if (lastBalanceMonth == currentMonth) {
//                                updateBalance(currentBalance: currentBalance)
                                var incomeLeft = Int64(amount)!;
                                
                                let savingSaved: Int64 = currentBalance.savings + Int64(Double(amount)! * 0.2)
                                incomeLeft = incomeLeft - savingSaved
                                
                                let goalSaved: Int64 = currentBalance.goals + Int64(Double(amount)! * 0.3)
                                incomeLeft = incomeLeft - goalSaved
                                
                                // Insert Log Balance Baru
                                let newBalance = BalanceModel(needs: incomeLeft, savings: savingSaved, goals: goalSaved, date_logged: transactionDate)
                                
                                modelContext.insert(newBalance)
                                self.isPresented = false
                            }
                            else {
                            updateBalance(type: 2, currentBalance: currentBalance)
                                var incomeLeft = Int64(amount)!;
                                
                                let savingSaved: Int64 = Int64(Double(amount)! * 0.2)
                                incomeLeft = incomeLeft - savingSaved
                                
                                let goalSaved: Int64 = Int64(Double(amount)! * 0.3)
                                incomeLeft = incomeLeft - goalSaved
                                
                                // Insert Log Balance Baru
                                let newBalance = BalanceModel(needs: incomeLeft, savings: savingSaved, goals: goalSaved, date_logged: transactionDate)
                                
                                modelContext.insert(newBalance)
                                self.isPresented = false
                            }
                        }
                        else if (String(transactionType).lowercased() == "expenses") {
                            let newTransaction = TransactionModel(category: category, date: transactionDate, amount: (-1 * Int64(amount)!), status: false, monthly: isMonthly)
                            
                            // Insert to DB (SwiftData)
                            modelContext.insert(newTransaction)
                            
                            var currentBalance = balance.first!
                            
                            var calendar = Calendar.current
                            var lastBalanceMonth = calendar.component(.month, from: currentBalance.date_logged)
                            var currentMonth = calendar.component(.month, from: Date())
                            
                            var spending = Int64(amount)!;
                            // Jika saldo bulan lalu lebih dari pengeluaran sekarang
                            if(currentBalance.needs >= spending) {
                                let needsBalance = currentBalance.needs - spending
                                
                                // Insert Log Balance Baru
                                let newBalance = BalanceModel(needs: needsBalance, savings: currentBalance.savings, goals: currentBalance.goals, date_logged: transactionDate)
                                
                                modelContext.insert(newBalance)
                                self.isPresented = false
                            }
                            else {
                                insufficientBalance = true
                            }
                            // BAGAIMANA JIKA SALDO NEEDS TIDAK MENCUKUPI UNTUK PENGELUARAN?
//                            else {
//                                let needsBalance = 0
//                                var savings = currentBalance.savings
//                                var goals = currentBalance.goals
//                                var spendingLeft = spending - currentBalance.needs
//                                
//                                if(currentBalance.savings >= spendingLeft) {
//                                    savings = savings - spendingLeft
//                                    spendingLeft = 0
//                                }
//                                
//                                // Insert Log Balance Baru
//                                let newBalance = BalanceModel(needs: currentBalance.needs - spending, savings: currentBalance.savings, goals: currentBalance.goals, date_logged: transactionDate)
//                                
//                                modelContext.insert(newBalance)
//                            }
                        }
                    }
                }
                .foregroundColor(.blue)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Empty Fields"),
                        message: Text("All fields must be filled.")
                    )
                }
                .alert(isPresented: $insufficientBalance) {
                    Alert(
                        title: Text("Insufficient Balance"),
                        message: Text("Hey, let's save up some money to reach your goals.")
                    )
                }
            )
        }
    }
}


#Preview {
    AddTransactionView(isPresented: .constant(true))
        .modelContainer(for: [TransactionModel.self, BalanceModel.self])
}

