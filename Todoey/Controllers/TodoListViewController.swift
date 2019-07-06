//
//  ViewController.swift
//  Todoey
//
//  Created by User on 27/06/2019.
//  Copyright © 2019 Yulia Gnedykh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var todoItems : Results<Item>?
    var realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        
        
        updateNavBar(withHexCode: colourHex)
        
        
        }
    

    
    override func viewWillDisappear(_ animated: Bool) {
       
        
        updateNavBar(withHexCode: "76D6FF")
        
//        navigationController?.navigationBar.barTintColor = originalColour
//        navigationController?.navigationBar.tintColor = UIColor.flatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.flatWhite() ]
    }
    

    
     //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
        
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
            
            if let navBarColour = UIColor(hexString: colourHexCode) {
                
                navBar.barTintColor = navBarColour
                navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn:navBarColour, isFlat:true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn:navBarColour, isFlat:true)]
                
                searchBar.barTintColor = navBarColour
        
    }
        }
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
        cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
                }
            
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
//                realm.delete(item)
                item.done = !item.done
                }
            } catch{
                print("Error saving done status, \(error)")
        }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem)  {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
            }
                } catch {
                    print("Error saving new items \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems() {
        
        
    }

    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()

    }
        
   
        
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting Item, \(error)")
                
            }
            
        }

    }
    
}


//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
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









