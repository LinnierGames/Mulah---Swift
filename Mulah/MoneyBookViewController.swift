//
//  MoneyBookViewController.swift
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
    
    private func addTransaction() {
        let alert = UIAlertController(title: "New Transaction", message: "enter the amount", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numbersAndPunctuation
            textField.placeholder = "amount"
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Next", handler: { [weak alert, weak self] (action) in
            if let amount = Double(alert!.inputField.text!) {
                let alertAccount = UIAlertController(message: "select an account", forBalances: AppDelegate.viewContext.listOfBalances(), handler: { (balance) in
                    _ = Transaction(amount: amount, fromBalance: balance, in: AppDelegate.viewContext)
                    AppDelegate.instance.saveContext()
                })
                self?.present(alertAccount, animated: true, completion: nil)
            } else {
                self?.present(UIAlertController(alertWithTitle: "New Transaction", message: "invalid amount entered"), animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addTransfer() {
        let alertFromAccount = UIAlertController(title: "From Account", message: "select an account", forBalances: AppDelegate.viewContext.listOfBalances(), handler: { [weak self] (fromAccount) in
            let alertToAccount = UIAlertController(title: "To Account", message: "select an account", forBalances: AppDelegate.viewContext.listOfBalances().filter { $0 != fromAccount }, handler: { [weak self] (toAccount) in
                let alertAmount = UIAlertController(title: nil, message: "enter the amount", preferredStyle: .alert)
                alertAmount.addTextField { (textField) in
                    textField.keyboardType = .numbersAndPunctuation
                    textField.placeholder = "amount"
                }
                alertAmount.addActions(actions:
                    UIAlertActionInfo(title: "Add", handler: { (action) in
                        let transactionTitle: String
                        if fromAccount is Account != true || toAccount is Account != true {
                            transactionTitle = "Deposit"
                        } else {
                            transactionTitle = "Transfer"
                        }
                        _ = Transaction(title: transactionTitle, amount: -Double(alertAmount.inputField.text!)!, fromBalance: fromAccount, toBalance: toAccount, in: AppDelegate.viewContext)
                        AppDelegate.instance.saveContext()
                    })
                )
                self?.present(alertAmount, animated: true, completion: nil)
            })
            self?.present(alertToAccount, animated: true, completion: nil)
        })
        self.present(alertFromAccount, animated: true, completion: nil)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    
    @IBAction func pressDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE

}
