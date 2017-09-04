//
//  IOU.swift
//  Mulah
//
//  Created by Erick Sanchez on 9/3/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import CoreData

enum IOUType {
    case YouOweMe
    case IOweYou
}

extension IOU {
    convenience init(dateCreated: Date = Date(), recipient: String? = nil, title: String, amount: _Decimal, `in` context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.recipient = recipient
        self.amount = amount
        self.dateCreated = dateCreated as NSDate
    }
}

extension NSFetchedResultsController {
    public func iou(atIndexPath indexPath: IndexPath) -> IOU {
        return self.object(at: indexPath) as! IOU
    }
}
