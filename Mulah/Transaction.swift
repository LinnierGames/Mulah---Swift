//
//  Transaction.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

// TODO: use Decimal
public typealias _Decimal = Double

extension Transaction {
    convenience init(title: String? = nil, amount: _Decimal = 0.00, date: Date = Date(), fromBalance: Balance, toBalance: Balance? = nil, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        if title == nil {
            if amount >= 0 {
                self.title = "Income"
            } else {
                self.title = "Expense"
            }
        } else {
            self.title = title
        }
        self.amount = amount
        self.fromBalance = fromBalance
        self.toBalance = toBalance
        self.dateCreated = NSDate()
        self.date = date as NSDate
    }
}
