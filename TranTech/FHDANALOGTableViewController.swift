//
//  FHDANALOGTableViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 20/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class FHDANALOGTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        navigationItem.title = "FHD ANALOG"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginButton: UIBarButtonItem = UIBarButtonItem(title: "Home",style: .plain,target: self,action: #selector(loginAction))
        self.navigationItem.rightBarButtonItem = loginButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginAction(){
        //tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == dahuaMadeToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "DAHUA MADE"
            productTypeViewController.mainCategoryName = "FHD ANALOG"
        }
        
        if segue.identifier == samSungToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "SAMSUNG"
            productTypeViewController.mainCategoryName = "FHD ANALOG"
        }
        
        if segue.identifier == dVRSToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "DVRS"
            productTypeViewController.mainCategoryName = "FHD ANALOG"
        }
        
        /////////
        
        if segue.identifier == fHDAnalogCameraSegue {
            let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productCollectionViewController.mainCategoryName = "FHD ANALOG"
            productCollectionViewController.categoryName = "FHD ANALOG CAMERA"
        }
        
        if segue.identifier == fHDSDICameraSegue {
            let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productCollectionViewController.mainCategoryName = "FHD ANALOG"
            productCollectionViewController.categoryName = "FHD SDI CAMERA"
        }
    }
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }

}
