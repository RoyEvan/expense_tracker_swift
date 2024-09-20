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
    @State private var transactionType = "Income"
    @State private var amount: Int = 0
    @State private var category: String = "Salary"
    @State private var transactionDate = Date()
    @State private var isMonthly = false
    
    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionModel]

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
                    TextField("Amount", value: $amount, format: .currency(code: "en_ID"))
                        .multilineTextAlignment(.trailing)
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
                    self.isPresented = false
                    
                    if(String(transactionType).lowercased() == "income") {
                        let newTransaction = TransactionModel(category: category, date: transactionDate, amount: amount, status: true, monthly: isMonthly)
                        
                        // Insert to DB (SwiftData)
                        modelContext.insert(newTransaction)
                    }
                    else if (String(transactionType).lowercased() == "expenses") {
                        let newTransaction = TransactionModel(category: category, date: transactionDate, amount: (-1 * amount), status: false, monthly: isMonthly)
                        
                        // Insert to DB (SwiftData)
                        modelContext.insert(newTransaction)
                    }
                    
                    
                }.foregroundColor(.blue)
            )
        }
    }
}


#Preview {
    AddTransactionView(isPresented: .constant(true))
        .modelContainer(for: TransactionModel.self)
}

