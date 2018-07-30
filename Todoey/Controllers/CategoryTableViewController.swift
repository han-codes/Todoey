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
    var categories: Results<Category>?
    
    // Communicates w/ our persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - TableView Datasource Methods
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories?.count is nil return 1
        return categories?.count ?? 1
    }
    
    // what the cells will display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creates a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Set label as the categories at indexPath name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
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
        self.tableView.reloadData()
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
