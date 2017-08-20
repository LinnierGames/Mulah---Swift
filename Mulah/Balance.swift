//
//  Balance.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/19/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension Balance {
    public var balance: _Decimal {
        if let managedObjectContext = self.managedObjectContext {
            let fetchTransactions: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchTransactions.predicate = NSPredicate(format: "fromBalance == %@", self)
            let transactions = try! managedObjectContext.fetch(fetchTransactions)
            let transactionBalance = transactions.reduce(0, { (balance, transaction) -> _Decimal in
                return balance + transaction.amount
            })
            
            let fetchTransfers: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchTransfers.predicate = NSPredicate(format: "toBalance == %@", self)
            let transfers = try! managedObjectContext.fetch(fetchTransfers)
            let transferBalance = transfers.reduce(0, { (balance, transaction) -> _Decimal in
                return balance + (transaction.amount * -1)
            })
            
            return transactionBalance + transferBalance
        }
        fatalError("Missing ManagedObjectContext")
    }
    
    public var realtimeBalance: _Decimal? {
        let physicalBalance = self.balance
        
        let fetchSafeBoxes: NSFetchRequest<SafeBox> = SafeBox.fetchRequest()
        fetchSafeBoxes.predicate = NSPredicate(format: "physicalAccount == %@", self)
        let safeBoxes = try! self.managedObjectContext!.fetch(fetchSafeBoxes)
        let safeBoxesSum = safeBoxes.reduce(0) { (sum, safeBox) -> _Decimal in
            return safeBox.balance + sum
        }
        
        if safeBoxes.count == 0 { // && wishLists.count == 0, etc
            return nil
        }
        
        return physicalBalance + safeBoxesSum
    }
}

extension UIAlertController {
    public convenience init(title: String?, message: String? = "select an account", forBalances balances: [Balance], handler: @escaping (Balance) -> Swift.Void) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        for balance in balances {
            self.addAction(UIAlertAction(title: balance.title, style: .default, handler: { (action) in
                handler(balance)
            }))
        }
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}
