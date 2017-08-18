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
typealias _Decimal = Double

extension Transaction {
    convenience init(title: String = "Untitled", amount: _Decimal = 0.00, date: Date = Date(), fromAccount: Account, toAccount: Account? = nil, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.amount = amount
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.dateCreated = NSDate()
        self.date = date as NSDate
        
    }
}
