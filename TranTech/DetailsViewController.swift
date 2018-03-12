//
//  DetailsViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 17/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreData

class DetailsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var modelName: String!
    var modelImage: String!
    var price: String!
    var desc: String!
    var spec: String!
    var userEmail: String?
    var total: Double?
    var isDriver: String!
    
    var orderList = [OrderList]()
    
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToCollectionView(notification:)), name: naviToCollectionViewName, object: nil)
        //Coredata Managed Object Context
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        
        loadCart()
        
        if isDriver == "alarm" {
            addToCartButton.setTitle("Build KIT", for: .normal)
        }
        
        modelLabel.text = modelName
        imageView.image = UIImage(named: modelName)
        quantityTextField.text = "1"
        if Auth.auth().currentUser != nil {
            if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "DEFAULT"
            {
                priceLabel.text = "$0 ex"
                price = "0"
                total = quantityStepper.value * 0
                totalPrice.text = "$0"
            }
            else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE1" {
                priceLabel.text = "$" + Double(price!)!.cleanValue + " ex"
                let priceNumber = (price! as NSString).doubleValue
                total = quantityStepper.value * priceNumber
                totalPrice.text = "$" + String(format: "%.2f", total!)
            }
            else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE2" {
                priceLabel.text = "$" + Double(price!)!.cleanValue + " ex"
                let priceNumber = (price! as NSString).doubleValue
                total = quantityStepper.value * priceNumber
                totalPrice.text = "$" + String(format: "%.2f", total!)
            }
            else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE3" {
                priceLabel.text = "$" + Double(price!)!.cleanValue + " ex"
                let priceNumber = (price! as NSString).doubleValue
                total = quantityStepper.value * priceNumber
                totalPrice.text = "$" + String(format: "%.2f", total!)
            }
            else {
                priceLabel.text = "$1 ex"
                price = "1"
                total = quantityStepper.value * 1
            }
        }
        else {
            priceLabel.text = ""
            price = "0"
            totalPrice.text = "$0"
        }
        
        specLabel.text = "SKU# \(spec!)"
        quantityTextField.delegate = self
        quantityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let newText = desc.replacingOccurrences(of: "\\n", with: "\n")
        descLabel.text = newText
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addToCartButton.setTitleColor(UIColor.gray, for: .highlighted)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginButton: UIBarButtonItem = UIBarButtonItem(title: "Home",style: .plain,target: self,action: #selector(loginAction))
        self.navigationItem.rightBarButtonItem = loginButton
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func loginAction(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Auth.auth().currentUser != nil {
            quantityStepper.value = (quantityTextField.text! as NSString).doubleValue
            let priceNumber = (price! as NSString).doubleValue
            total = quantityStepper.value * priceNumber
            totalPrice.text = "$" + String(format: "%.2f", total!)
        }
        if quantityTextField.text == "" || quantityTextField.text == nil {
            quantityTextField.text = "0"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        quantityTextField.text = ""
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if Auth.auth().currentUser != nil {
            quantityStepper.value = (quantityTextField.text! as NSString).doubleValue
            let priceNumber = (price! as NSString).doubleValue
            total = quantityStepper.value * priceNumber
            totalPrice.text = "$" + String(format: "%.2f", total!)
        }
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        if Double(quantityTextField.text!) != nil {
            var totalQty: Double = Double(quantityTextField.text!)!
            
            //Delete record if existing
            for record in orderList {
                if record.name == modelName {
                    totalQty = Double(record.qty!)! + Double(quantityTextField.text!)!
                    if let index = orderList.index(where: { $0.name == modelName }) {
                        managedObjectContext?.delete(orderList[index])
                    }
                    saveContext()
                }
            }
            if isDriver == "1"{
                if let user = Auth.auth().currentUser{
                    if self.quantityTextField.text != "0" && self.quantityTextField.text != "" && self.quantityTextField.text != nil && self.total != nil {
                        self.userEmail = user.email
                        
                        //Add new record with new quantity
                        let record = NSEntityDescription.insertNewObject(forEntityName: "OrderList", into: managedObjectContext) as? OrderList
                        record?.code = spec
                        record?.name = modelName
                        record?.price = price
                        record?.qty = totalQty.cleanValue
                        saveContext()
                        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "1"
                        self.alertBuyHDD(title: "Add to Cart Successfully", message: "Do you want to buy HDD?")
                    }
                    else {
                        self.noItemAlert()
                    }
                }
                else {
                    self.userEmail = ""
                    self.needLoginAlertControl()
                }
            } else if isDriver == "alarm" {
                //If alarm, show configure view
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let hardDriverViewController =  storyBoard.instantiateViewController(withIdentifier: "AlarmConfigureSID") as! AlarmConfigureViewController
                //model Name
                hardDriverViewController.modelName = modelName
                hardDriverViewController.kitTotalPrice = Double(quantityTextField.text!)! * Double(price!)!
                //PIR
                if modelName == "BOSCH 3000 KIT" || modelName == "BOSCH 6000 KIT"{
                    hardDriverViewController.pirQty = 3 * Int(quantityTextField.text!)!
                } else {
                    hardDriverViewController.pirQty = 2 * Int(quantityTextField.text!)!
                }
                if modelName == "BOSCH 3000 WIRELESS KIT" || modelName == "BOSCH 6000 WIRELESS KIT"{
                    hardDriverViewController.pirName = "Wireless PIR"
                } else {
                    hardDriverViewController.pirName = "Blueline G2 PIR"
                }
                
                //siren
                hardDriverViewController.sirenQty = 1 * Int(quantityTextField.text!)!
                
                //pcb
                hardDriverViewController.pcbQty = 1 * Int(quantityTextField.text!)!
                
                //enclosure
                hardDriverViewController.enclosureQty = 1 * Int(quantityTextField.text!)!
                
                //keypad
                hardDriverViewController.keypadQty = 1 * Int(quantityTextField.text!)!
                
                //Price
                hardDriverViewController.alarmPrice = price
                
                //Alarm Qty
                hardDriverViewController.alarmQty = Int(quantityTextField.text!)!
                
                //Alarm Code
                hardDriverViewController.alarmCode = spec
                
                self.present(hardDriverViewController, animated: true, completion: nil)
                
            } else {
                //////////////////
                if let user = Auth.auth().currentUser{
                    print(user.email!)
                    if quantityTextField.text != "0" && quantityTextField.text != "" && quantityTextField.text != nil && total != nil {
                        
                        //Add new record with new quantity
                        let record = NSEntityDescription.insertNewObject(forEntityName: "OrderList", into: managedObjectContext) as? OrderList
                        record?.code = spec
                        record?.name = modelName
                        record?.price = price
                        record?.qty = totalQty.cleanValue
                        saveContext()
                        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "1"
                        alertAddSuccess()
                    }
                    else {
                        noItemAlert()
                    }
                }
                else {
                    userEmail = ""
                    needLoginAlertControl()
                }
            }
        } else {
            alertControl(title: "Wrong Input", message: "Quantity Text Field must be a number")
        }
        
    }
    @IBAction func addQuantity(_ sender: UIStepper) {
        if Auth.auth().currentUser != nil {
            sender.stepValue = 1
            sender.minimumValue = 0
            sender.maximumValue = 1000
            quantityTextField.text = String(format: "%.0f", sender.value)
            let priceNumber = (price! as NSString).doubleValue
            total = sender.value * priceNumber
            totalPrice.text = "$" + String(format: "%.2f", total!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func needLoginAlertControl(){
        let alert = UIAlertController(title: "Login is Required!", message: "Log in to make transaction", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func noItemAlert(){
        let alert = UIAlertController(title: "ITEM QUANTITY", message: "Quantity of item is 0. Pls add it", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func alertControl(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.loadCart()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertAddSuccess(){
        let alert = UIAlertController(title: "Successful", message: "Add to Cart successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.loadCart()
            var productionView = self.navigationController?.viewControllers
            productionView?.removeLast(1)
            self.navigationController?.setViewControllers(productionView!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertBuyHDD(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.loadCart()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let hardDriverViewController =  storyBoard.instantiateViewController(withIdentifier: "HardDriverAddOnSID") as! HardDriverAddOnViewController
            self.present(hardDriverViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.loadCart()
            var productionView = self.navigationController?.viewControllers
            productionView?.removeLast(1)
            self.navigationController?.setViewControllers(productionView!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
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
        
        if orderList.isEmpty == false {
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "1"
        } else {
            self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
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
    
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func naviToCollectionView(notification: NSNotification){
        var productionView = self.navigationController?.viewControllers
        productionView?.removeLast(1)
        self.navigationController?.setViewControllers(productionView!, animated: true)
    }
}
