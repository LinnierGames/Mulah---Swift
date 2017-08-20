//
//  Account.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Account {
    public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        
        return fetch
    }
    
    public convenience init(title: String = "Untitled", dateCreated date: Date = Date(), `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.dateCreated = date as NSDate
    }
}

extension NSManagedObjectContext {
    public func listOfBalances() -> [Balance] {
        return ((try! AppDelegate.viewContext.fetch(Balance.fetchRequest())) as! [Balance])
    }
    
    public func listOfAccounts() -> [Account] {
        return ((try! AppDelegate.viewContext.fetch(Account.fetchRequest())) as! [Account])
    }
}
