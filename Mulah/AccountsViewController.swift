//
//  AccountsViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/17/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: FetchedResultsTableViewController {
    
    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject>! {
        didSet {
            if let controller = fetchedResultsController {
                controller.delegate = self
                do {
                    try controller.performFetch()
                } catch {
                    print(error.localizedDescription)
                }
                tableView.reloadData()
            }
        }
    }
    
    private var fetchedResultsValue: NSFetchedResultsController<Account> {
        return fetchedResultsController as! NSFetchedResultsController<Account>
    }
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = fetchedResultsValue.object(at: indexPath)
        
        if let realtimeBalance = account.realtimeBalance {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell realtime balance", for: indexPath) as! CustomTableViewCell
            
            cell.labelTitle.text = account.title
            cell.labelSubtitle.text = "Realtime Balance: \(String(realtimeBalance))"
            cell.labelAmount.text = String(account.balance)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel!.text = account.title
            cell.detailTextLabel!.text = String(account.balance)
            
            return cell
        }
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<Account> = Account.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: "typeValue",
            cacheName: nil
        )
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let account = fetchedResultsValue.object(at: indexPath)
            let alertBalance = UIAlertController(title: "Updating the Balance", message: "enter a balance", preferredStyle: .alert)
            alertBalance.addTextField(configurationHandler: { (textField) in
                textField.placeholder = String(account.balance)
            })
            alertBalance.addActions(actions:
                UIAlertActionInfo(title: "Update", handler: { (action) in
                    if let newBalance = _Decimal(alertBalance.inputField.text!) {
                        let alertUpdateType = UIAlertController(title: "Updating the Balance", message: "select what would you like to update", preferredStyle: .actionSheet)
                        func insertUpdatingTransaction(withOffset deciaml: _Decimal) {
                            let balance = newBalance - deciaml
                            _ = Transaction(title: "Update Balance", amount: balance, fromBalance: account, in: AppDelegate.viewContext)
                            AppDelegate.instance.saveContext()
                            
                        }
                        alertUpdateType.addActions(actions:
                            UIAlertActionInfo(title: "Balance", handler: { (alert) in
                                insertUpdatingTransaction(withOffset: account.balance)
                            })
                        )
                        if account.realtimeBalance != nil {
                            alertUpdateType.addAction(UIAlertAction(title: "Realtime Balance", style: .default, handler: { (action) in
                                insertUpdatingTransaction(withOffset: account.realtimeBalance!)
                            }))
                        }
                        self.present(alertUpdateType, animated: true, completion: nil)
                    } else {
                        self.present(UIAlertController(alertWithTitle: "Updating the Balance", message: "invalid amount"), animated: true, completion: nil)
                    }
                })
            )
            self.present(alertBalance, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        // TODO: Add Account Module
        let alert = UIAlertController(title: "New Account", message: "enter the title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title", withInitalText: nil)
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Add", handler: { [weak alert] (action) in
            _ = Account(title: alert!.inputField.text!, in: AppDelegate.viewContext)
            AppDelegate.instance.saveContext()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        updateUI()
    }

}
