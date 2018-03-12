//
//  ForgotPasswordViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 18/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func resetPasswordAction(_ sender: UIButton) {
        if emailTextField.text == "" || emailTextField.text == nil {
            alertControl(title: "Empty", message: "Email field is empty")
        }else{
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                if error != nil {
                    print(error!)
                    let errCode = error! as NSError
                    if errCode.code == AuthErrorCode.invalidEmail.rawValue {
                        self.alertControl(title: "Error", message: "The email address is badly formatted")
                    }
                    else if errCode.code == AuthErrorCode.userNotFound.rawValue {
                        self.alertControl(title: "Error", message: "Email is not registered")
                    }
                }else {
                    self.alertControlWithDismiss(title: "Notification", message: "Reset Link will send to your email in a few minutes. Check your email and follow the instruction to reset your password")
                }
            })
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertControl(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertControlWithDismiss(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
