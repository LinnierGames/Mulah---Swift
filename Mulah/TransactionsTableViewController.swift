//
//  TransactionsTableViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class TransactionsTableViewController: FetchedResultsTableViewController, CustomTableViewCellDelegate {
    
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
    
    private var fetchedResultsValue: NSFetchedResultsController<Transaction> {
        return fetchedResultsController as! NSFetchedResultsController<Transaction>
    }
    
    private var selectedIndexPath: IndexPath? {
        didSet {
            if oldValue != nil {
                tableView.reloadRows(at: [oldValue!], with: .fade)
            }
            if selectedIndexPath != nil {
                tableView.reloadRows(at: [selectedIndexPath!], with: .fade)
            }
        }
    }
    
    // MARK: - RETURN VALUES
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell
        let transaction = fetchedResultsValue.object(at: indexPath)
        if let expandedIndexPath = selectedIndexPath {
            if expandedIndexPath == indexPath {
                if transaction.toAccount != nil {
                    cell = tableView.dequeueReusableCell(withIdentifier: "transaction expanded transfer", for: indexPath) as! CustomTableViewCell
                    cell.delegate = self
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "transaction expanded", for: indexPath) as! CustomTableViewCell
                    cell.delegate = self
                }
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! CustomTableViewCell
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! CustomTableViewCell
        }
        
        cell.transaction = transaction
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath != nil {
            if selectedIndexPath! == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        } else {
            selectedIndexPath = indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let transaction = fetchedResultsValue.object(at: indexPath)
        let alert = UIAlertController(title: "Update Amount", message: "enter an amount", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "amount", withInitalText: String(transaction.amount))
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Update", handler: { (action) in
            transaction.amount = Double(alert.inputField.text!)!
            AppDelegate.instance.saveContext()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK Custom Table View Cell Delegate
    
    func customCell(_ cell: CustomTableViewCell, didPressButton button: UIButton) {
        let transaction = fetchedResultsValue.object(at: tableView.indexPath(for: cell)!)
        switch button.tag {
        case 1: //edit
            let alert = UIAlertController(title: "Rename Transaction", message: "enter a title", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.setStyleToParagraph(withPlaceholderText: "title", withInitalText: transaction.title)
            }
            alert.addActions(actions: UIAlertActionInfo(title: "Rename", handler: { (action) in
                transaction.title = alert.inputField.text
                AppDelegate.instance.saveContext()
            }))
            self.present(alert, animated: true, completion: nil)
        case 2: //from Account
            break
        case 3: //to account
            break
        default:
            break
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 32
        
        updateUI()
    }
    
}
