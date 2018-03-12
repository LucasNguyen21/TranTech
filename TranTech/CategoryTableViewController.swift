//
//  CategoryTableViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 14/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseFirestore

class CategoryTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        //Check when user first install or re-install the app
        if UserDefaults.standard.value(forKey: orderNumberUrl) == nil {
            UserDefaults.standard.set("0", forKey: orderNumberUrl)
        }
        getUserType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            
        } else {
            UserDefaults.standard.set("DEFAULT", forKey: userTypeStandard)
            print("set default user")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserType(){
        if let user = Auth.auth().currentUser {
            UserDefaults.standard.set("DEFAULT", forKey: userTypeStandard)
            let defaultStore = Firestore.firestore()
            defaultStore.collection("TYPE1").getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let email = document.documentID
                        if user.email == email{
                            UserDefaults.standard.set("TYPE1", forKey: userTypeStandard)
                            print("User Type 1")
                            break
                        }
                    }
                }
            })
            
            defaultStore.collection("TYPE2").getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let email = document.documentID
                        if user.email == email{
                            UserDefaults.standard.set("TYPE2", forKey: userTypeStandard)
                            print("User Type 2")
                            break
                        }
                    }
                }
            })
            
            defaultStore.collection("TYPE3").getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let email = document.documentID
                        if user.email == email{
                            UserDefaults.standard.set("TYPE3", forKey: userTypeStandard)
                            print("User Type 3")
                            break
                        }
                    }
                }
            })
        } else {
            UserDefaults.standard.set("DEFAULT", forKey: userTypeStandard)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func loginAction(){
        tabBarController?.selectedIndex = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == alarmSystemToProductSegueUrl {
            let productViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productViewController.mainCategoryName = "ALARM SYSTEM"
        }
        if segue.identifier == commercialToProductSegueUrl {
            let productViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productViewController.mainCategoryName = "WIRELESS AP"
            
        }
        
        if segue.identifier == accessControlToProductSegueUrl {
            let productViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productViewController.mainCategoryName = "ACCESS CONTROL"
        }
        
        if segue.identifier == monitorToProductSegueUrl {
            let productViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productViewController.mainCategoryName = "MONITORS"
        }
        
        if segue.identifier == powerSystemToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.mainCategoryName = "POWER SYSTEM"
        }
        
        if segue.identifier == intercomToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.mainCategoryName = "INTERCOMS"
        }
        
        if segue.identifier == accessoriesToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.mainCategoryName = "ACCESSORIES"
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderTableViewCell
////        cell.gtsLabel.text = orderRecordList[indexPath.row].gst
////        cell.nameLabel.text = orderRecordList[indexPath.row].name
////        cell.qtyLabel.text = orderRecordList[indexPath.row].qty
////        cell.priceLabel.text = orderRecordList[indexPath.row].subTotal
////        cell.totalLabel.text = orderRecordList[indexPath.row].total
////        let selectedCellView = UIView()
////        selectedCellView.backgroundColor = UIColor(red: 67/255, green: 186/255, blue: 186/255, alpha: 1)
////        cell.selectedBackgroundView = selectedCellView
//    }
    
    func alertControl(){
        let alert = UIAlertController(title: "Notification", message: "In order to see our product price, you need to create an account with our permission", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
