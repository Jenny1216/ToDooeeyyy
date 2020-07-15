//
//  ViewController.swift
//  ToDooeeyyy
//
//  Created by Jinisha Savani on 8/12/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import CoreData
import UIKit
import ChameleonFramework

class ToDoListVC: SwipeTableVC {
    
    var itemArray: [Item]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
            }
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.backgroundColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                searchBar.barTintColor = navBarColour
            }
        }
    }
    
    //MARK- Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let colour = UIColor(hexString: selectedCategory!.colour!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK- Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            item.done = !item.done
            saveItems()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoeeyy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray?.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemsToDelete = self.itemArray?[indexPath.row] {
            context.delete(itemsToDelete)
            itemArray?.remove(at: indexPath.row)
        }
    }
}

extension ToDoListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
