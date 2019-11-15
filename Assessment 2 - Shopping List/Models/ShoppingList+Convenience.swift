//
//  ShoppingList+Convenience.swift
//  Assessment 2 - Shopping List
//
//  Created by Chris Anderson on 11/15/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingList {
    @discardableResult convenience init(title: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.title = title
        self.isComplete = isComplete
    }
}
