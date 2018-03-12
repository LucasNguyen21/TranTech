//
//  UpdateCartRecordViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 19/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class UpdateCartRecordViewController: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var qtyStepper: UIStepper!
    var qty: String!
    var productName: String!
    var productPrice: String!
    var delegate: LoadCart?
    
    var orderList = [OrderList]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        orderList = []
        //Fetch Data from Coredata
        let fetchRequest = NSFetchRequest<OrderList>(entityName: "OrderList")
        do{
            //Filter Data by ID
            //            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            //            fetchRequest.sortDescriptors = [sortDescriptor]
            self.orderList = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateCartRecordViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        productNameLabel.text = productName
        qtyTextField.text = qty
        qtyStepper.value = Double(qty)!
        imageView.image = UIImage(named: productName)
        if imageView.image == nil {
            updateButton.isEnabled = false
            qtyStepper.isEnabled = false
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func qtyStepperAction(_ sender: UIStepper) {
        sender.stepValue = 1
        sender.minimumValue = 1
        sender.maximumValue = 1000
        qtyTextField.text = String(format: "%.0f", qtyStepper.value)
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        if Double(qtyTextField.text!) == nil {
            
        }
        else {
            if let index = orderList.index(where: { $0.name == productName }) {
                orderList[index].qty = qtyTextField.text!
            }
            
            alertMessage(title: "Success", message: "Update successful")
        }
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "DELETE", message: "Are you sure to delete this record?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            //Delete Record
            if let index = self.orderList.index(where: { $0.name == self.productName }) {
                self.managedObjectContext?.delete(self.orderList[index])
            }
            self.saveContext()
            self.dismiss(animated: true, completion: {
                self.delegate?.loadCart()
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: {
                self.delegate?.loadCart()
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
    
}
