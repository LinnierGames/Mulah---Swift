//
//  TransactionViewController.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/28/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

protocol TransactionViewControllerDelegate {
}

class TransactionViewController: UIViewController {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
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
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(blurEffectView, at: 0)
    }
}
