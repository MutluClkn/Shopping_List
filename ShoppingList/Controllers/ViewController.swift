//
//  ViewController.swift
//  ShoppingList
//
//  Created by Mutlu Çalkan on 21.04.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var selectedProduct = ""
    var selectedID : UUID?
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationBar()
        fetchData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Customize navigation bar
    func navigationBar(){
        navigationItem.title = "Shopping List"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)!]
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidPressed))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = .darkText
    }
    
    @objc func addButtonDidPressed(){
        selectedProduct = ""
        DispatchQueue.main.async {
            let vc = AddNewProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.navigationBar.tintColor = .darkText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
    
    // Fetching datas from coredata
    @objc func fetchData(){
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String{
                        nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }
                }
                tableView.reloadData()
            }
            
        }catch {
            print("Error!")
        }
        
    }

    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell()}
        cell.label.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let vc = ProductDetailViewController()
            self.selectedID = self.idArray[indexPath.row]
            self.selectedProduct = self.nameArray[indexPath.row]
            vc.selectedProductName = self.selectedProduct
            vc.selectedProductUUID = self.selectedID
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.navigationBar.tintColor = .darkText
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
            fetchRequest.returnsObjectsAsFaults = false
            let uuidString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do{
                                    try context.save()
                                }catch{
                                    print("Error!")
                                }
                                break
                            }
                        }
                    }
                }
                
                
                
            }catch{
                print("Error!")
            }
            
        }
            
    }

}

