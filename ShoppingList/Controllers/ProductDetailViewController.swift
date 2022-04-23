//
//  ProductDetailViewController.swift
//  ShoppingList
//
//  Created by Mutlu Çalkan on 21.04.2022.
//

import UIKit
import SnapKit
import CoreData

class ProductDetailViewController: UIViewController {
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    let sizeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    
    var selectedProductName = ""
    var selectedProductUUID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(sizeLabel)
        view.addSubview(priceLabel)
        
        productSelection()
        constraints()
    }
    
    
    func productSelection(){
        if selectedProductName != "" {
            // Show selected product's info from core data
            if let uuidString = selectedProductUUID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "name") as? String{
                                nameLabel.text = "Product: \(name)"
                            }
                            if let size = result.value(forKey: "size") as? String {
                                sizeLabel.text = "Size: \(size)"
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                priceLabel.text = "$\(String(price))"
                            }
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                self.imageView.image = image
                            }
                        }
                        
                    }
                }catch{
                    print("Error!")
                }
                
                
            }
        }
        else {
            nameLabel.text = ""
            sizeLabel.text = ""
            priceLabel.text = ""
        }
    }
    
    
    func constraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            make.height.equalTo(280)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(30)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp_bottomMargin).offset(30)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            
        }
}
}
