//
//  ShoppingListController.swift
//  Assessment 2 - Shopping List
//
//  Created by Chris Anderson on 11/15/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CoreData

class ShoppingListController {
    
    // MARK: - Properties
    
    static let sharedInstance = ShoppingListController()
    
    // MARK: - SOURCE OF TRUTH
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch. : \(error.localizedDescription)")
        }
    }
    
    let fetchedResultsController: NSFetchedResultsController<ShoppingList> = {
        
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        let isCompleteSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        request.sortDescriptors = [isCompleteSortDescriptor]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    // MARK: - CRUD
    
    func addShoppingList(ShoppingListWithTitle title: String) {
        ShoppingList(title: title, isComplete: false)
        saveToPersistentStore()
    }
    
    func updateShoppingList(shoppingList: ShoppingList, title: String) {
        shoppingList.title = title
        saveToPersistentStore()
    }
    
    func deleteShoppingList(shoppingList: ShoppingList) {
        CoreDataStack.context.delete(shoppingList)
        saveToPersistentStore()
    }
    
    // MARK: - Custom Method
    
    func toggleIsComplete(shoppingList: ShoppingList) {
        shoppingList.isComplete = !shoppingList.isComplete
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Something went wrong trying to save to persistent store : \(error.localizedDescription)")
        }
    }
}
