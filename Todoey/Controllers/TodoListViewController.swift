//
//  ViewController.swift
//  Todoey
//
//  Created by Hannie Kim on 6/29/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // array of item objects
    var itemArray = [Item]()
    
    // when variable is set, load categories
    var selectedCategory : Category? {
        didSet{
            loadItems()            
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // the AppDelegate.swift object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(dataFilePath)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        searchBar.delegate = self
        
//        loadItems()
    }

    //MARK - Tableview Datasource Methods
    
    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // what the cells should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAtIndex")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // When user selects the cell at the specific indexPath
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove item from current item array
//        itemArray.remove(at: indexPath.row)
//        // remove data from permanent store
//        context.delete(itemArray[indexPath.row])
        
        
        // sets the opposite. True becomes False. False becomes True
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()

        // will remove the grey background when a specific row is selected.
        tableView.deselectRow(at: indexPath, animated: true)

    }
 
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // context is the view context of persistentContainer in AppDelegate.swift
            // Getting object of AppDelegate
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false        // default value for done, since it's not an optional in our database
            newItem.parentCategory = self.selectedCategory
            
            // What will happen once user clicks Add Item button on our UIAlert
            self.itemArray.append(newItem)   // will never equal nil
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            // placeholder text for the text field
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            print("Now")
        }
        
        alert.addAction(action)
        
        // display the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // reload the table view
        self.tableView.reloadData()
    }
    
    // Reads item from Item class and fetches it with context
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // requests the query fetch requests
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // filter for our query and add query to the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // sort the data we get back from database in any order we want
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // fetch the result and reloads the data for our view
        loadItems(with: request, predicate: predicate)
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


