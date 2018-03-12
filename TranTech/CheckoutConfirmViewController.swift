//
//  CheckoutConfirmViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 2/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAuth
import FirebaseFirestore
import CoreData

protocol LoadCart {
    func emptyCart()
    func loadCart()
    func emptyTextView()
    func alertOrderController(title: String, message: String)
}


class CheckoutConfirmViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var deliverySwitch: UISwitch!
    @IBOutlet weak var NoDeliveryLabel: UILabel!
    @IBOutlet weak var YesDeliveryLabel: UILabel!
    @IBOutlet weak var contactPersonTextField: UITextField!
    @IBOutlet weak var receiverPhoneTextField: UITextField!
    
    
    var orderRecordList = [OrderList]()
    var specialRequestText: String!
    var delegate: LoadCart?
    
    var orderList = [OrderList]()
    var userInfor = [UserInfor]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        userInfor = []
        //Fetch Data from Coredata
        let fetchRequest = NSFetchRequest<UserInfor>(entityName: "UserInfor")
        do{
            //Filter Data by ID
            self.userInfor = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        addressTextField.isHidden = true
        receiverPhoneTextField.isHidden = true
        contactPersonTextField.isHidden = true
        if userInfor.isEmpty == false {
            for user in userInfor {
                if user.email == Auth.auth().currentUser?.email! {
                    nameTextField.text = user.companyName
                    phoneNumberTextField.text = user.phoneNumber
                }
            }
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutConfirmViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutConfirmViewController.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutConfirmViewController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y = -100
                print(keyboardSize)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
                print(keyboardSize)
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status
        self.view.endEditing(true)
    }
    @IBAction func checkoutAction(_ sender: UIButton) {
        if deliverySwitch.isOn {
            if addressTextField.text == "" {
                alertController(title: "Missing Input", message: "Address field must not be empty")
            }
            else if nameTextField.text == "" {
                alertController(title: "Missing Input", message: "Company Name field must not be empty")
            }
            else if phoneNumberTextField.text == ""{
                alertController(title: "Missing Input", message: "Phone field must not be empty")
            }else if  phoneNumberTextField.text!.count > 10 || phoneNumberTextField.text!.count < 8{
                alertController(title: "Wrong Input", message: "Phone number must be in range of 8 - 10")
            }
            else if contactPersonTextField.text == "" {
                alertController(title: "Missing Input", message: "Contact Person Field must not be empty")
            }
            else if receiverPhoneTextField.text == "" {
                alertController(title: "Missing Input", message: "Receiver's Phone Field must not be empty")
            }
            else if  receiverPhoneTextField.text!.count > 10 || receiverPhoneTextField.text!.count < 8{
                alertController(title: "Wrong Input", message: "Receiver 's phone number must be in range of 8 - 10")
            }
            else{
                let alert = UIAlertController(title: "Notice", message: "Order will be sent in a form of an email. Our staff will contact you shortly to process credit card payment", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    let mailComposeVC = self.configureMailController()
                    self.present(mailComposeVC, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if nameTextField.text == "" {
                alertController(title: "Missing input", message: "Name field must not be empty")
            }
            else if phoneNumberTextField.text == "" {
                alertController(title: "Missing input", message: "Phone field must not be empty")
            }
            else if  phoneNumberTextField.text!.count > 10 || phoneNumberTextField.text!.count < 8 {
                alertController(title: "Wrong Input", message: "Phone number must be in range of 8 - 10")
            }
            else{
                let alert = UIAlertController(title: "Notice", message: "Order will be sent in a form of an email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    let mailComposeVC = self.configureMailController()
                    self.present(mailComposeVC, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deliverySwitch(_ sender: UISwitch) {
        if sender.isOn {
            addressTextField.isHidden = false
            contactPersonTextField.isHidden = false
            receiverPhoneTextField.isHidden = false
            NoDeliveryLabel.textColor = UIColor.white
            YesDeliveryLabel.textColor = UIColor.orange
        }
        else{
            addressTextField.isHidden = true
            receiverPhoneTextField.isHidden = true
            contactPersonTextField.isHidden = true
            NoDeliveryLabel.textColor = UIColor.orange
            YesDeliveryLabel.textColor = UIColor.white
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        var content: String = ""
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["orders@trantechsecurity.com.au"])
        mailComposeVC.setSubject("Order Number: \(String(describing: UserDefaults.standard.value(forKey: orderNumberUrl)!))" + " - " + "\(String(describing: (Auth.auth().currentUser?.email)!))")
        content.append("Company Name: " + nameTextField.text! + "\n")
        content.append("Company's Phone: " + phoneNumberTextField.text! + "\n")
        if deliverySwitch.isOn {
            content.append("Delivery: YES\n")
            content.append("Receiver Name: " + contactPersonTextField.text! + "\n")
            content.append("Address: " + addressTextField.text! + "\n")
            content.append("Receiver Phone: " + phoneNumberTextField.text! + "\n")
        }
        else {
            content.append("Delivery: NO\n")
            content.append("Address: None" + "\n")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd-MM-yyyy"
        let dateString = formatter.string(from: Date())
        content.append("Time: " + dateString + "\n\n")
        
        
        
        for i in 0 ..< orderRecordList.count{
            let subTotal = Double(orderRecordList[i].price!)! * Double(orderRecordList[i].qty!)!
            let total = subTotal * 1.1
            content.append(orderRecordList[i].qty! + " | ")
            content.append(orderRecordList[i].code! + " | ")
            content.append(orderRecordList[i].name! + " | ")
            content.append(subTotal.cleanValue + " | " + total.cleanValue + "\n")
        }

        if specialRequestText == nil || specialRequestText == "Write Your Special Request Here"{
            specialRequestText = "None"
        }
        content.append("\n" + "SPECIAL REQUEST: " + specialRequestText)
        
        if content == "" {
            content = "nil"
        }
        mailComposeVC.setMessageBody(content, isHTML: false)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print("SEND EMAIL ERROR: \(String(describing: error))")
        }
        else {
            switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                print("Cancelled Email")
                controller.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break
                
            case MFMailComposeResult.failed.rawValue:
                print("Fail to send Email")
                controller.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break
                
            case MFMailComposeResult.saved.rawValue:
                print("Saved Email")
                controller.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                break
                
            case MFMailComposeResult.sent.rawValue:
                    var orderNumber: Int = Int((UserDefaults.standard.value(forKey: orderNumberUrl) as! String))!
                    orderNumber += 1
                    let orderNumberString: String = String(orderNumber)
                    UserDefaults.standard.set(orderNumberString, forKey: orderNumberUrl)
                    controller.dismiss(animated: true, completion: {
                        self.dismiss(animated: true, completion: {
                            self.delegate?.emptyCart()
                            self.delegate?.loadCart()
                            self.delegate?.emptyTextView()
                            self.delegate?.alertOrderController(title: "Order Successfully", message: "We 've already received your order, we will contact you as soon as possible.")
                            
                        })
                    })
                break
                
            default:
                print("default")
                break
            }
        }
    }
    
    func alertController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
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
