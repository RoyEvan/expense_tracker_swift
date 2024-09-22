// Saving.swift
import Foundation
import SwiftData

@Model
class Saving {
//    let id = UUID()
    let title: String
    let date: Date
    let amount: Int64
    
    init(title: String, date: Date, amount: Int64) {
        self.title = title
        self.date = date
        self.amount = amount
    }
    
    
}

//class SavingsViewModel: ObservableObject {
//    @Published var totalSavings: Double = 0.0
//    @Published var history: [Saving] = []
//
////    @Query var history2 : [Saving]
////    @Environment(\.modelContext) var modelContext
//
//    // Example function to add a saving entry
//    func addSaving(title: String,amount: Double, date: Date) {
//        let newSaving = Saving(title: title,date: date, amount: amount)
//        history.append(newSaving)
//
//        totalSavings += amount
//    }
//
//}
