import SwiftUI
import SwiftData

struct SavingsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var savings: [Saving]

//    @StateObject private var viewModel = SavingsViewModel()
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
        
    let months = Calendar.current.monthSymbols
    let years: [Int] = Array(1900...2100)
    
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .none
//    formatter.positiveFormat = "0000"
    
    var body: some View {
        NavigationView {
            VStack {
                // Full-width blue card section
                ZStack {
                    // Background color for the full width of the screen
                    Color.blue
                        .edgesIgnoringSafeArea(.horizontal)
                        .frame(height: 150) // Adjust height as needed

                    // Card content
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Savings")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(String(format: "Rp %.2f", totalSavings))
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.clear) // Ensure card itself has no additional background
                    .cornerRadius(15)
                    .padding(.horizontal) // Add padding around the card to separate from edges
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
                                Text(String(year))// Display year as a plain number
                                    .tag(year)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }
                }

                .padding()
                .background(Color.clear) // Ensure card itself has no additional background
                .cornerRadius(15)
                .padding(.horizontal)
                

                // History Section
                List(history) { saving in
                    VStack{
                        HStack{
                            Text("\(saving.title)")
                                .font(.title3.bold())
                            
                            Spacer()
                        }
                        
                        HStack{
//                            let formattedString = formattedYear(from: 2024)
//                            print(formattedString) // Output: "2024"

                            Text("\(saving.date, formatter: dateFormatter)")
                            Spacer()
                            Text(String(format: "+ Rp %.2f", saving.amount)).foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(.colorHistory)
                    .cornerRadius(10.0)
                    .listRowSeparator(.hidden)
                    
//                    HStack {
//                        Text("\(saving.title)")
//                        Text("\(saving.date, formatter: dateFormatter)")
//                        Spacer()
//                        Text(String(format: "Rp %.2f", saving.amount))
//                    }
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationTitle("Savings")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        // Add a new saving entry (Example action)
//                        addSaving(title: "Income",amount: 50.0, date: Date())
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
            Spacer()
            
            
        }
    }
}



private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()



//private func formattedYear(from year: Int) -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy" // Menggunakan format "yyyy" untuk menampilkan tahun tanpa titik
//    if let date = Calendar.current.date(from: DateComponents(year: year)) {
//        return formatter.string(from: date)
//    } else {
//        return "\(year)" // Kembalikan tahun secara langsung jika tidak dapat memformat sebagai tanggal
//    }
//}

var totalSavings: Int64 = 0
var history: [Saving] = []
func addSaving(title: String, amount: Int64, date: Date) {
    let newSaving = Saving(title: title,date: date, amount: amount)
    history.append(newSaving)

    totalSavings += amount
}





#Preview {
    SavingsView().modelContainer(for: Saving.self)
}
