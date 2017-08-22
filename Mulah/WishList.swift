//
//  WishList.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/21/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension WishListGroup {
    convenience init(title: String = "Untitled Group", dateCreated date: Date = Date(), `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = date as NSDate
    }
}

extension WishList {
    convenience init(title: String = "Untitled", dateCreated date: Date = Date(), amount: _Decimal, physicalAccount account: Account, group: WishListGroup, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.amount = amount
        self.group = group
        self.dateCreated = date as NSDate
        self.physicalAccount = account
    }
}
