//
//  GoalHistory+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//
//

import Foundation
import CoreData


extension GoalHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalHistory> {
        return NSFetchRequest<GoalHistory>(entityName: "GoalHistory")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var created_at: Date?
    @NSManaged public var relationship_cashflow_goal: CashFlow?
    @NSManaged public var relationship_goal_history: Goal?

}

extension GoalHistory : Identifiable {

}
