//
//  LoginTabViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 4/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import CoreData

class LoginTabViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var editAccountButton: UIBarButtonItem!
    @IBOutlet var logOutButton: UIBarButtonItem!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    var userEmail: String!
    var userEmailFireBase: String?
    var managedObjectContext: NSManagedObjectContext!
    var userInfor = [UserInfor]()
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    let loginDispatchGroup = DispatchGroup()
    
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
            self.userInfor = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
        updateUserInfor()
        refreshView.isHidden = true
        refreshIndicator.hidesWhenStopped = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginTabViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let buttonText = NSAttributedString(string: "FaceBook Login")
        fbLoginButton.setAttributedTitle(buttonText, for: .normal)
        fbLoginButton.readPermissions = ["email", "public_profile", "user_friends"]
        print("\(FBSDKAccessToken.current())")
        fbLoginButton.delegate = self
        ///HIDDEN FACEBOOK LOGIN
        fbLoginButton.isHidden = true
        
        indicator.hidesWhenStopped = true
        
        welcomeLabel.layer.masksToBounds = true
        welcomeLabel.layer.cornerRadius = welcomeLabel.frame.height/3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Auth.auth().currentUser != nil {
            loginView.isHidden = true
            userView.isHidden = false
            indicatorView.isHidden = true
            logOutButton.isEnabled = true
            editAccountButton.isEnabled = true
        } else {
            logOutButton.isEnabled = false
            editAccountButton.isEnabled = false
            loginView.isHidden = false
            userView.isHidden = true
            indicatorView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userInfor.isEmpty == false {
            for user in userInfor {
                if user.email == Auth.auth().currentUser?.email! {
                    welcomeLabel.text = user.companyName
                }
            }
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPasswordViewController: ForgotPasswordViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordSBID") as! ForgotPasswordViewController
        self.present(forgotPasswordViewController, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController =  storyBoard.instantiateViewController(withIdentifier: registerPopViewControllerSID) as! RegisterPopViewController
        self.present(registerViewController, animated: true, completion: nil)
    }
    

    
    //EMAIL LOGIN
    @IBAction func loginbuttonAction(_ sender: UIButton) {
        dismissKeyboard()
        
        if usernameTextField.text == "" || passwordTextField.text == ""{
            checkInputAlert(title: "Missing Input!", message: "Email and Password Field must not empty")
        }
        else {
            firebaseEmailLoggin()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //FIREBASE
    func firebaseEmailLoggin(){
        indicatorView.isHidden = false
        loginView.isHidden = true
        indicator.startAnimating()
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let errCode = error! as NSError
                print("Firebase: Logged in error: \(error!)")
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.loginView.isHidden = false
                
                if errCode.code == AuthErrorCode.wrongPassword.rawValue {
                    self.loginAuthentication(message: "Password is incorrect")
                }
                else if errCode.code == AuthErrorCode.userDisabled.rawValue {
                    self.loginAuthentication(message: "Account is disable")
                }
                else if errCode.code == AuthErrorCode.invalidEmail.rawValue {
                    self.loginAuthentication(message: "Invalid Email")
                }
                else if errCode.code == 17011 {
                    self.loginAuthentication(message: "Email haven't been registerd")
                }
                return
            }else{
                if let user = Auth.auth().currentUser {
                    if !user.isEmailVerified{
                        print("not verify yet")
                        self.verifyEmailAlert()
                        self.indicator.stopAnimating()
                        self.indicatorView.isHidden = true
                        self.loginView.isHidden = false
                    }
                    else {
                        self.userEmail = user.email
                        self.getUserType()
                        self.loginDispatchGroup.notify(queue: DispatchQueue.main) {
                            self.updateUserInfor()
                            print("FireBase: Logged in with email")
                            UserDefaults.standard.set(true, forKey: isLoggedinUrl)
                            self.indicator.stopAnimating()
                            self.indicatorView.isHidden = true
                            self.loginView.isHidden = true
                            self.userView.isHidden = false
                            self.logOutButton.isEnabled = false
                            self.editAccountButton.isEnabled = false
                            self.tabBarController?.selectedIndex = 0
                            print("finish login queue")
                        }
                    }
                }
            }
        }
    }
    
    func updateUserInfor(){
        if let user = Auth.auth().currentUser{
            userEmailFireBase = user.email
            getUserInformationFromFirebase()
        }
    }
    
    func getUserInformationFromFirebase(){
        refreshView.isHidden = false
        refreshIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let defaultStore = Firestore.firestore()
        let docRef = defaultStore.collection("UserInfor").document(userEmailFireBase!)
        
        docRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                var rewardPoints:String = ""
                var abnCode:String = ""
                var companyName:String = ""
                var firstName:String = ""
                var natureOfBusiness:String = ""
                var phoneNumber:String = ""
                var residentialAddress:String = ""
                var surName:String = ""
                var tradingAddress:String = ""
                
                let array = snapshot.data() as NSDictionary
                
                if array.object(forKey: "ABNCode") != nil {
                    abnCode = array.object(forKey: "ABNCode") as! NSString as String
                }
                
                if array.object(forKey: "CompanyName") != nil {
                    self.welcomeLabel.text = array.object(forKey: "CompanyName") as! NSString as String
                    companyName = array.object(forKey: "CompanyName") as! NSString as String
                }
                
                if array.object(forKey: "FirstName") != nil {
                    firstName = array.object(forKey: "FirstName") as! NSString as String
                }
                
                if array.object(forKey: "NatureOfBusiness") != nil {
                    natureOfBusiness = array.object(forKey: "NatureOfBusiness") as! NSString as String
                }
                
                if array.object(forKey: "PhoneNumber") != nil {
                    phoneNumber = array.object(forKey: "PhoneNumber") as! NSString as String
                }
                
                if array.object(forKey: "ResidentialAddress") != nil {
                    residentialAddress = array.object(forKey: "ResidentialAddress") as! NSString as String
                }
                
                if array.object(forKey: "Surname") != nil {
                    surName = array.object(forKey: "Surname") as! NSString as String
                }
                
                if array.object(forKey: "TradingAddress") != nil {
                    tradingAddress = array.object(forKey: "TradingAddress") as! NSString as String
                }
                
                if array.object(forKey: "RewardPoints") != nil {
                    rewardPoints = array.object(forKey: "RewardPoints") as! NSString as String
                    self.rewardLabel.text = "\(rewardPoints)"
                }
                else {
                    self.rewardLabel.text = "0"
                }

                
                if let index = self.userInfor.index(where: { $0.email == Auth.auth().currentUser?.email! }) {
                    self.userInfor[index].abnCode = abnCode
                    self.userInfor[index].companyName = companyName
                    self.userInfor[index].firstName = firstName
                    self.userInfor[index].natureOfBusiness = natureOfBusiness
                    self.userInfor[index].phoneNumber = phoneNumber
                    self.userInfor[index].residentialAddress = residentialAddress
                    self.userInfor[index].surName = surName
                    self.userInfor[index].tradingAddress = tradingAddress
                }
                self.saveContext()
                
                self.view.isUserInteractionEnabled = true
                self.refreshView.isHidden = true
                self.refreshIndicator.stopAnimating()
            } else {
                print("Document does not exist")
                self.view.isUserInteractionEnabled = true
                self.refreshView.isHidden = true
                self.refreshIndicator.stopAnimating()
            }
            
        }
    }
    
    func verifyEmailAlert(){
        let alert = UIAlertController(title: "Login Failed", message: "Your email hasn't been verified. Pls verify before logging in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "Send another verification", style: UIAlertActionStyle.default, handler: { (action) in
            let user = Auth.auth().currentUser
            user?.sendEmailVerification(completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //FACEBOOK LOGOUT
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        UserDefaults.standard.set(false, forKey: isLoggedinUrl)
        self.loginView.isHidden = false
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Sign out firebase")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("FaceBook: Logout")
    }
    
    //FACEBOOK LOGIN
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        else if result.isCancelled == true{
            print("Cancel Login")
        }else {
            
            if result.grantedPermissions.contains("email")
            {
                self.firebaseFaceBookLoggin()
                UserDefaults.standard.setValue(true, forKey: isLoggedinUrl)
                print("Done Button Login")
            }
            else {
                alertControl()
            }
        }
    }
    
    
    //FACEBOOK
    func firebaseFaceBookLoggin(){
        let accessToken = FBSDKAccessToken.current()
        if accessToken != nil{
            let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
            
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error != nil {
                    let errCode = error! as NSError
                    print("Firebase: Logged in error")
                    self.indicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.loginView.isHidden = true
                    
                    if errCode.code == 17012 {
                        self.loginAuthentication(message: "This email address is already registered to a TranTech account. If this is your account, and you wish to use this provider to sign in, please sign into your account using your regular method")
                        self.loginView.isHidden = false
                        let fbManager = FBSDKLoginManager()
                        fbManager.logOut()
                    }
                    print(error!)
                    return
                }
                else{
                    print("Hidden View?")
                    self.indicatorView.isHidden = false
                    self.loginView.isHidden = true
                    self.indicator.startAnimating()
                    print("Start FB Login")
                    self.userEmail = user?.email
                    self.getUserType()
                    self.loginDispatchGroup.notify(queue: DispatchQueue.main, execute: {
                        print("FireBase: Logged in")
                        self.updateUserInfor()
                        self.loginView.isHidden = true
                        self.userView.isHidden = false
                        self.logOutButton.isEnabled = false
                        self.editAccountButton.isEnabled = false
                        self.indicator.stopAnimating()
                        self.indicatorView.isHidden = true
                        self.tabBarController?.selectedIndex = 0
                    })
                    
                }
            }
        }
        else {
            print("Loggin Failed")
        }
    }
    
    //GET USER INFORMATION
    func getUserInformation(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil{
                print("Fail to start graph request: \(String(describing: error))")
                return
            }
            else {
                let data = result as! NSDictionary
                self.userEmail = data.object(forKey: "email") as? String
                if self.userEmail == nil {
                    self.userEmail = "ErrorEmail@gmail.com"
                }
                let name = data.object(forKey: "name")
                print(name as! String)
                print(self.userEmail!)
                self.getUserType()
                print(UserDefaults.standard.value(forKey: userTypeStandard) as! String)
            }
        }
    }
    
    //GET USER TYPE
    func getUserType(){
        UserDefaults.standard.set("DEFAULT", forKey: userTypeStandard)
        print("Setting TYPE...")
        for i in 1...3 {
            loginDispatchGroup.enter()
            getUser(numberOfType: i)
        }

    }
    
    func getUser(numberOfType: Int){
        let defaultStore = Firestore.firestore()
            print(numberOfType)
            let typeString = "TYPE" + String(numberOfType)
            defaultStore.collection(typeString).getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let email = document.documentID
                        if self.userEmail == email{
                            UserDefaults.standard.set(typeString, forKey: userTypeStandard)
                            print("User Type: \(typeString) - Login")
                            break
                        }
                    }
                }
                self.loginDispatchGroup.leave()
            })
    }
    
    func alertControl(){
        let alert = UIAlertController(title: "Error!", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            let fbManager = FBSDKLoginManager()
            fbManager.logOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Sign out firebase")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginAuthentication(message: String){
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryTransactionSegue" {
            let transactionHistoryViewController: TransactionHistoryViewController = segue.destination as! TransactionHistoryViewController
            transactionHistoryViewController.userEmail = self.userEmailFireBase
        }
        if segue.identifier == "UpdateAccountSegue" {
            
        }
    }
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "LOG OUT", message: "Do you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.loginView.isHidden = false
                self.userView.isHidden = true
                self.logOutButton.isEnabled = false
                self.editAccountButton.isEnabled = false
                let fbManager = FBSDKLoginManager()
                fbManager.logOut()
                UserDefaults.standard.set("DEFAULT", forKey: userTypeStandard)
                print("Sign Out - Set Default User")
                print("Sign out firebase")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func editAccountInfoAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshButtonAction(_ sender: UIButton) {
        updateUserInfor()
    }
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
}
