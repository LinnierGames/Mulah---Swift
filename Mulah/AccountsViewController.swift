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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let account = fetchedResultsValue.object(at: indexPath)
        cell.textLabel!.text = account.title
        cell.detailTextLabel!.text = String(account.balance)
        
        return cell
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
        updateUI()
    }

}
