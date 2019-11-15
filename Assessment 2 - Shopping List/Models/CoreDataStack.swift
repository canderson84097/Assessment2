//
//  CoreDataStack.swift
//  Assessment 2 - Shopping List
//
//  Created by Chris Anderson on 11/15/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Assessment 2 - Shopping List")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) :: \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
}
