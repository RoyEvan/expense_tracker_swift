import SwiftUI

struct NewTransactionView: View {
    @Binding var isPresented: Bool
    @State private var transactionType = "Income"
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var transactionDate = Date()
    @State private var isMonthly = false

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
                    Text("Rp")
                        .foregroundColor(.black)
                    TextField("Amount", text: $amount)
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
                    self.isPresented = false
                }.foregroundColor(.blue)
            )
        }
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(isPresented: .constant(true))
    }
}
