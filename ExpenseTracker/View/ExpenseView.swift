//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftData
import SwiftUI
import Charts

struct ExpenseView: View {
    @State private var selectedCount: Int?
    @State private var selectedSector: String?
    
    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionModel]
//    let expenses = [
//            TransactionModel(title: "Groceries", date: "10/09/2024", amount: "-IDR 200.000", status: .expense),
//            TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense),
//            TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense),
//            TransactionModel(title: "Transport", date: "11/09/2024", amount: "-IDR 50.000", status: .expense)
//        ]
    
    private var categoryExpense = [
            (name: "Boarding Host", count: 120, color: Color("chartColor1")),
            (name: "Fuel", count: 234, color: Color("chartColor2")),
            (name: "Playing", count: 62, color: Color("chartColor3")),
            (name: "Food&Drink", count: 625, color: Color("chartColor4")),
            (name: "Other", count: 320, color: Color("chartColor5")),
    ]
    
    
    private func findSelectedSector(value: Int) -> String? {

        var accumulatedCount = 0

        let coffee = categoryExpense.first { (_, count,_) in
            accumulatedCount += count
            return value <= accumulatedCount
        }

        return coffee?.name
    }
    
    var body: some View {
        VStack{
            VStack{
                Chart {
                    ForEach(categoryExpense, id: \.name) { category in
                        SectorMark(
                            angle: .value("Cup", category.count),
                            innerRadius: .ratio(0.65),
                            angularInset: 2.0
                        )
                        .opacity(selectedSector == nil ? 1.0 : (selectedSector == category.name ? 1.0 : 0.5))
                        .foregroundStyle(category.color)
                        .cornerRadius(5)
                        .annotation(position: .overlay){
                            Text("\(category.count)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.vertical,10)
                .frame(height: 250)
                .chartAngleSelection(value: $selectedCount)
                .onChange(of: selectedCount) { oldValue, newValue in
                    if let newValue {
                        selectedSector = findSelectedSector(value: newValue)
                    } else {
                        selectedSector = nil
                    }
                }
                
                HStack {
                    ForEach(categoryExpense, id: \.name) { coffee in
                        HStack {
                            Circle()
                                .fill(coffee.color)
                                .frame(width: 10, height: 10)
                            Text(coffee.name)
                                .font(.system(size: 10))
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
            
            Text("Recent Transaction")
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                .font(.headline)
                .padding(.top, 20)
            
            List(transactions) { t in
                if (!t.status) {
                    CardTransaction(transaction: t)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.bottom,10)
                }
            }.listStyle(PlainListStyle())
                .background(Color.clear)
            
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .navigationTitle("Expense")
    }
}

#Preview {
    ExpenseView().modelContainer(for: TransactionModel.self)
}
