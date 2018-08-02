//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Hannie Kim on 7/25/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    // declare a Realm
    let realm = try! Realm()
    
    // Array of NSObjects
    var categories: Results<Category>?
    
    // Communicates w/ our persistent container
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
    }
    
    // MARK: - TableView Datasource Methods
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    // what the cells will display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as!  SwipeTableViewCell
        
        // Set label as the categories at indexPath name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        // SwipeCellKit has us set delegate of cell
        // When we set a delegate, we'll need to add something to our Class protocol
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // triggers when a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // preps the segue before performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // reference of the destination view controller
        let destinationVC = segue.destination as! TodoListViewController
        
        // accessing the index path of table view
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // Mark: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        // reload the table view
        tableView.reloadData()
    }
    
    // Read data from context
    func loadCategories() {
        // fetch the request
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // the button
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Swipe Cell Delegate Methods
extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    // the required delegate method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
            print(self.categories![indexPath.row].name)
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
                // reload the table to see the delete changes
                tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}




