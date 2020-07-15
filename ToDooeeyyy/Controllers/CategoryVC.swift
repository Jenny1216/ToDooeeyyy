//
//  CategoryVC.swift
//  ToDooeeyyy
//
//  Created by Jinisha Savani on 8/15/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import CoreData
import UIKit
import ChameleonFramework

class CategoryVC: SwipeTableVC  {
    
    var categories: [Category]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoListVC = ToDoListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
    }
    
    // MARK:- Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.colour ?? "") else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListVC
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("Error saving Category\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading data: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoriesToDelete = self.categories?[indexPath.row] {
            context.delete(categoriesToDelete)
            categories?.remove(at: indexPath.row)
        }
    }
    
    //MARK:- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.categories?.append(newCategory)
            self.saveCategory()
            
        })
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
