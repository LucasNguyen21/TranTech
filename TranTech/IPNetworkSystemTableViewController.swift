//
//  IPNetworkSystemTableViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 21/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class IPNetworkSystemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        navigationItem.title = "IP NETWORK SYSTEM"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginButton: UIBarButtonItem = UIBarButtonItem(title: "Home",style: .plain,target: self,action: #selector(loginAction))
        self.navigationItem.rightBarButtonItem = loginButton
    }
    
    func loginAction(){
        navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if segue.identifier == iPDahuaToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "DAHUA MADE"
            productTypeViewController.mainCategoryName = "IP NETWORK SYSTEM"
        }
        if segue.identifier == iPSamsungToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "SAMSUNG"
            productTypeViewController.mainCategoryName = "IP NETWORK SYSTEM"
        }
        if segue.identifier == iPHikvisionToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "HIKVISION"
            productTypeViewController.mainCategoryName = "IP NETWORK SYSTEM"
        }
        if segue.identifier == iPBasicSeriesIPCSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "BASIC SERIES IPC"
            productTypeViewController.mainCategoryName = "IP NETWORK SYSTEM"
        }
        if segue.identifier == iPNVRSToTypeSegue {
            let productTypeViewController: ProductTypeViewController = segue.destination as! ProductTypeViewController
            productTypeViewController.categoryName = "NVRS"
            productTypeViewController.mainCategoryName = "IP NETWORK SYSTEM"
        }
        
        ///////////
        if segue.identifier == fourKNetworkCameraSegue {
            let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productCollectionViewController.mainCategoryName = "IP NETWORK SYSTEM"
            productCollectionViewController.categoryName = "4K NETWORK CAMERA"
        }
        
        if segue.identifier == proSeriesIPCSegue {
            let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productCollectionViewController.mainCategoryName = "IP NETWORK SYSTEM"
            productCollectionViewController.categoryName = "OEM IPC"
        }
        
        if segue.identifier == iPNetworkPTZsegue {
            let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
            productCollectionViewController.mainCategoryName = "IP NETWORK SYSTEM"
            productCollectionViewController.categoryName = "IP NETWORK PTZ"
        }
    }
    
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
