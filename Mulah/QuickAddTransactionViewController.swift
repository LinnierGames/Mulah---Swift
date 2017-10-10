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

class QuickAddTransactionViewController: UIViewController, UITextFieldDelegate {
    
    private enum CDTransactionSign {
        case Positive
        case Negative
    }
    
    private enum CDTransactionType {
        case Transaction(CDTransactionSign) //account, amount, title for a single recored, plus or mius
        case TransactionIOU(CDTransactionSign) //account, amount (select IOU), recipent name for a single transaction (negative or positive amount [IOU or You Owe Me]) and IOU recored
        case Transfer //two accounts, amount, title for a single recored (negative amount)
        case Deposit //service type, select record, amount for a single recored (negative amount like a transfer)
    }
    
    private var transactionMode: CDTransactionType!
    
    private var account: Account!
    private var toAccount: Account?
    
    private let rectDeleted = CGRect(x: 31, y: 20, width: 259, height: 27)
    
    fileprivate enum CDControllerStates: Hashable {
        case StatePresenting //Hidden for animation
        case StateOne //Transaction Type
        case StateTwo //Select an Account | Select accounts to transfer between | Select a Type of Deposit
        case StateThree //Enter Amount | Select a deposit account
        case StateFour //Enter title | Enter Amount to deposit | Enter Recipient's Name (for IOU)
        case StateFive //Confirm
    }
    
    fileprivate enum CDViews: Int, Hashable {
        case ViewCancel
        case ViewOne
        case ViewTwo
        case ViewThree
        case ViewFour
        case ViewFive
        
        init(_ tag: Int) {
            self.init(rawValue: tag)!
        }
    }
    
    fileprivate enum CDRectStates {
        case Expanded
        case Hidden
    }
    
