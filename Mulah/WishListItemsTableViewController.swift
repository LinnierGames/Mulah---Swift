//
//  WishListsTableViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/21/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class WishListItemsTableViewController: FetchedResultsTableViewController {
    
    private var fetchedResultsValue: NSFetchedResultsController<WishListItem> {
        return fetchedResultsController as! NSFetchedResultsController<WishListItem>
    }
    
    var wishListGroup: WishListGroup!
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let items = fetchedResultsValue.fetchedObjects {
            let amountSum: _Decimal = abs(items.reduce(0) { $0 + $1.balance})
            let paidSum: _Decimal = abs(items.reduce(0) { $0 + $1.amount})
            
            return "Sum: $\(amountSum) of $\(paidSum) saved"
        } else {
            return "Sum: $0.00"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = fetchedResultsValue.object(at: indexPath)
        cell.textLabel!.text = item.title
        cell.detailTextLabel!.text = "\(item.balance) out of \(item.amount)"
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<WishListItem> = WishListItem.fetchRequest()
        fetch.predicate = NSPredicate(format: "group == %@", wishListGroup)
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertAmount = UITextAlertController(title: "Change Amount", message: "enter a new amount", textFieldConfig: { $0.keyboardType = .numbersAndPunctuation})
        alertAmount.addConfirmAction(action: UIAlertActionInfo(title: "Update", handler: { [weak self] (action) in
            let wishListItem = self!.fetchedResultsValue.object(at: indexPath)
            let amount = _Decimal(alertAmount.inputField.text ?? "0")!
            wishListItem.amount = amount
            AppDelegate.instance.saveContext()
        }))
        self.present(alertAmount, animated: true)
    }
    
    // MARK: Fetch Request
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        
        //update section header when data changes
        let label = self.tableView.headerLabel(forSection: 0)!
        label.text = tableView(self.tableView, titleForHeaderInSection: 0)
        label.updateConstraints()
        label.setNeedsLayout()
    }
    
    // MARK Table View Delegate
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        let alertTitle = UIAlertController(title: "Adding an Item", message: "enter a title", preferredStyle: .alert)
        alertTitle.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title")
        }
        alertTitle.addActions(actions: UIAlertActionInfo(title: "Next", handler: { [weak self] (action) in
            let alertAmount = UIAlertController(title: "Adding an Item", message: "enter an amount", preferredStyle: .alert)
            alertAmount.addTextField(configurationHandler: { (textField) in
                textField.setStyleToParagraph(withPlaceholderText: "amount")
                textField.keyboardType = .numbersAndPunctuation
            })
            alertAmount.addActions(actions: UIAlertActionInfo(title: "Next", handler: { [weak self] (action) in
                let alertAccounts = UIAlertController(title: nil, forBalances: AppDelegate.viewContext.listOfAccounts(), handler: { (account) in
                    _ = WishListItem(title: alertTitle.inputField.text!, amount: _Decimal(alertAmount.inputField.text!)!, physicalAccount: account, group: self!.wishListGroup, in: AppDelegate.viewContext)
                    AppDelegate.instance.saveContext()
                })
                self!.present(alertAccounts, animated: true, completion: nil)
            }))
            self!.present(alertAmount, animated: true, completion: nil)
        }))
        self.present(alertTitle, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = wishListGroup.title
        updateUI()
    }
}
