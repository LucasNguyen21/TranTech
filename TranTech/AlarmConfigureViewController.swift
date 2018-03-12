//
//  AlarmConfigureViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 26/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class AlarmConfigureViewController: UIViewController, updateSiren, updatePir, updateKeypad {

    @IBOutlet weak var changePIRButton: UIButton!
    @IBOutlet weak var keypadButton: UIButton!
    @IBOutlet weak var kitName: UILabel!
    @IBOutlet weak var pcbQuantitylabel: UILabel!
    @IBOutlet weak var enclosureQtyLabel: UILabel!
    @IBOutlet weak var sirenQtyLabel: UILabel!
    @IBOutlet weak var pirQtyLabel: UILabel!
    @IBOutlet weak var keypadQtyLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    //Kit
    var kitTotalPrice: Double!
    
    //Siren
    var squareQty: Double!
    var slimQty: Double!
    
    var pcbQty: Int!
    var enclosureQty: Int!
    var sirenQty: Int!
    var modelName: String!
    var pirQty: Int!
    var keypadQty: Int!
    
    var pirName: String!
    
    var alarmQty: Int!
    var alarmPrice: String!
    var alarmTotalStdPrice: Double!
    var alarmCode: String!
    var gst: Double!
    var totalOfEverything: Double!
    var totalQty: Int!
    
    var noPirQty: Double!
    var quadPirQty: Double!
    var tritechQty: Double!
    var wirelessQty: Double!
    var noPirPrice0: Double!
    var quadPirPrice0: Double!
    var tritechPirPrice0: Double!
    var wirelessPirPrice0: Double!
    
    
    var alphaQty0: Double = 0
    var fiveTQty0: Double = 0
    var sevenTQty0: Double = 0
    var alphaPrice0: Double = 0
    var fiveTPrice0: Double = 0
    var sevenTPrice0: Double = 0
    
    var orderRecordList = [OrderList]()
    var alarmList = [orderRecord]()
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmList = []
        
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        indicatorView.hidesWhenStopped = true
        
        totalOfEverything = 0
        noPirQty = 0
        quadPirQty = 0
        tritechQty = 0
        wirelessQty = 0
        noPirPrice0 = 0
        quadPirPrice0 = 0
        tritechPirPrice0 = 0
        wirelessPirPrice0 = 0
        squareQty = 0
        
        loadCart()
        
        
        totalPriceLabel.text = "Total: $" + kitTotalPrice.cleanValue + " ex"
        kitName.text = modelName
        pirQtyLabel.text = "\(pirQty!)x \(pirName!)"
        pcbQuantitylabel.text = "\(pcbQty!)x PCB"
        enclosureQtyLabel.text = "\(enclosureQty!)x Enclosure"
        sirenQtyLabel.text = "\(sirenQty!)x Accessories Pack (Slim Siren)"
        keypadQtyLabel.text = "\(keypadQty!)x ICON Keypad"
        
        if modelName == "BOSCH 6000 KIT" || modelName == "BOSCH 6000 WIRELESS KIT" {
            keypadButton.isHidden = true
        }
        
        if modelName == "BOSCH 6000 WIRELESS KIT" || modelName == "BOSCH 3000 WIRELESS KIT" {
            changePIRButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseSirenSegue" {
            let sirenView: SirenChoiceViewController = segue.destination as! SirenChoiceViewController
            sirenView.slimQty = sirenQty
            sirenView.delegate = self
        }
        if segue.identifier == "chooseKeypadSegue" {
            let keypadView: KeypadChoiceViewController = segue.destination as! KeypadChoiceViewController
            keypadView.totalKeypad = sirenQty
            keypadView.delegate = self
        }
        if segue.identifier == "choosePIRSegue" {
            let pirView: PIRChoiceViewController = segue.destination as! PIRChoiceViewController
            pirView.modelName = modelName
            pirView.totalQty = pirQty
            pirView.delegate = self
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        alarmList = []
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartAction(_ sender: UIButton) {
        totalQty = alarmQty
        
        for record in orderRecordList {
            //Add alarm Qty
            if record.name == modelName {
                totalQty = totalQty + Int(record.qty!)!
                if let index = orderRecordList.index(where: { $0.name == modelName }) {
                    managedObjectContext?.delete(orderRecordList[index])
                }
                saveContext()
                loadCart()
            }
            
            //Add Siren Quantity
            addMoreItem(record: record, itemName: (modelName + " Square siren"), itemQty: squareQty, itemPrice: 0)
            //Add PIR
            addMoreItem(record: record, itemName: (modelName + " No PIR"), itemQty: noPirQty, itemPrice: noPirPrice0)

            addMoreItem(record: record, itemName: (modelName + " Quad PIR"), itemQty: quadPirQty, itemPrice: quadPirPrice0)

            addMoreItem(record: record, itemName: (modelName + " TRITECH PIR"), itemQty: tritechQty, itemPrice: tritechPirPrice0)

            addMoreItem(record: record, itemName: (modelName + " STD PIR"), itemQty: wirelessQty, itemPrice: wirelessPirPrice0)
            
            //Add Keypad
            addMoreItem(record: record, itemName: (modelName + " Alpha"), itemQty: alphaQty0, itemPrice: alphaPrice0)

            addMoreItem(record: record, itemName: (modelName + " 5'' Touch"), itemQty: fiveTQty0, itemPrice: fiveTPrice0)

            addMoreItem(record: record, itemName: (modelName + " 7'' Touch"), itemQty: sevenTQty0, itemPrice: sevenTPrice0)
            
        }
        
        alarmTotalStdPrice = Double(totalQty) * Double(alarmPrice)!
        gst = alarmTotalStdPrice * 10/100
        totalOfEverything = alarmTotalStdPrice + gst
        
        
        alarmList.append(orderRecord.init(name: modelName, code: alarmCode, qty: String(totalQty), price: alarmPrice, subTotal: String(format: "%.2f", alarmTotalStdPrice), gst: String(format: "%.2f", gst), total: String(format: "%.2f", totalOfEverything)))
        
        
        for alarm in alarmList {
            let record = NSEntityDescription.insertNewObject(forEntityName: "OrderList", into: managedObjectContext) as? OrderList
            record?.code = alarm.code
            record?.name = alarm.name
            record?.price = alarm.price
            record?.qty = alarm.qty
            saveContext()
        }
        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "1"
        alertControl(title: "Add To Cart", message: "Successful")
    }
    
    func loadCart(){
        indicatorView.startAnimating()
        view.isUserInteractionEnabled = false
        
        orderRecordList = []

        //Fetch Data from Coredata
        let fetchRequest = NSFetchRequest<OrderList>(entityName: "OrderList")
        do{
            //Filter Data by ID
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            self.orderRecordList = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        indicatorView.stopAnimating()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
    }
    
    func alertControl(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: naviToCollectionViewName, object: nil)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateSiren(slimQty: Double, squareQty: Double){
        if squareQty > 0 {
            addItem(itemName: (modelName + " Square siren"), itemQty: squareQty, itemPrice: 0)
            sirenQtyLabel.text = String(format: "%.0f", slimQty) + "x Slim Siren\n" + String(squareQty.cleanValue) + "x Square Siren"
            self.squareQty = squareQty
            self.slimQty = slimQty
        } else {
            removeItem(itemName: (modelName + " Square siren"))
            sirenQtyLabel.text = String(format: "%.0f", slimQty ) + "x Accessories Pack (Slim Siren)"
        }
    }
    
    //////Update PIR
    func updatePir(noPir: Double, quadPir: Double, tritech: Double, wireless: Double, noPirprice: Double, quadPirPrice: Double, tritechPirPrice: Double, wirelessPirPrice: Double) {
        var pirString: String = ""
        if noPir > 0 {
            addItem(itemName: (modelName + " No PIR"), itemQty: noPir, itemPrice: noPirprice)
            pirString += String(format: "%.0f", noPir) + "x No PIR\n"
            noPirQty = noPir
            noPirPrice0 = noPirprice
        } else {
            removeItem(itemName: (modelName + " No PIR"))
        }
        
        if quadPir > 0 {
            addItem(itemName: (modelName + " Quad PIR"), itemQty: quadPir, itemPrice: quadPirPrice)
            pirString += String(format: "%.0f", quadPir) + "x Quad PIR\n"
            quadPirQty = quadPir
            quadPirPrice0 = quadPirPrice
        } else {
            removeItem(itemName: (modelName + " Quad PIR"))
        }
        
        if tritech > 0 {
            addItem(itemName: (modelName + " TRITECH PIR"), itemQty: tritech, itemPrice: tritechPirPrice)
            pirString += String(format: "%.0f", tritech) + "x Tritech PIR\n"
            tritechQty = tritech
            tritechPirPrice0 = tritechPirPrice
        } else {
            removeItem(itemName: (modelName + " TRITECH PIR"))
        }
        
        if wireless > 0 {
            addItem(itemName: (modelName + " STD PIR"), itemQty: wireless, itemPrice: wirelessPirPrice)
            pirString += String(format: "%.0f", wireless) + "x STD PIR\n"
            wirelessQty = wireless
            wirelessPirPrice0 = wirelessPirPrice
        } else {
            removeItem(itemName: modelName + " STD PIR")
        }
        
        if noPir < 1 && quadPir < 1 && tritech < 1 && wireless < 1 {
            pirString += "\(pirQty!)x \(pirName!)"
        }
        updateKitTotalPrice()
        pirQtyLabel.text = pirString
    }
    
    func updateKeypad(alphaQty: Double, fiveTQty: Double, sevenTQty: Double, alphaPrice: Double, fiveTPrice: Double, sevenTPrice: Double){
        var keypadString = ""
        if alphaQty > 0 {
            addItem(itemName: (modelName + " Alpha"), itemQty: alphaQty, itemPrice: alphaPrice)
            keypadString += alphaQty.cleanValue + "x Alpha Keypad\n"
            alphaQty0 = alphaQty
            alphaPrice0 = alphaPrice
        } else {
            removeItem(itemName: (modelName + " Alpha"))
        }
        
        if fiveTQty > 0 {
            addItem(itemName: (modelName + " 5'' Touch"), itemQty: fiveTQty, itemPrice: fiveTPrice)
            keypadString += fiveTQty.cleanValue + "x 5'' Touch Keypad\n"
            fiveTQty0 = fiveTQty
            fiveTPrice0 = fiveTPrice
        } else {
            removeItem(itemName: (modelName + " 5'' Touch"))
        }
        
        if sevenTQty > 0 {
            addItem(itemName: (modelName + " 7'' Touch"), itemQty: sevenTQty, itemPrice: sevenTPrice)
            keypadString += sevenTQty.cleanValue + "x 7'' Touch Keypad\n"
            sevenTQty0 = sevenTQty
            sevenTPrice0 = sevenTPrice
        } else {
            removeItem(itemName: (modelName + " 7'' Touch"))
        }
        
        if alphaQty < 1 && fiveTQty < 1 && sevenTQty < 1 {
            keypadString += "\(keypadQty!)x ICON Keypad"
        }
        updateKitTotalPrice()
        keypadQtyLabel.text = keypadString
    }
    
    func removeItem(itemName: String){
        for item in alarmList {
            if item.name == itemName{
                alarmList.remove(at: alarmList.index(where: { $0.name == itemName })!)
            }
        }
    }
    
    func addItem(itemName: String, itemQty: Double, itemPrice: Double){
        for item in alarmList {
            if item.name == itemName{
                alarmList.remove(at: alarmList.index(where: { $0.name == itemName })!)
            }
        }
        //price not include gst
        //but the total variable hold the gst also
        alarmList.append(orderRecord.init(name: itemName, code: "0", qty: itemQty.cleanValue, price: itemPrice.cleanValue, subTotal: "0", gst: "0", total: "0"))
    }
    
    func addMoreItem(record: OrderList, itemName: String, itemQty: Double, itemPrice: Double){
        if record.name == itemName {
            if let index = alarmList.index(where: { $0.name == itemName }) {
                var totalQty: Double = 0
                totalQty = itemQty + Double(record.qty!)!
                alarmList.remove(at: index)
                alarmList.append(orderRecord.init(name: itemName, code: "0", qty: totalQty.cleanValue, price: itemPrice.cleanValue, subTotal: "0", gst: "0", total: "0"))
                if let index = orderRecordList.index(where: { $0.name == itemName }) {
                    managedObjectContext?.delete(orderRecordList[index])
                }
                saveContext()
            }
        }
    }
    
    func updateKitTotalPrice(){
        var priceToAdd: Double! = 0
        var addedPrice: Double! = 0
        for item in alarmList {
            priceToAdd = priceToAdd + (Double(item.qty)! * Double(item.price)!)
        }
        addedPrice = kitTotalPrice + priceToAdd
        totalPriceLabel.text = "Total: $" + addedPrice.cleanValue + " ex"
    }
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
}
