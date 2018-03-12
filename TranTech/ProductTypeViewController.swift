//
//  ProductTypeViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 15/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProductTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mainCategoryName: String?
    var categoryName: String!
    var typeName = [String]()
    var typeImageName = [String]()
    @IBOutlet weak var TypeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.naviToTopView(notification:)), name: popToRootViewName, object: nil)
        
        navigationItem.title = mainCategoryName
        navigationItem.backBarButtonItem?.title = "Back"
        if mainCategoryName == "POWER SYSTEM" {
            typeName = ["POE SWITCH", "SWITCH", "MODEM", "WIFI EXTENDER"]
            typeImageName = ["poeswitch", "switch", "modem", "wifiextender"]
        }
        
        if mainCategoryName == "INTERCOMS" {
            typeName = ["PANASONIC", "DAHUA MADE", "DORANI"]
            typeImageName = ["panasonic", "DahuaLogo", "dorani"]
        }
        
        if mainCategoryName == "ACCESSORIES" {
            typeName = ["SURVEILLANCE HDD", "BRACKETS","CABLES", "LENS", "BALUN", "CONNECTOR", "TESTER DEVICE", "VIDEO MULTIPLEXER", "WIRELESS MOUSE", "POWER ADAPTER", "POWER BOX & UPS"]
            
            typeImageName = ["SURVEILLANCE HDD","BRACKETS", "CABLES", "LENS", "BALUN", "CONNECTOR", "TESTER DEVICE", "VIDEO MULTIPLEXER", "WIRELESS MOUSE", "poweradapter", "powerbox&ups"]
        }
        
        if mainCategoryName == "IP NETWORK SYSTEM" {
            if categoryName == "DAHUA MADE" {
                typeName = ["IP CAMERA", "NVRS", "IP NETWORK PTZ", "4K NETWORK CAMERA"]
                typeImageName = ["IP CAMERA", "NVRS", "IP NETWORK PTZ", "4K NETWORK CAMERA"]
            }
            if categoryName == "SAMSUNG" {
                typeName = ["NVRS", "IP CAMERA"]
                typeImageName = ["NVRS", "IP CAMERA"]
            }
            if categoryName == "HIKVISION" {
                typeName = ["NVRS", "IP CAMERA"]
                typeImageName = ["NVRS", "IP CAMERA"]
            }
            if categoryName == "BASIC SERIES IPC" {
                typeName = ["1.3MP", "2MP"]
                typeImageName = ["1.3 MP", "2MP"]
            }
            if categoryName == "NVRS" {
                typeName = ["BASIC SERIES NVR", "PROFESSIONAL SERIES NVR"]
                typeImageName = ["BASIC SERIES NVR","PROFESSIONAL SERIES NVR"]
            }

        }
        
        if mainCategoryName == "FHD ANALOG" {
            if categoryName == "DAHUA MADE" {
                typeName = ["CVI CAMERA", "CVI DVRS", "CVI-AHD PTZ"]
                typeImageName = ["CVI CAMERA", "CVI DVRS", "CVI-AHD PTZ"]
            }
            
            if categoryName == "SAMSUNG" {
                typeName = ["DVRS", "ANALOG SERIES"]
                typeImageName = ["SAMSUNGDVRS", "ANALOG SERIES"]
            }
            
            
            if categoryName == "DVRS" {
                typeName = ["960H DVR", "HD DVR", "FHD DVR", "SDI DVR", "ALL IN 1 DVR"]
                typeImageName = ["ALLIN1DVR","ALLIN1DVR","ALLIN1DVR","ALLIN1DVR","ALLIN1DVR"]
            }
        }
        
        if mainCategoryName == "ACCESS CONTROL" {
            typeName = ["MAGNETIC LOCK", "ELECTRIC STRIKER", "KEYPAD", "ACCESSORIES"]
            typeImageName = ["MAGNETIC LOCK AC", "ELECTRIC STRIKER AC", "KEYPAD AC", "ACCESSORIES AC"]
        }
        
        if mainCategoryName == "ALARM SYSTEM" {
            typeName = ["KITs", "MODULE", "KEYPAD & READER", "PIRs & DETECTORS", "REMOTE & ACCESSORIES"]
            typeImageName = ["KITs","MODULE", "KEYPAD & READER", "PIRs & DETECTORS", "REMOTE & ACCESSORIES"]
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeName.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeCell
        if mainCategoryName == "INTERCOMS"{
            cell.changeConstraint(typeName: "INTERCOMS")
            cell.typeImage.image = UIImage(named: self.typeImageName[indexPath.row])
            cell.typeName.text = ""
        } else {
            let typeNameRecord = self.typeName[indexPath.row]
            let typeImageRecord = self.typeImageName[indexPath.row]
            cell.typeImage.image = UIImage(named: typeImageRecord)
            cell.typeName.text = typeNameRecord
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == typeToProductSegue {
            
            if mainCategoryName == "IP NETWORK SYSTEM" || mainCategoryName == "FHD ANALOG" {
                let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
                if let selectedCell = sender as? UITableViewCell{
                    let indexPath = TypeTableView.indexPath(for: selectedCell)!
                    let selectedCategory = typeName[indexPath.row]
                    productCollectionViewController.categoryName = categoryName
                    productCollectionViewController.mainCategoryName = mainCategoryName
                    productCollectionViewController.kindName = selectedCategory
                    
                }
            }else{
                let productCollectionViewController: ProductCollectionViewController = segue.destination as! ProductCollectionViewController
                if let selectedCell = sender as? UITableViewCell{
                    let indexPath = TypeTableView.indexPath(for: selectedCell)!
                    let selectedCategory = typeName[indexPath.row]
                    productCollectionViewController.categoryName = selectedCategory
                    productCollectionViewController.mainCategoryName = mainCategoryName
                    
                }
            }
        }
    }
    
    func naviToTopView(notification: NSNotification){
        _ = navigationController?.popToRootViewController(animated: true)
    }

}
