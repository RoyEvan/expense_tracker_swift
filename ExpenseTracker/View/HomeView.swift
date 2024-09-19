//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showingAddTransaction = false
    @State private var selectedSegment = 0
    
    let expenses = [
        TransactionModel(title: "Groceries", date: "10/09/2024", amount: "-IDR 200.000", status: .expense),
        TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense),
        TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense),
        TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense)
    ]
    
    let income = [
        TransactionModel(title: "Salary", date: "01/09/2024", amount: "+IDR 5.000.000", status: .income),
        TransactionModel(title: "Freelance", date: "05/09/2024", amount: "+IDR 2.000.000", status: .income),
        TransactionModel(title: "Salary", date: "01/09/2024", amount: "+IDR 5.000.000", status: .income),
        TransactionModel(title: "Freelance", date: "05/09/2024", amount: "+IDR 2.000.000", status: .income)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12){
                AppButton(title: "+ Add First Income", textColor: .white, backgroundColor: "appColor").padding(.bottom, 8)
                Text("Summary")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .font(.headline)
                    .padding(.bottom, 8)
                HStack{
                    AppCard(iconTitle: "🤑", iconSub: "+", subTitle: "Income", money: "0",view: false)
                    NavigationLink(destination: ExpenseView()){
                        AppCard(iconTitle: "💸", iconSub: "-", subTitle: "Expense", money: "0")
                    }
                }
                HStack{
                    AppCard(iconTitle: "👝", subTitle: "Saving 20%", money: "0")
                    NavigationLink(destination: GoalsView()){
                        AppCard(iconTitle: "📌", subTitle: "Goals 30%", money: "0")
                    }
                    
                    
                }.padding(.bottom, 15)
                
                HStack{
                    Text("Recent Transaction")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.headline)
                    Button(action: {
                        showingAddTransaction.toggle()
                    }) {
                        Text("Add Transaction")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                }
                VStack {
                    Picker("Select Option", selection: $selectedSegment) {
                        Text("Expenses").tag(0)
                        Text("Income").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    if selectedSegment == 0 {
                        List(expenses) { transaction in
                            CardTransaction(transaction: transaction)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.bottom,10)
                        }.listStyle(PlainListStyle())
                            .background(Color.clear)
                        
                    } else if selectedSegment == 1 {
                        List(income) { transaction in
                            CardTransaction(transaction: transaction)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.bottom,10)
                        }.listStyle(PlainListStyle())
                            .background(Color.clear)
                    }
                }
            }.padding()
                .sheet(isPresented: $showingAddTransaction) {
                    AddTransactionView()
                }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    HomeView()
}

