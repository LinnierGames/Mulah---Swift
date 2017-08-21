//
//  SafeBoxesTableViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/19/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class SafeBoxesTableViewController: FetchedResultsTableViewController {
    
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
    
    private var fetchedResultsValue: NSFetchedResultsController<SafeBox> {
        return fetchedResultsController as! NSFetchedResultsController<SafeBox>
    }
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsValue.sections![section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.safeBox = fetchedResultsValue.object(at: indexPath)
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<SafeBox> = SafeBox.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: "physicalAccount.title",
            cacheName: nil
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pressAdd(_ sender: Any) {
        // TODO: Add Safe Box Module
        let alertTitle = UIAlertController(title: "New Safe Box", message: "enter a title", preferredStyle: .alert)
        alertTitle.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title", withInitalText: nil)
        }
        alertTitle.addActions(actions:
            UIAlertActionInfo(title: "Next", handler: { [weak self] (action) in
                let alertAccounts = UIAlertController(title: nil, forBalances: AppDelegate.viewContext.listOfAccounts(), handler: { (account) in
                    _ = SafeBox(title: alertTitle.inputField.text!, physicalAccount: account as! Account, in: AppDelegate.viewContext)
                    AppDelegate.instance.saveContext()
                })
                self!.present(alertAccounts, animated: true, completion: nil)
            })
        )
        self.present(alertTitle, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateUI()
    }

}
