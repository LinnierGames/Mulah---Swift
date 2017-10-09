//
//  Categories.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    @IBAction func pressDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UITableView {
    
    func returnCell(forIdentifier identifier: String = "cell", atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = nil
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.text = nil
        cell.detailTextLabel?.textColor = UIColor.black
        cell.accessoryType = .none
        
        return cell
    }
}

extension UITableViewCell {
    
    func setState(enabled: Bool) {
        if enabled {
            self.textLabel!.alpha = 1
            self.detailTextLabel!.alpha = 1
            self.isUserInteractionEnabled = true
        } else {
            self.textLabel!.alpha = 0.3
            self.detailTextLabel!.alpha = 0.3
            self.isUserInteractionEnabled = false
        }
    }
}

extension UIAlertController {
    /// Quickly add an alert message with the action title of Dimiss
    convenience init(alertWithTitle title: String? = nil, message: String? = nil, action: UIAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(action)
    }
}

extension UIColor {
    
    static var defaultButtonTint: UIColor { return UIColor(red: 0, green: 122/255, blue: 1, alpha: 1) }
    
    static var disabledState: UIColor { return UIColor(white: 0.65, alpha: 1) }
    static var disabledStateOpacity: CGFloat { return 0.35 }
    
    static var currencyIncome: UIColor { return UIColor(red: 0, green: 128/255, blue: 0, alpha: 1) }
    static var currencyExpense: UIColor { return UIColor(red: 206/255, green: 7/255, blue: 85/255, alpha: 1) }
}

