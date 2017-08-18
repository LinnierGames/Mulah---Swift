//
//  ActivityViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class MoneyBookViewController: UIViewController {
    
    @IBOutlet weak var tableController: UIView!
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        // TODO: Add Account Module
        let alert = UIAlertController(title: "New Transaction", message: "enter the amount", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "amount"
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Next", handler: { [weak alert, weak self] (action) in
            let amount = Double(alert!.inputField.text!)!
            let alertAccount = UIAlertController(title: nil, message: "select an account", preferredStyle: .actionSheet)
            let listOfAccounts = (try! AppDelegate.viewContext.fetch(Account.fetchRequest())) as! [Account]
            for account in listOfAccounts {
                alertAccount.addAction(UIAlertAction(title: account.title, style: .default, handler: { (action) in
                    _ = Transaction(amount: amount, fromAccount: account, in: AppDelegate.viewContext)
                    AppDelegate.instance.saveContext()
                }))
            }
            alertAccount.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self?.present(alertAccount, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE

}
