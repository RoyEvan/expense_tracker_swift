//
//  CashFlow+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//
//

import Foundation
import CoreData


extension CashFlow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashFlow> {
        return NSFetchRequest<CashFlow>(entityName: "CashFlow")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var created_at: Date?
    @NSManaged public var transaction_id: UUID?
    @NSManaged public var type: Int16

}

extension CashFlow : Identifiable {

}
