//
//  Account.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

extension Account {
    public convenience init(title: String = "Untitled", `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
    }
}
