//
//  AppCardGoals.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 17/09/24.
//
import SwiftData
import SwiftUI


struct AppCardGoals: View {
    var goal: GoalModel = GoalModel()
//    
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balances: [BalanceModel]
    
    var body: some View {
        
        VStack {
            let percentFinish: Float = (Float(balances.first?.goals ?? 0)/Float(goal.amount))
//                let percentFinish: Float = (0)/Float(100)
            
            HStack {
                Image(systemName: "house.fill")
                    .padding(10)
                    .background(Color("cardColor"))
                    .cornerRadius(10)
                
                Text(goal.title).font(.headline)
//                    Text("title").font(.headline)
                
                Spacer()
                
                Text("\(Int(percentFinish*100))%")
                    .bold()
                    .foregroundColor(Color("appColor"))
            }
            
            ProgressView(value: percentFinish)
            
            HStack {
                Text("\(balances.first?.goals ?? 0)")
                    .fontWeight(.medium)
                    .font(.system(size: 12))
//                    Text("\(0)")
//                        .fontWeight(.medium)
//                        .font(.system(size: 12))
                
                Spacer()
                
                Text("\(goal.amount)")
                    .fontWeight(.medium)
                    .font(.system(size: 12))
//                    Text("\(0)")
//                        .fontWeight(.medium)
//                        .font(.system(size: 12))
            }
        }
        
        
//        .padding()
//        .frame(width: .infinity)
//        .background(.white)
//        .cornerRadius(10)
//        .shadow(radius: 3)
    }
}

#Preview {
    AppCardGoals()
}
