//
//  ViewController.swift
//  ToDooeeyyy
//
//  Created by Jinisha Savani on 8/12/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    let itemArray = ["item 1", "item 2", "item 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

}

    //MARK- Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
}
    
    
    //MARK- Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(itemArray[indexPath.row])")
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

}


