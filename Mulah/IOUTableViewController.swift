//
//  IOUTableViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 9/3/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class IOUTableViewController: FetchedResultsTableViewController {
    
    // MARK: - RETURN VALUES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.iou = fetchedResultsController.iou(atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        let fetch: NSFetchRequest<IOU> = IOU.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "recipient", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
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
    
    // MARK: - IBACTIONS
    
    @IBAction func pressAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Adding an IOU", message: "enter an amount", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "amount"
            textField.keyboardType = .numbersAndPunctuation
        }
        alert.addActions(actions:
            UIAlertActionInfo(title: "Next", handler: { [weak self] (action) in
                let alertTitle = UIAlertController(title: "Adding an IOU", message: "enter a title", preferredStyle: .alert)
                alertTitle.addTextField { (textField) in
                    textField.setStyleToParagraph(withPlaceholderText: "title")
                }
                alertTitle.addActions(actions:
                    UIAlertActionInfo(title: "Add", handler: { (action) in
                        let amount = _Decimal(alert.inputField.text!)!
                        _ = IOU(title: alertTitle.inputField.text!, amount: amount, in: AppDelegate.viewContext)
                        AppDelegate.instance.saveContext()
                    })
                )
                self!.present(alertTitle, animated: true, completion: nil)
            })
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateUI()
    }
}
