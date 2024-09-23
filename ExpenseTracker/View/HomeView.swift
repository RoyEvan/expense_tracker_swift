//  HomeView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//
import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var showingAddTransaction = false
    @State private var showingAddGoal = false
    @State private var selectedSegment = 0
    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionModel]
    @Query var balanceSaving: [BalanceModel]
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balances: [BalanceModel]
    
    var body: some View {
        let balance: BalanceModel = getBalance()
        
        NavigationStack {
            VStack(spacing: 12){
                Text("Summary")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .font(.headline)
                    .padding(.bottom, 8)
                HStack{
                    AppCard(iconTitle: "🤑", subTitle: "Income", money: String(countTransactions(t: transactions)), view: false)
                    
                    NavigationLink(destination: ExpenseView()){
                        AppCard(iconTitle: "💸", iconSub: "-", subTitle: "Expense", money: String(countTransactions(status: false, t: transactions)))
                    }
                }
                HStack{
                    NavigationLink(destination: SavingsView(totalSaving: Int(balance.savings)).modelContainer(for: Saving.self)) {
                        AppCard(iconTitle: "👝", subTitle: "Saving 20%", money: String(balance.savings))
                    }
                    
                    
                    
                    NavigationLink(destination: GoalsView().modelContainer(for: GoalModel.self))
                    {
                        AppCard(iconTitle: "📌", subTitle: "Goals 30%", money: String(balance.goals))
                    }
                    
                    
                }.padding(.bottom, 15)
                
                HStack{
                    Text("Recent Transaction")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.headline)
                    
                    if(transactions.count > 0) {
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
                    if(transactions.count <= 0) {
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
                        
                        //                        Button(action: {
                        //                            showingAddTransaction.toggle()
                        //                        }) {
                        //                            HStack {
                        //                                Image(systemName: "plus").foregroundColor(.white).font(.system(size: 20)).fontWeight(.bold)
                        //                                Text("Add First Income").foregroundColor(.white).font(.system(size: 20)).fontWeight(.bold)
                        //                            }
                        //                            .padding()
                        //                        }
                        //                        .frame(maxWidth: .infinity)
                        //                        .background(Color("appColor"))
                        //                        .cornerRadius(10)
                    }
                    else {
                        Picker("Select Option", selection: $selectedSegment) {
                            Text("Expenses").tag(0)
                            Text("Income").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        
                        if selectedSegment == 0 {
                            List(transactions) { t in
                                if(!t.status) {
                                    CardTransaction(transaction: t)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                        .listRowSeparator(.hidden)
                                        .padding(.bottom,10)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                        else if selectedSegment == 1 {
                            List(transactions) { t in
                                if(t.status) {
                                    CardTransaction(transaction: t)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                        .listRowSeparator(.hidden)
                                        .padding(.bottom,10)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(isPresented: $showingAddTransaction)
                    .modelContainer(for: [TransactionModel.self, BalanceModel.self])
            }
            .navigationTitle("Dashboard")
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    func countTransactions(status: Bool = true, t: [TransactionModel]) -> Int64 {
        var calendar = Calendar.current
        var currentMonth = calendar.component(.month, from: Date())
        
        return t.filter { $0.status == status }
            .filter { calendar.component(.month, from: $0.date) == currentMonth }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getBalance() -> BalanceModel {
        if(balances.isEmpty) {
            let newBalance: BalanceModel = BalanceModel()
            
            modelContext.insert(newBalance)
            
            return newBalance
        }

        return balances.first!
    }
}

#Preview {
    HomeView().modelContainer(for: [TransactionModel.self, BalanceModel.self])
}
