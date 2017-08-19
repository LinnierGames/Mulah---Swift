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
    
    public convenience init(title: String = "Untitled", `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
    }
    
    public var balance: _Decimal {
        if let managedObjectContext = self.managedObjectContext {
            let fetchTransactions: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchTransactions.predicate = NSPredicate(format: "fromAccount == %@", self)
            let transactions = try! managedObjectContext.fetch(fetchTransactions)
            let transactionBalance = transactions.reduce(0, { (balance, transaction) -> _Decimal in
                return balance + transaction.amount
            })
            
            let fetchTransfers: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchTransfers.predicate = NSPredicate(format: "toAccount == %@", self)
            let transfers = try! managedObjectContext.fetch(fetchTransfers)
            let transferBalance = transfers.reduce(0, { (balance, transaction) -> _Decimal in
                return balance + (transaction.amount * -1)
            })
            
            return transactionBalance + transferBalance
        }
        fatalError()
    }
}

extension NSManagedObjectContext {
    public func listOfAccounts() -> [Account] {
        return (try! AppDelegate.viewContext.fetch(Account.fetchRequest())) as! [Account]
    }
}

extension UIAlertController {
    public convenience init(title: String?, message: String?, forAccounts accounts: [Account], handler: @escaping (Account) -> Swift.Void) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        for account in accounts {
            self.addAction(UIAlertAction(title: account.title, style: .default, handler: { (action) in
                handler(account)
            }))
        }
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}
