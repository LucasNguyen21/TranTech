//
//  HardDriverAddOnViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 20/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class HardDriverAddOnViewController: UIViewController {

    @IBOutlet weak var hdd1TNameLabel: UILabel!
    @IBOutlet weak var hdd1TPriceLabel: UILabel!
    @IBOutlet weak var hdd1TQtyTextField: UITextField!
    @IBOutlet weak var hdd1TStepper: UIStepper!
    var hdd1TPrice: String!
    
    @IBOutlet weak var hdd2TNameLabel: UILabel!
    @IBOutlet weak var hdd2TPriceLabel: UILabel!
    @IBOutlet weak var hdd2TQtyTextField: UITextField!
    @IBOutlet weak var hdd2TStepper: UIStepper!
    var hdd2TPrice: String!
    
    @IBOutlet weak var hdd3TNameLabel: UILabel!
    @IBOutlet weak var hdd3TPriceLabel: UILabel!
    @IBOutlet weak var hdd3TQtyTextField: UITextField!
    @IBOutlet weak var hdd3TStepper: UIStepper!
    var hdd3TPrice: String!
    
    @IBOutlet weak var hdd4TNameLabel: UILabel!
    @IBOutlet weak var hdd4TPriceLabel: UILabel!
    @IBOutlet weak var hdd4TQtyTextField: UITextField!
    @IBOutlet weak var hdd4TStepper: UIStepper!
    var hdd4TPrice: String!
    
    @IBOutlet weak var hdd6TNameLabel: UILabel!
    @IBOutlet weak var hdd6TPriceLabel: UILabel!
    @IBOutlet weak var hdd6TQtyTextField: UITextField!
    @IBOutlet weak var hdd6TStepper: UIStepper!
    var hdd6TPrice: String!
    
    @IBOutlet weak var hdd8TNameLabel: UILabel!
    @IBOutlet weak var hdd8TPriceLabel: UILabel!
    @IBOutlet weak var hdd8TQtyTextField: UITextField!
    @IBOutlet weak var hdd8TStepper: UIStepper!
    var hdd8TPrice: String!
    
    var hddList = [productInfo]()
    var orderHddList = [orderRecord]()
    var userType: String!
    
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

        userType = UserDefaults.standard.value(forKey: userTypeStandard) as! String
        orderHddList = []
        loadCart()
        loadHDD()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addToCartAction(_ sender: UIButton) {
        var hdd1TQty: Double = Double(hdd1TQtyTextField.text!)!
        var hdd2TQty: Double = Double(hdd2TQtyTextField.text!)!
        var hdd3TQty: Double = Double(hdd3TQtyTextField.text!)!
        var hdd4TQty: Double = Double(hdd4TQtyTextField.text!)!
        var hdd6TQty: Double = Double(hdd6TQtyTextField.text!)!
        var hdd8TQty: Double = Double(hdd8TQtyTextField.text!)!
        
        //Check and add item to List
        addHDDToList(hddQtyTextField: hdd1TQtyTextField, hddName: "WD1", hddPrice: hdd1TPrice)
        addHDDToList(hddQtyTextField: hdd2TQtyTextField, hddName: "WD2", hddPrice: hdd2TPrice)
        addHDDToList(hddQtyTextField: hdd3TQtyTextField, hddName: "WD3", hddPrice: hdd3TPrice)
        addHDDToList(hddQtyTextField: hdd4TQtyTextField, hddName: "WD4", hddPrice: hdd4TPrice)
        addHDDToList(hddQtyTextField: hdd6TQtyTextField, hddName: "WD6", hddPrice: hdd6TPrice)
        addHDDToList(hddQtyTextField: hdd8TQtyTextField, hddName: "WD8", hddPrice: hdd8TPrice)
        
        for record in orderList {
            if record.name == "WD1"{
                hdd1TQty = hdd1TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD1" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD1" })!)
                        orderHddList.append(orderRecord.init(name: "WD1", code: code, qty: String(format: "%.0f", hdd1TQty), price: hdd1TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
            if record.name == "WD2"{
                hdd2TQty = hdd2TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD2" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD2" })!)
                        orderHddList.append(orderRecord.init(name: "WD2", code: code, qty: String(format: "%.0f", hdd2TQty), price: hdd2TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
            if record.name == "WD3"{
                hdd3TQty = hdd3TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD3" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD3" })!)
                        orderHddList.append(orderRecord.init(name: "WD3", code: code, qty: String(format: "%.0f", hdd3TQty), price: hdd3TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
            if record.name == "WD4"{
                hdd4TQty = hdd4TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD4" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD4" })!)
                        orderHddList.append(orderRecord.init(name: "WD4", code: code, qty: String(format: "%.0f", hdd4TQty), price: hdd4TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
            if record.name == "WD6"{
                hdd6TQty = hdd6TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD6" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD6" })!)
                        orderHddList.append(orderRecord.init(name: "WD6", code: code, qty: String(format: "%.0f", hdd6TQty), price: hdd6TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
            if record.name == "WD8"{
                hdd8TQty = hdd8TQty + Double(record.qty!)!
                for hdd in orderHddList {
                    if hdd.name == "WD8" {
                        let code = hdd.code
                        orderHddList.remove(at: orderHddList.index(where: { $0.name == "WD8" })!)
                        orderHddList.append(orderRecord.init(name: "WD8", code: code, qty: String(format: "%.0f", hdd8TQty), price: hdd8TPrice, subTotal: "", gst: "", total: ""))
                    }
                }
            }
        }
        
        //add list to server data
        for hdd in orderHddList {
            AddHDDOrderToCart(hdd: hdd)
        }
        let alert = UIAlertController(title: "Add HDD To Cart", message: "Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: naviToCollectionViewName, object: nil)
            })
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func AddHDDOrderToCart(hdd: orderRecord){
        if let index = orderList.index(where: { $0.name == hdd.name }) {
            managedObjectContext?.delete(orderList[index])
            saveContext()
        }
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "OrderList", into: managedObjectContext) as? OrderList
        record?.code = hdd.code
        record?.name = hdd.name
        record?.price = hdd.price
        record?.qty = hdd.qty
        saveContext()
        
    }
    
    func addHDDToList(hddQtyTextField: UITextField, hddName: String, hddPrice: String){
        if let qty = Double(hddQtyTextField.text!){
            if qty > 0 {
                for hdd in hddList {
                    if hdd.productName == hddName {
                        orderHddList.append(orderRecord.init(name: hdd.productName, code: hdd.productSpec, qty: hddQtyTextField.text!, price: hddPrice, subTotal: "", gst: "", total: ""))
                        break
                    }
                }
            }
            
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hdd1TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd1TQtyTextField, hddPriceLabel: hdd1TPriceLabel, hddPrice: hdd1TPrice)
    }
    @IBAction func hdd2TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd2TQtyTextField, hddPriceLabel: hdd2TPriceLabel, hddPrice: hdd2TPrice)
    }
    @IBAction func hdd3TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd3TQtyTextField, hddPriceLabel: hdd3TPriceLabel, hddPrice: hdd3TPrice)
    }
    @IBAction func hdd4TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd4TQtyTextField, hddPriceLabel: hdd4TPriceLabel, hddPrice: hdd4TPrice)
    }
    @IBAction func hdd6TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd6TQtyTextField, hddPriceLabel: hdd6TPriceLabel, hddPrice: hdd6TPrice)
    }
    @IBAction func hdd8TStepperAction(_ sender: UIStepper) {
        setupStepperAction(sender: sender, hddQtyTextField: hdd8TQtyTextField, hddPriceLabel: hdd8TPriceLabel, hddPrice: hdd8TPrice)
    }
    
    func setupStepperAction(sender: UIStepper, hddQtyTextField: UITextField, hddPriceLabel: UILabel, hddPrice: String){
        if let price = Double(hddPrice) {
            sender.stepValue = 1
            sender.minimumValue = 0
            sender.maximumValue = 1000
            hddQtyTextField.text = String(format: "%.0f", sender.value)
            let totalPrice = sender.value * price
            hddPriceLabel.text = "+ $" + String(format: "%.2f", totalPrice)
        }
        
    }
    
    //Load HDD List -> asign list to hddList
    func loadHDD(){
        let defaultStore = Firestore.firestore()
        hddList = []
        defaultStore.collection("PRODUCT").document("DEFAULT").collection("ACCESSORIES").document("SURVEILLANCE HDD").collection("SURVEILLANCE HDD").getDocuments(completion: { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let array = document.data() as NSDictionary
                    let pName = document.documentID
                    let pPrice: Double!
                    let pPrice2: Double!
                    let pPrice3: Double!
                    let pDesc: String!
                    let pSpec: String!
                    let pGenDesc: String!
                    let pPriority: String!
                    let pDriver: String!
                    
                    if let price = array.object(forKey: "Price3"){
                        pPrice3 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice3 = 0
                    }
                    if let price = array.object(forKey: "Price2"){
                        pPrice2 = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice2 = 0
                    }
                    
                    if let price = array.object(forKey: "Price"){
                        pPrice = (price as! NSString).doubleValue
                    }
                    else {
                        pPrice = 0
                    }
                    
                    if let desc = array.object(forKey: "Desc"){
                        pDesc = desc as! String
                    }
                    else {
                        pDesc = ""
                    }
                    
                    if let spec = array.object(forKey: "Spec"){
                        pSpec = spec as! String
                    }
                    else {
                        pSpec = ""
                    }
                    
                    if let genDesc = array.object(forKey: "gen_desc"){
                        pGenDesc = genDesc as! String
                    }else {
                        pGenDesc = ""
                    }
                    
                    if let priority = array.object(forKey: "priority"){
                        pPriority = priority as! String
                    }
                    else {
                        pPriority = ""
                    }
                    
                    if let driver = array.object(forKey: "Driver") {
                        pDriver = driver as! String
                    } else {
                        pDriver = ""
                    }
                    
                    if self.userType == "DEFAULT" {
                        self.checkHDD(name: pName, price: 0)
                    } else if self.userType == "TYPE1" {
                        self.checkHDD(name: pName, price: pPrice)
                    }else if self.userType == "TYPE2" {
                        self.checkHDD(name: pName, price: pPrice2)
                    }else if self.userType == "TYPE3" {
                        self.checkHDD(name: pName, price: pPrice3)
                    }else if self.userType == "TYPE4" {
                        self.checkHDD(name: pName, price: 4)
                    }else if self.userType == "TYPE5" {
                        self.checkHDD(name: pName, price: 5)
                    }
                    
                    self.hddList.append(productInfo.init(productName: pName, productDesc: pDesc, productPrice: pPrice, productPriceType2: pPrice2, productPriceType3: pPrice3, productSpec: pSpec, productFenDesc: pGenDesc, productPriority: pPriority, productDriver: pDriver))
                }
            }
        })
    }
    
    func checkHDD(name: String, price: Double){
        if name == "WD1"{
            self.hdd1TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd1TPrice = String(format: "%.2f", price)
        } else if name == "WD2"{
            self.hdd2TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd2TPrice = String(format: "%.2f", price)
        } else if name == "WD3"{
            self.hdd3TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd3TPrice = String(format: "%.2f", price)
        }
        else if name == "WD4"{
            self.hdd4TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd4TPrice = String(format: "%.2f", price)
        }
        else if name == "WD6"{
            self.hdd6TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd6TPrice = String(format: "%.2f", price)
        }
        else if name == "WD8"{
            self.hdd8TPriceLabel.text = "+ $" + String(format: "%.2f", price)
            self.hdd8TPrice = String(format: "%.2f", price)
        }
    }
    
    //Load Cart List -> load into orderList
    func loadCart(){
        view.isUserInteractionEnabled = false
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
        self.view.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
}
