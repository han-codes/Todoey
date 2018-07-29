//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Hannie Kim on 7/25/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    // declare a Realm
    let realm = try! Realm()
    
    // Array of NSObjects
    var categoryArray = [Category]()
    
    // Communicates w/ our persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - TableView Datasource Methods
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // what the cells will display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set label as the categoryArray at indexPath name
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
        self.tableView.reloadData()
    }
    
    // Read data from context
    func loadCategories() {
        // fetch the request
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            // category array will be the fetched request from context
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//        
//        tableView.reloadData()
        
    }
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // the button
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
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
