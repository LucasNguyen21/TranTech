//
//  CategoryViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 14/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryName = [String]()
    var categoryImage = [String]()

    @IBOutlet weak var categoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName = ["FHD ANALOG", "IP NETWORK SYSTEM", "ALARM SYSTEM", "COMMERCIAL WIRELESS AP/BRIDGE", "ACCESS CONTROL", "POWER SYSTEM", "INTERCOM", "MONITOR", "ACCESSORIES", "PROMOTION"]
        categoryImage = ["UnknownImage", "UnknownImage","UnknownImage","UnknownImage","UnknownImage","UnknownImage","UnknownImage","UnknownImage","UnknownImage","UnknownImage",]
        categoryTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let categoryNameRecord = self.categoryName[indexPath.row]
        let categoryImageRecord = self.categoryImage[indexPath.row]
        cell.categoryNameLabel.text = categoryNameRecord
        cell.CategoryImageView.image = UIImage(named: categoryImageRecord)
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
