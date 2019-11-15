//
//  ShoppingListTableViewController.swift
//  Assessment 2 - Shopping List
//
//  Created by Chris Anderson on 11/15/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingListController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addListItemButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add a item:", message: "Please enter a new shopping list item", preferredStyle: .alert)
        let addItemButtonAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let newListTitle = alertController.textFields?.first?.text, !newListTitle.isEmpty else { return }
            ShoppingListController.sharedInstance.addShoppingList(ShoppingListWithTitle: newListTitle)
        })
        let cancelItemButtonAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (_) in }
        alertController.addAction(addItemButtonAction)
        alertController.addAction(cancelItemButtonAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingListController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ShoppingListController.sharedInstance.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Need" : "Finished"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }
        
        let shoppingList = ShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.updateViews(with: shoppingList)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shoppingList = ShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ShoppingListController.sharedInstance.deleteShoppingList(shoppingList: shoppingList)
        }
    }
}

extension ShoppingListTableViewController: ShoppingListCellDelegate {
    func itemCompletedButtonTapped(_ sender: ShoppingListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let shoppingList = ShoppingListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ShoppingListController.sharedInstance.toggleIsComplete(shoppingList: shoppingList)
        sender.updateViews(with: shoppingList)
    }
}


// MARK: - Fetched Results Controller Delegate

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
            
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
