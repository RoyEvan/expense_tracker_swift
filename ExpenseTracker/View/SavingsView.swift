import SwiftUI
import SwiftData

//struct BalanceModel {
//    var savings: Int64
//}

struct SavingsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var savings: [Saving]
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    let months = Calendar.current.monthSymbols
    let years: [Int] = Array(1900...2100)
    
    @Query var listSavings: [Saving]
    
    var totalSaving: Int
    
    var body: some View {
        VStack {
            // Full-width blue card section
            ZStack {
                Color.blue
                    .edgesIgnoringSafeArea(.horizontal)
                    .frame(height: 150)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Savings")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("\(totalSaving)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(15)
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(0..<months.count, id: \.self) { index in
                            Text(self.months[index])
                                .tag(index + 1) // Months are 1-indexed
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 150)
                    
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                                .tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 100)
                }
            }
            .padding()
            .background(Color.clear)
            .cornerRadius(15)
            .padding(.horizontal)
            
            // History Section
            //                List(listSavings) { t in
            //                    if(!t.status) {
            //                        CardTransaction(transaction: t)
            //                            .listRowBackground(Color.clear)
            //                            .listRowInsets(EdgeInsets())
            //                            .listRowSeparator(.hidden)
            //                            .padding(.bottom,10)
            //                    }
            //                }
            //                .listStyle(PlainListStyle())
            //                .background(Color.clear)
            
            if listSavings.isEmpty {
                Text("No savings available.")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            } else {
                List(listSavings) { saving in
                    VStack {
                        HStack {
                            Text("\(saving.title)")
                                .font(.title3.bold())
                            Spacer()
                        }
                        HStack {
                            Text("\(saving.date, formatter: dateFormatter)")
                            Spacer()
                            Text(String(format: "+ Rp \( saving.amount)")).foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10.0)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Savings")
        .frame(maxHeight: .infinity, alignment: .top)
        
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    SavingsView(totalSaving: 0)
        .modelContainer(for: [Saving.self])
    //    HomeView().modelContainer(for: [TransactionModel.self, BalanceModel.self])
    
}
