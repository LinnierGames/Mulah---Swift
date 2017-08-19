//
//  CustomTableViewCell.swift
//  Mulah
//
//  Created by Erick Sanchez on 8/18/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAccount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var imageColor: UIImageView!
    
    public var transaction: Transaction! {
        didSet {
            if transaction != nil {
                self.labelTitle.text = transaction.title
                if let transferAccount = transaction.toAccount {
                    self.labelAccount.text = "\(transaction.fromAccount!.title!) -> \(transferAccount.title!)"
                    self.labelAmount.text = String(-transaction.amount)
                } else {
                    self.labelAccount.text = transaction?.fromAccount!.title
                    self.labelAmount.text = String(transaction.amount)
                }
                self.imageColor.backgroundColor = UIColor.blue
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
