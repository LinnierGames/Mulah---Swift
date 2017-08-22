//
//  WishListsTableViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/21/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class WishListGroupsTableViewController: FetchedResultsTableViewController {
    
    private var fetchedResultsValue: NSFetchedResultsController<WishListGroup> {
        return fetchedResultsController as! NSFetchedResultsController<WishListGroup>
    }
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let group = fetchedResultsValue.object(at: indexPath)
        cell.textLabel!.text = group.title
        cell.detailTextLabel!.text = String(group.items!.count)
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<WishListGroup> = WishListGroup.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        fetchedResultsController = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetch as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: AppDelegate.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show item":
                let vc = segue.destination as! WishListItemsTableViewController
                let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
                vc.wishListGroup = fetchedResultsValue.object(at: indexPath)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK Table View Delegate
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let group = fetchedResultsValue.object(at: indexPath)
        let alert = UIAlertController(title: "Update Group", message: "enter a title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title", withInitalText: String(group.title!))
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Update", handler: { (action) in
            group.title = alert.inputField.text
            AppDelegate.instance.saveContext()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    @IBAction func pressAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Adding a Group", message: "enter a title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: "title")
        }
        alert.addActions(actions: UIAlertActionInfo(title: "Add", handler: { (action) in
            _ = WishListGroup(title: alert.inputField.text!, in: AppDelegate.viewContext)
            AppDelegate.instance.saveContext()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateUI()
    }
}
