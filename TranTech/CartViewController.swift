//
//  CartViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 8/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth
import MessageUI
import CoreData


class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, LoadCart, UITextViewDelegate{
    
    @IBOutlet weak var specialRequestTextView: UITextView!
    @IBOutlet weak var recordTableView: UITableView!
    @IBOutlet weak var totalOfEverythingLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyCartBarButtonItem: UIBarButtonItem!

    
    var orderList = [OrderList]()

    var managedObjectContext: NSManagedObjectContext!
    
    var totalOfEverything: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
        
        indicatorInitial()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(CartViewController.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CartViewController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        specialRequestTextView.text = "Write Your Special Request Here"
        specialRequestTextView.textColor = UIColor.lightGray
        specialRequestTextView.layer.masksToBounds = true
        specialRequestTextView.layer.borderWidth = 1
        specialRequestTextView.layer.borderColor = UIColor.black.cgColor
        specialRequestTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isUserInteractionEnabled = false
        totalOfEverything = 0
        loadCart()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if specialRequestTextView.textColor == UIColor.lightGray {
            specialRequestTextView.text = ""
            specialRequestTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if specialRequestTextView.text.isEmpty {
            specialRequestTextView.text = "Write Your Special Request Here"
            specialRequestTextView.textColor = UIColor.lightGray
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    func indicatorInitial(){
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingView)
        indicator.startAnimating()
        indicator.tag = 100
    }
    
    func loadCart(){
        indicator.startAnimating()
        loadingView.isHidden = false
        view.isUserInteractionEnabled = false
        if let user = Auth.auth().currentUser {
            print(user.email!)
            orderList = []
            //Fetch Data from Coredata
            let fetchRequest = NSFetchRequest<OrderList>(entityName: "OrderList")
            do{
                //Filter Data by ID
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                self.orderList = try self.managedObjectContext.fetch(fetchRequest)
            }
            catch{
                let fetchError = error as NSError
                print(fetchError)
            }
            if orderList.isEmpty {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
            } else {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "1"
            }
            self.recordTableView.reloadData()
            self.updateTotallabel()
            self.loadingView.isHidden = true
            self.indicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        } else {
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.recordTableView.reloadData()
            self.updateTotallabel()
            self.loadingView.isHidden = true
            self.indicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderTableViewCell
        let subtotal: Double = Double(orderList[indexPath.row].price!)! * Double(orderList[indexPath.row].qty!)!
        let gst: Double = subtotal / 10
        let total: Double = subtotal + gst
        cell.nameLabel.text = orderList[indexPath.row].name
        cell.priceLabel.text = subtotal.cleanValue
        cell.qtyLabel.text = orderList[indexPath.row].qty
        cell.gtsLabel.text = gst.cleanValue
        cell.totalLabel.text = total.cleanValue
        let selectedCellView = UIView()
        selectedCellView.backgroundColor = UIColor(red: 67/255, green: 186/255, blue: 186/255, alpha: 1)
        cell.selectedBackgroundView = selectedCellView
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 206/255, green: 247/255, blue: 247/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 186/255, green: 239/255, blue: 239/255, alpha: 1)
        }
    }
    
    @IBAction func checkOut(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            if orderList.count == 0 {
                alertController(title: "Empty Cart", message: "Cart is Empty")
            }
            else {
                if (MFMailComposeViewController.canSendMail()){
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let checkoutConfirmViewController =  storyBoard.instantiateViewController(withIdentifier: "CheckoutConfirmSID") as! CheckoutConfirmViewController
                    checkoutConfirmViewController.orderRecordList = orderList
                    checkoutConfirmViewController.specialRequestText = specialRequestTextView.text
                    checkoutConfirmViewController.delegate = self
                    self.present(checkoutConfirmViewController, animated: true, completion: nil)
                }
                else {
                    print("no mail")
                    alertController(title: "No Mail Setting is Found", message: "Order will be sent in a form of an email. Pls ensure email is set up in your device. Go to setting in your phone -> set up mail account")
                }
            }
        }else {
            alertController(title: "Login is required", message: "You need login to check out")
        }
    }

    @IBAction func emptyCartAction(_ sender: UIBarButtonItem) {
        emptyCartBarButtonItem.isEnabled = false
        if let user = Auth.auth().currentUser{
            print(user.email!)
            let alert = UIAlertController(title: "Empty Cart", message: "Are you sure to empty current cart?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                if self.orderList.count > 0 {

                    for record in self.orderList {
                        self.managedObjectContext.delete(record)
                    }
                    self.saveContext()
                    self.loadCart()
                    self.totalOfEverything = 0
                    self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
                    self.emptyCartBarButtonItem.isEnabled = true
                } else {
                    //Do nothing
                    print("Empty Card Already")
                    self.emptyCartBarButtonItem.isEnabled = true
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
                self.emptyCartBarButtonItem.isEnabled = true
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            alertController(title: "Login is required", message: "Login to use this function")
            emptyCartBarButtonItem.isEnabled = true
        }
    }

    func alertController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func emptyTextView(){
        specialRequestTextView.text = "Write Your Special Request Here"
        specialRequestTextView.textColor = UIColor.lightGray
        totalOfEverything = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderUpdateSegue" {
            let updateCartRecordViewController: UpdateCartRecordViewController = segue.destination as! UpdateCartRecordViewController
            if let selectedCell = sender as? UITableViewCell {
                let indexPath = recordTableView.indexPath(for: selectedCell)!
                let selectedEntry = orderList[indexPath.row].qty
                updateCartRecordViewController.qty = selectedEntry
                updateCartRecordViewController.productName = orderList[indexPath.row].name
                updateCartRecordViewController.productPrice = orderList[indexPath.row].price
                updateCartRecordViewController.delegate = self
            }
        }
    }
    
    func updateTotallabel(){
        var total: Double = 0
        for record in orderList {
            if Double(record.price!) != nil && Double(record.qty!) != nil{
                total = total + (Double(record.price!)! * Double(record.qty!)! * 1.1)
            }
        }
        totalOfEverything = total
        if orderList.count <= 1 {
            totalOfEverythingLabel.text = ""
            totalOfEverythingLabel.isHidden = true
        } else {
            totalOfEverythingLabel.isHidden = false
            totalOfEverythingLabel.text = "TOTAL: $" + total.cleanValue
        }
    }
    
    
    
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error with Coredata")
        }
    }
    
    func emptyCart(){
        for record in self.orderList {
            self.managedObjectContext.delete(record)
        }
        self.saveContext()
        self.loadCart()
        self.totalOfEverything = 0
        self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    func alertOrderController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: popToRootViewName, object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


