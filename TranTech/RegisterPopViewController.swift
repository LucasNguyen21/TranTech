//
//  RegisterPopViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 5/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import NotificationCenter
import CoreData

class RegisterPopViewController: UIViewController{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var residentialAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var abnCodeTextField: UITextField!
    @IBOutlet weak var tradingAddressTextField: UITextField!
    @IBOutlet weak var natureOfBusinessTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterPopViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPopViewController.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPopViewController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 70
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
    
    @IBAction func registerButton(_ sender: UIButton) {
        if (emailTextField.text! == "" || passwordTextField.text! == "" || rePasswordTextField.text! == ""){
            checkInputAlert(title: "Missing Input", message: "Email and Password Field must not empty")
        }
        else if (passwordTextField.text! != rePasswordTextField.text!) {
            checkInputAlert(title: "Wrong Input", message: "Password Fields are not the same")
        }
        else if (firstNameTextField.text! == ""){
            checkInputAlert(title: "Missing Input", message: "First Name Field must not empty")
        }
        else if (surnameTextField.text! == ""){
            checkInputAlert(title: "Missing Input", message: "Surname Field must not empty")
        }
        else if (residentialAddressTextField.text! == ""){
            checkInputAlert(title: "Missing Input", message: "Residential Address Field must not empty")
        }
        else if (phoneNumberTextField.text! == ""){
            checkInputAlert(title: "Missing Input", message: "Telephone number Field must not empty")
        }
        else if (companyName.text! == ""){
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
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    let errCode = error! as NSError
                    if errCode.code == AuthErrorCode.invalidEmail.rawValue {
                        self.registerAuthentication(message: "Invalid Email")
                    }
                    else if (errCode.code == AuthErrorCode.emailAlreadyInUse.rawValue){
                        self.registerAuthentication(message: "Email has already been registerd")
                    }
                    else if (errCode.code == AuthErrorCode.weakPassword.rawValue){
                        self.registerAuthentication(message: "Password should be at least 6 characters long or more")
                    }
                    print(errCode)
                }
                else{
                    
                    let userRecord = NSEntityDescription.insertNewObject(forEntityName: "UserInfor", into: self.managedObjectContext) as? UserInfor
                    userRecord?.firstName = self.firstNameTextField.text!
                    userRecord?.surName = self.surnameTextField.text!
                    userRecord?.residentialAddress = self.residentialAddressTextField.text!
                    userRecord?.phoneNumber = self.phoneNumberTextField.text!
                    userRecord?.companyName = self.companyName.text!
                    userRecord?.abnCode = self.abnCodeTextField.text!
                    userRecord?.tradingAddress = self.tradingAddressTextField.text!
                    userRecord?.natureOfBusiness = self.natureOfBusinessTextField.text!
                    userRecord?.email = self.emailTextField.text!
                    self.saveContext()
                    
                    if let user = Auth.auth().currentUser {
                        if !user.isEmailVerified{
                            print("not verify yet")
                            let defaultStore = Firestore.firestore()
                            defaultStore.collection("UserInfor").document(self.emailTextField.text!).setData([
                                "FirstName" : self.firstNameTextField.text!,
                                "Surname" : self.surnameTextField.text!,
                                "ResidentialAddress" : self.residentialAddressTextField.text!,
                                "PhoneNumber" : self.phoneNumberTextField.text!,
                                "CompanyName" : self.companyName.text!,
                                "ABNCode" : self.abnCodeTextField.text!,
                                "TradingAddress" : self.tradingAddressTextField.text!,
                                "NatureOfBusiness" : self.natureOfBusinessTextField.text!,
                                "RewardPoints" : "0"
                                ])
                            user.sendEmailVerification(completion: { (error) in
                                self.emailVerificationAlert(title: "Verification Email Notification", message: "A verification code will be sent to Email \(self.emailTextField.text!) within 30 mins. Pls verify before logging in. Note: Contact us if you can't see the price of products.")
                            })
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                print("Sign out firebase")
                            } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                            }
                        }
                        else {
                            print("Done verification")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelRegister(_ sender: UIButton) {
        dismiss(animated: false) {
        }
    }
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
    
    func emailVerificationAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func registerAuthentication(message: String){
        let alert = UIAlertController(title: "Register Fail!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInputAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
