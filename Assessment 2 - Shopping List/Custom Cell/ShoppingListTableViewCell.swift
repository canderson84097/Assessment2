//
//  ShoppingListTableViewCell.swift
//  Assessment 2 - Shopping List
//
//  Created by Chris Anderson on 11/15/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

protocol ShoppingListCellDelegate: class {
    func itemCompletedButtonTapped(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: ShoppingListTableViewController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var shoppingListTitle: UILabel!
    @IBOutlet weak var shoppingListCompleteButton: UIButton!
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        delegate?.itemCompletedButtonTapped(self)
    }
    
    func updateViews(with shoppingList: ShoppingList) {
        shoppingListTitle.text = shoppingList.title
        if !shoppingList.isComplete {
            shoppingListCompleteButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        } else {
            shoppingListCompleteButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        }
    }
    
}
