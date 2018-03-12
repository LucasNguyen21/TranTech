//
//  UserInfor+CoreDataProperties.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 9/3/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfor> {
        return NSFetchRequest<UserInfor>(entityName: "UserInfor")
    }

    @NSManaged public var abnCode: String?
    @NSManaged public var companyName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var natureOfBusiness: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var residentialAddress: String?
    @NSManaged public var surName: String?
    @NSManaged public var tradingAddress: String?
    @NSManaged public var email: String?

}
