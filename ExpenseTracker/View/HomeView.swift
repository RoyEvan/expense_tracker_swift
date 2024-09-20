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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12){
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
                    NavigationLink(destination: SavingsView().modelContainer(for: Saving.self)) {
                        AppCard(iconTitle: "👝", subTitle: "Saving 20%", money: "0")
                    }
                    
                   

                    NavigationLink(destination: GoalsView().modelContainer(for: GoalModel.self))
                    {
                        AppCard(iconTitle: "📌", subTitle: "Goals 30%", money: "0")
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
                        
                        NavigationLink(destination: Example()) {
                            AppButton(title: "Add First Income", textColor: .white, backgroundColor: "appColor").padding(.bottom, 8)
                        }
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
            }
            .navigationTitle("Dashboard")
        }.edgesIgnoringSafeArea(.bottom)
    }
    
  
}

#Preview {
    HomeView().modelContainer(for: TransactionModel.self)
}
