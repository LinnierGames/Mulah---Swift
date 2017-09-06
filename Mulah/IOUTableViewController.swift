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
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        if state == .IOweYou {
            fetch.predicate = NSPredicate(format: "amount < 0")
        } else {
            fetch.predicate = NSPredicate(format: "amount >= 0")
        }
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let ious = fetchedResultsController.fetchedObjects as! [IOU]? {
            return "Sum: $\(abs(ious.reduce(0) { $0 + $1.balance})) of $\(abs(ious.reduce(0) { $0 + $1.amount})) paid"
        } else {
            return "Sum: $0.00"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iou = fetchedResultsController.iou(atIndexPath: indexPath)
        let alertPayment = UIAlertController(title: "Add a Payment", message: "enter an amount", preferredStyle: .alert)
        alertPayment.addTextField { (textField) in
            textField.keyboardType = .numbersAndPunctuation
            textField.placeholder = "amount"
        }
        alertPayment.addActions(actions:
            UIAlertActionInfo(title: "Add", handler: { (action) in
                let amount = _Decimal(alertPayment.inputField.text!)!
                _ = Transaction(amount: amount, fromBalance: iou, in: AppDelegate.viewContext)
                AppDelegate.instance.saveContext()
            })
        )
        self.present(alertPayment, animated: true, completion: nil)
    }
    
    // MARK: - IBACTIONS
    
    private enum VCState {
        case IOweYou
        case YouOweMe
    }
    
    private var state: VCState = .IOweYou {
        didSet {
            switch state {
            case .IOweYou:
                buttonIOU.setTitleColor(UIColor.white, for: .normal)
                buttonIOU.backgroundColor = UIColor.currencyExpense
                
                buttonUOM.setTitleColor(UIColor.currencyIncome, for: .normal)
                buttonUOM.backgroundColor = nil
            case .YouOweMe:
                buttonIOU.setTitleColor(UIColor.currencyExpense, for: .normal)
                buttonIOU.backgroundColor = nil
                
                buttonUOM.setTitleColor(UIColor.white, for: .normal)
                buttonUOM.backgroundColor = UIColor.currencyIncome
            }
            updateUI()
        }
    }
    
    @IBOutlet weak var buttonIOU: UIButton!
    @IBOutlet weak var buttonUOM: UIButton!
    @IBAction func changedState(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            state = .IOweYou
        case 2:
            state = .YouOweMe
        default: break
        }
    }
    
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
                    UIAlertActionInfo(title: "Next", handler: { [weak self] (action) in
                        let alertRecipient = UIAlertController(title: "Adding an IOU", message: "enter a recipient", preferredStyle: .alert)
                        alertRecipient.addTextField { (textField) in
                            textField.setStyleToParagraph(withPlaceholderText: "optional")
                        }
                        alertRecipient.addActions(actions:
                            UIAlertActionInfo(title: "Add", handler: { (action) in
                                var amount = abs(_Decimal(alert.inputField.text!)!)
                                if self!.state == .IOweYou {
                                    amount *= -1
                                }
                                _ = IOU(recipient: alertRecipient.inputField.text!, title: alertTitle.inputField.text!, amount: amount, in: AppDelegate.viewContext)
                                AppDelegate.instance.saveContext()
                            })
                        )
                        self!.present(alertRecipient, animated: true, completion: nil)
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
        
        tableView.rowHeight = 38
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateUI()
    }
}
