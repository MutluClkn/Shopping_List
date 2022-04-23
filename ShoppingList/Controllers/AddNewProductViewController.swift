//
//  AddNewProductViewController.swift
//  ShoppingList
//
//  Created by Mutlu Çalkan on 21.04.2022.
//

import UIKit
import SnapKit
import CoreData

class AddNewProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let image : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "addPhoto")
        return image
    }()
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Product Name"
        tf.font = .systemFont(ofSize: 18, weight: .regular)
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    let sizeTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Product Size"
        tf.font = .systemFont(ofSize: 18, weight: .regular)
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    let priceTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Price"
        tf.font = .systemFont(ofSize: 18, weight: .regular)
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkText
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(image)
        view.addSubview(nameTextField)
        view.addSubview(sizeTextField)
        view.addSubview(priceTextField)
        view.addSubview(saveButton)
        
        constraints()
        
        closeKeyboard()
        chooseImage()
    }
    
    // Save button pressed
    @objc func buttonDidPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(nameTextField.text ?? "", forKey: "name")
        shopping.setValue(sizeTextField.text ?? "", forKey: "size")
        if let price = Int(priceTextField.text!) {
            shopping.setValue(price, forKey: "price")
        }
        shopping.setValue(UUID(), forKey: "id")
        
        let data = image.image?.jpegData(compressionQuality: 0.5)
        shopping.setValue(data, forKey: "image")
        
        do{
            try context.save()
            print("saved")
        }catch{
            print("Error!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func closeKeyboard(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardPressed))
        view.addGestureRecognizer(gestureRecognizer)
    }
    func chooseImage(){
        image.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        view.addGestureRecognizer(imageGestureRecognizer)
    }
    // Close keyboard by pressing screen
    @objc func closeKeyboardPressed(){
        view.endEditing(true)
    }
    // Pressing on image to add one
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // Choose an image from library and finish picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func constraints() {
        image.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            make.height.equalTo(280)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(image.snp_bottomMargin).offset(35)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            make.height.equalTo(40)
        }
        sizeTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp_bottomMargin).offset(20)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            make.height.equalTo(40)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(sizeTextField.snp_bottomMargin).offset(20)
            make.left.equalTo(view.snp_leftMargin).offset(25)
            make.right.equalTo(view.snp_rightMargin).offset(-25)
            make.height.equalTo(40)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp_bottomMargin).offset(35)
            make.centerXWithinMargins.equalTo(view.snp_centerXWithinMargins)
            make.height.equalTo(45)
            make.width.equalTo(100)
        }
    }
}
