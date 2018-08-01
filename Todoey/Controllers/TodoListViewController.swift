//
//  ViewController.swift
//  Todoey
//
//  Created by Hannie Kim on 6/29/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // array of item objects
    var todoItems: Results<Item>?
    
    // new instance of Realm
    let realm = try! Realm()
    
    // when variable is set, load categories
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // the path for realm file
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
//        searchBar.delegate = self
        
//        loadItems()
    }

    //MARK - Tableview Datasource Methods
    
    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // what the cells should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAtIndex")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // Ternary operator
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // When user selects the cell at the specific indexPath
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                  item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()

        // will remove the grey background when a specific row is selected.
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        // Create Item object
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            // call datasource methods again
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            // placeholder text for the text field
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        // display the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    // Reads item from Item class and fetches it with context
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // requests the query and filters it. sort by title and ascending
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    // when text is changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // when there is no text in the saerch bar
        if searchBar.text?.count == 0 {
            loadItems()     // fetches all items in our persistent store

            // to dismiss keyboard and cursor on Main thread asynchronously
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
}


