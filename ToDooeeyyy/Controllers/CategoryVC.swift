//
//  CategoryVC.swift
//  ToDooeeyyy
//
//  Created by Jinisha Savani on 8/15/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {
    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
    }
    
    // MARK:- Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
      
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories entered"
        
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
    
    //MARK:- Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            // what will happen when we press the add button
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
          
        })
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func save(category: Category){
        do {
            try realm.write {
            realm.add(category)
        }
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
        
    }
}
