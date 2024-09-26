//  HomeView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//
import SwiftData
import SwiftUI

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var showingAddTransaction = false
    @State private var showingEditTransaction = false
    @State private var selectedTransaction: TransactionModel? // State for selected transaction
    @State private var selectedSegment = 0

    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionModel] // Fetch all transactions
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balances: [BalanceModel] // Fetch balance

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter
    }

    var body: some View {
        let balance: BalanceModel = getBalance()

        NavigationStack {
            VStack(spacing: 12) {
                Text("Summary")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .padding(.bottom, 8)
                
                // Summary of Balance and Expenses
                HStack {
                    AppCard(iconTitle: "🤑", subTitle: "Balance", money: formatAmount(balance.needs), view: false)
                        .foregroundColor(.green)

                    NavigationLink(destination: ExpenseView()) {
                        AppCard(iconTitle: "💸", iconSub: "-", subTitle: "Expense", money: formatAmount(countTransactions(status: false, t: transactions)))
                            .foregroundColor(.red)
                    }
                }

                // Summary of Saving and Goals
                HStack {
                    NavigationLink(destination: SavingsView(totalSaving: Int(balance.savings))) {
                        AppCard(iconTitle: "👝", subTitle: "Saving 20%", money: formatAmount(balance.savings))
                    }

                    NavigationLink(destination: GoalsView()) {
                        AppCard(iconTitle: "📌", subTitle: "Goals 30%", money: formatAmount(balance.goals))
                    }
                }
                .padding(.bottom, 15)
                
                // Recent Transaction section
                HStack {
                    Text("Recent Transaction")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)

                    if transactions.count > 0 {
                        Button(action: {
                            showingAddTransaction.toggle()
                        }) {
                            Text("Add Transaction")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.headline)
                                .fontWeight(.regular)
                        }
                    }
                }

                VStack {
                    if transactions.isEmpty {
                        VStack {
                            Spacer()
                            Text("You have no transactions").foregroundColor(.secondary)
                            Spacer()
                        }

                        Spacer()

                        AppButton(
                            title: "Add First Income",
                            action: {
                                showingAddTransaction.toggle()
                            }
                        )
                    } else {
                        // Segmented Picker for Income/Expenses
                        Picker("Select Option", selection: $selectedSegment) {
                            Text("Expenses").tag(0)
                            Text("Income").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)

                        // Show Transactions by selected segment
                        List(transactions) { t in
                            if (selectedSegment == 0 && !t.status) || (selectedSegment == 1 && t.status) {
                                Button(action: {
                                    showingEditTransaction = true
                                    selectedTransaction = t // Select the transaction to edit
                                }) {
                                    CardTransaction(transaction: t)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                        .listRowSeparator(.hidden)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .padding()
            // Show AddTransactionView as a sheet
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(isPresented: $showingAddTransaction)
            }
            // Show EditTransactionView as a sheet when a transaction is selected
            .sheet(isPresented: $showingEditTransaction) {
                if let transaction = selectedTransaction {
                    EditTransactionView(
                        isPresented: $showingEditTransaction,
                        transaction: Binding(
                            get: { transaction }, // Pass the selected transaction as binding
                            set: { newValue in selectedTransaction = newValue }
                        )
                    )
                }
            }
            .navigationTitle("Dashboard")
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    // Helper function to count transactions for current month
    func countTransactions(status: Bool = true, t: [TransactionModel]) -> Int64 {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        return t.filter { $0.status == status }
                .filter { calendar.component(.month, from: $0.date) == currentMonth }
                .reduce(0) { $0 + $1.amount }
    }

    // Function to get balance, or create a new one if none exists
    func getBalance() -> BalanceModel {
        if balances.isEmpty {
            let newBalance = BalanceModel(needs: 0, savings: 0, goals: 0, date_logged: Date())
            modelContext.insert(newBalance)
            return newBalance
        }
        return balances.first!
    }

    // Format the amount to currency with a number formatter
    private func formatAmount(_ amount: Int64) -> String {
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "0"
    }
}
#Preview {
    HomeView()
        .modelContainer(for: [TransactionModel.self, BalanceModel.self, GoalModel.self, Saving.self])
}
