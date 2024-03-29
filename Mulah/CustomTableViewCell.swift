//
//  CustomTableViewCell.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

@objc
protocol CustomTableViewCellDelegate {
    @objc optional func customCell(_ cell: CustomTableViewCell, didPressButton button: UIButton)
}

class CustomTableViewCell: UITableViewCell {
    
    var delegate: CustomTableViewCellDelegate?

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelAccount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var imageColor: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBAction func pressButton(_ sender: Any) {
        delegate?.customCell!(self, didPressButton: sender as! UIButton)
    }
    
    public var transaction: Transaction! {
        didSet {
            if transaction != nil {
                self.labelTitle.text = transaction.title
                if let transferAccount = transaction.toBalance {
                    self.button1?.setTitle(transaction.fromBalance!.title, for: .normal)
                    self.button2?.setTitle(transferAccount.title, for: .normal)
                    self.labelAmount.text = String(-transaction.amount)
                } else {
                    self.labelAmount.text = String(transaction.amount)
                    self.button1?.setTitle(transaction.fromBalance!.title, for: .normal)
                }
                self.imageColor.backgroundColor = UIColor.blue
            }
        }
    }
    
    public var safeBox: SafeBox! {
        didSet {
            if safeBox != nil {
                self.textLabel!.text = safeBox.title
                self.detailTextLabel!.text = String(safeBox.balance)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