    private var controllerState: CDControllerStates! {
        didSet {
            switch controllerState! {
            case .StatePresenting: //set everything to height of zero
                buttonCancel.frame = CGRect(x: 31, y: 20, width: 259, height: 1)
                view1.frame = CGRect(x: 20, y: 55, width: 280, height: 1)
                view2.frame = CGRect(x: 31, y: 176, width: 258, height: 1)
                view3.frame = CGRect(x: 49, y: 200, width: 222, height: 1)
                view4.frame = CGRect(x: 65, y: 222, width: 190, height: 1)
                view5.frame = CGRect(x: 89, y: 236, width: 143, height: 1)
            case .StateOne: //enlarge view one and hide other views
                UIView.animate(withDuration: 0.35) { [weak self] in
                    self!.buttonCancel.frame = CGRect(x: 31, y: 20, width: 259, height: 27)
                    self!.view1.frame = CGRect(x: 20, y: 55, width: 280, height: 117)
                    self!.view2.frame = CGRect(x: 31, y: 176, width: 258, height: 21)
                    self!.view3.frame = CGRect(x: 49, y: 200, width: 222, height: 19)
                    self!.view4.frame = CGRect(x: 65, y: 222, width: 190, height: 11)
                    self!.view5.frame = CGRect(x: 89, y: 236, width: 143, height: 9)
                }
                
                //Wire up buttons
                let buttons = view1.subviews(of: UIButton.self)!
                for button in buttons {
                    button.addTarget(self, action: #selector(pressAction(_:)), for: .touchUpInside)
                }
            case .StateTwo: //delete view one, enlarge view two (normal or extended hieghts) and hide other views
                view2.addSubview(viewSelectAccount)
                UIView.animate(withDuration: 0.35, animations: { [weak self] in
                    self!.view1.frame = self!.rectDeleted
                    self!.view2.frame = CGRect(x: 20, y: 55, width: 280, height: 117)
                    self!.view3.frame = CGRect(x: 31, y: 176, width: 258, height: 21)
                    self!.view4.frame = CGRect(x: 49, y: 200, width: 222, height: 19)
                    self!.view5.frame = CGRect(x: 65, y: 222, width: 190, height: 11)
                    }, completion: { [weak self] (completed) in
                        self!.view1.removeFromSuperview()
                })
                
                //Wire up buttons
                let buttons = view2.subviews(of: UIButton.self)!
                for button in buttons {
                    button.addTarget(self, action: #selector(pressAction(_:)), for: .touchUpInside)
                }
            case .StateThree:
                view3.addSubview(viewEnterAmount)
                UIView.animate(withDuration: 0.35, animations: { [weak self] in
                    self!.view2.frame = self!.rectDeleted
                    self!.view3.frame = CGRect(x: 20, y: 55, width: 280, height: 117)
                    self!.view4.frame = CGRect(x: 31, y: 176, width: 258, height: 21)
                    self!.view5.frame = CGRect(x: 49, y: 200, width: 222, height: 19)
                    }, completion: { [weak self] (completed) in
                        self!.view2.removeFromSuperview()
                })
                
                //Wire up buttons
                let buttons = view3.subviews(of: UIButton.self)!
                for button in buttons {
                    button.addTarget(self, action: #selector(pressAction(_:)), for: .touchUpInside)
                }
            case .StateFour:
                view4.addSubview(viewEnterTitle)
                UIView.animate(withDuration: 0.35, animations: { [weak self] in
                    self!.view3.frame = self!.rectDeleted
                    self!.view4.frame = CGRect(x: 20, y: 55, width: 280, height: 117)
                    self!.view5.frame = CGRect(x: 31, y: 176, width: 258, height: 21)
                    }, completion: { [weak self] (completed) in
                        self!.view3.removeFromSuperview()
                })
                
                //Wire up buttons
                let textfield = view4.subviews(of: UITextField.self)!.first!
                textfield.delegate = self
            case .StateFive:
                view5.addSubview(viewConfirm)
                UIView.animate(withDuration: 0.35, animations: { [weak self] in
                    self!.view4.frame = self!.rectDeleted
                    self!.view4.alpha = 0
                    self!.view5.frame = CGRect(x: 80, y: 55, width: 160, height: 134)
                    self!.buttonCancel.alpha = 0
                    }, completion: { [weak self] (completed) in
                        self!.buttonCancel.removeFromSuperview()
                        self!.view4.removeFromSuperview()
                })
                
                //Wire up confirm buttons
            }
        }
    }
    
    @IBOutlet private weak var buttonCancel: UIButton! { didSet { buttonCancel.tag = 1 } }
    @IBOutlet private weak var view1: UIView! { didSet { view1.tag = 1 } }
    @IBOutlet private weak var view2: UIView! { didSet { view1.tag = 2 } }
    @IBOutlet private weak var view3: UIView! { didSet { view1.tag = 3 } }
    @IBOutlet private weak var view4: UIView! { didSet { view1.tag = 4 } }
    @IBOutlet private weak var view5: UIView! { didSet { view1.tag = 5 } }
    
    @IBOutlet var viewSelectAccount: UIView!
    @IBOutlet var viewSelectTransferAccounts: UIView!
    @IBOutlet var viewEnterAmount: UIView!
    @IBOutlet var viewEnterTitle: UIView!
    @IBOutlet var viewSelectDeposit: UIView!
    @IBOutlet var viewSelectDepositAccount: UIView!
    @IBOutlet var viewConfirm: UIView!
    @IBOutlet var viewConfirmTransfer: UIView!
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        controllerState = CDControllerStates.StateFive
        textField.resignFirstResponder()
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func pressAction(_ sender: Any) {
        switch controllerState! {
        case .StateOne:
            controllerState = CDControllerStates.StateTwo
        case .StateTwo:
            controllerState = CDControllerStates.StateThree
        case .StateThree:
            controllerState = CDControllerStates.StateFour
        case .StateFour:
            controllerState = CDControllerStates.StateFive
        case .StateFive:
            break
        case .StatePresenting:
            break
        }
    }
    
    @IBAction private func pressCancel(_ sender: Any) {
        presentingViewController!.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        controllerState = .StatePresenting
        controllerState = .StateOne
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(blurEffectView, at: 0)
    }
}

extension UIView {
    func subviews<T>(of t: T.Type) -> [T]? {
        var collection = Array<T>()
        for subview in subviews as [Any] {
            if subview is UIView && !(subview is T) {
                if let newCollection = (subview as! UIView).subviews(of: t) {
                    collection.insert(contentsOf: newCollection, at: 0)
                }
            } else {
                if subview is T {
                    collection.append(subview as! T)
                }
            }
        }
        
        return collection
    }
}
