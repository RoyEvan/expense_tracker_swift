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
    
    @Query(sort: \BalanceModel.date_logged, order: .reverse) var balances: [BalanceModel]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "house.fill")
                    .padding(10)
                    .background(Color("cardColor"))
                    .cornerRadius(10)
                
                Text(goal.title).font(.headline)
                
                Spacer()
                let percentFinish: Int = Int((Float(balances.first!.goals)/Float(goal.amount))*100.0)
                Text("\(percentFinish)%")
                    .bold()
                    .foregroundColor(Color("appColor"))
            }
            
            ProgressView(value: 0.5)
            
            HStack {
                Text("\(balances.first!.goals)")
                    .fontWeight(.medium)
                    .font(.system(size: 12))
                
                Spacer()
                
                Text("\(goal.amount)")
                    .fontWeight(.medium)
                    .font(.system(size: 12))
            }
        }
        .padding()
        .frame(width: .infinity)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        
        Text("")
    }
}

#Preview {
    AppCardGoals(goal: GoalModel()).modelContainer(for: BalanceModel.self)
}
