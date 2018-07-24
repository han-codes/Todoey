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
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // array of item objects
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // the AppDelegate.swift object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("hello")
//        print(dataFilePath)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        searchBar.delegate = self
        loadItems()
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
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // query the database
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // specify what the query will be
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
//        let sortDescriptr = NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>)
        
//        request.sortDescriptors = [sortDescriptr]
        print(searchBar.text!)
    }
}


