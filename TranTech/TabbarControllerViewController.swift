//
//  TabbarControllerViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 9/3/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore

class TabbarControllerViewController: UITabBarController {

    var orderList = [OrderList]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
        if self.orderList.isEmpty == false {
            let tabbarItems = self.tabBar.items as NSArray!
            let tabbarItem = tabbarItems![2] as! UITabBarItem
            tabbarItem.badgeValue = "1"
        } else {
            let tabbarItems = self.tabBar.items as NSArray!
            let tabbarItem = tabbarItems![2] as! UITabBarItem
            tabbarItem.badgeValue = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
