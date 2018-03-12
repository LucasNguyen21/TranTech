//
//  UpdateAccountViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 19/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreData

class UpdateAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var residentialAddressTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var abnCodeTextField: UITextField!
    @IBOutlet weak var tradingAddressTextField: UITextField!
    @IBOutlet weak var natureOfBusinessTextField: UITextField!
    
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
        if let user = Auth.auth().currentUser {
            userInfor = []
            //Fetch Data from Coredata
            let fetchRequest = NSFetchRequest<UserInfor>(entityName: "UserInfor")
            do{
                //Filter Data by ID
                let sortDescriptor = NSSortDescriptor(key: "email", ascending: true)
                fetchRequest.predicate = NSPredicate(format: "email == %@", user.email!)
                fetchRequest.sortDescriptors = [sortDescriptor]
                self.userInfor = try self.managedObjectContext.fetch(fetchRequest)
            }
            catch{
                let fetchError = error as NSError
                print(fetchError)
            }
            for userinfor in userInfor {
                if userinfor.email == user.email! {
                    firstNameTextField.text = userinfor.firstName
                    surNameTextField.text = userinfor.surName
                    residentialAddressTextField.text = userinfor.residentialAddress
                    telephoneTextField.text = userinfor.phoneNumber
                    companyNameTextField.text = userinfor.companyName
                    abnCodeTextField.text = userinfor.abnCode
                    tradingAddressTextField.text = userinfor.tradingAddress
                    natureOfBusinessTextField.text = userinfor.natureOfBusiness
                }
            }
        }
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateAccountViewController.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateAccountViewController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if abnCodeTextField.isEditing == true || tradingAddressTextField.isEditing == true || natureOfBusinessTextField.isEditing == true || companyNameTextField.isEditing == true || telephoneTextField.isEditing == true{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height - 70
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if let user = Auth.auth().currentUser {
            if (firstNameTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "First Name Field must not empty")
            }
            else if (surNameTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Surname Field must not empty")
            }
            else if (residentialAddressTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Residential Address Field must not empty")
            }
            else if (telephoneTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Telephone number Field must not empty")
            }
            else if (companyNameTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Company Name Field must not empty")
            }
            else if (abnCodeTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "ABN/ACN Field must not empty")
            }
            else if (abnCodeTextField.text!.count > 11 || abnCodeTextField.text!.count < 9){
                checkInputAlert(title: "Wrong Input", message: "ABN/ACN must be in range of 9-11 characters")
            }
            else if (tradingAddressTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Trading Address Field must not empty")
            }
            else if (natureOfBusinessTextField.text! == ""){
                checkInputAlert(title: "Missing Input", message: "Nature of business Field must not empty")
            } else {
                if let index = userInfor.index(where: { $0.email == user.email! }) {
                    userInfor[index].firstName = self.firstNameTextField.text!
                    userInfor[index].surName = self.surNameTextField.text!
                    userInfor[index].residentialAddress = self.residentialAddressTextField.text!
                    userInfor[index].phoneNumber = self.telephoneTextField.text!
                    userInfor[index].companyName = self.companyNameTextField.text!
                    userInfor[index].abnCode = self.abnCodeTextField.text!
                    userInfor[index].tradingAddress = self.tradingAddressTextField.text!
                    userInfor[index].natureOfBusiness = self.natureOfBusinessTextField.text!
                    saveContext()
                }

                let defaultStore = Firestore.firestore()
                defaultStore.collection("UserInfor").document(user.email!).setData([
                    "FirstName" : self.firstNameTextField.text!,
                    "Surname" : self.surNameTextField.text!,
                    "ResidentialAddress" : self.residentialAddressTextField.text!,
                    "PhoneNumber" : self.telephoneTextField.text!,
                    "CompanyName" : self.companyNameTextField.text!,
                    "ABNCode" : self.abnCodeTextField.text!,
                    "TradingAddress" : self.tradingAddressTextField.text!,
                    "NatureOfBusiness" : self.natureOfBusinessTextField.text!,
                    ],options: SetOptions.merge())
                alertMessage(title: "Success", message: "Update successful")
            }
        }
    }
    
    func checkInputAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }

}
