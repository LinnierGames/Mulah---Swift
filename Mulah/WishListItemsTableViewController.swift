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
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let identifier = segue.identifier {
     switch identifier {
     case <#pattern#>:
     <#code#>
     default:
     break
     }
     }
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
