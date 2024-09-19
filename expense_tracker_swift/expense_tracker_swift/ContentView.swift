import SwiftUI

@main
struct expense_tracker_swiftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var showingTransactionModal = false

    var body: some View {
        Button("Add New Transaction") {
            showingTransactionModal = true
        }
        .sheet(isPresented: $showingTransactionModal) {
            NewTransactionView(isPresented: $showingTransactionModal)
        }
    }
}
