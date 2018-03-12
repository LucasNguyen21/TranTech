//
//  OrderList+CoreDataProperties.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 8/3/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderList> {
        return NSFetchRequest<OrderList>(entityName: "OrderList")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var qty: String?

}
