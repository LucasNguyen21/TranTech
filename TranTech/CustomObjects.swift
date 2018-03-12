//
//  CustomObjects.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 2/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

struct orderRecord {
    var name: String
    var code: String
    var qty: String
    var price: String
    var subTotal: String
    var gst: String
    var total: String
}

struct userInforFB {
    var abnCode: String!
    var companyName: String!
    var firstName: String!
    var natureOfBusiness: String!
    var phoneNumber: String!
    var residentialAddress: String!
    var surName: String!
    var tradingAddress: String!
    var rewardPoints: String!
}

struct productInfo {
    var productName: String
    var productDesc: String
    var productPrice: Double
    var productPriceType2: Double
    var productPriceType3: Double
    var productSpec: String
    var productFenDesc: String
    var productPriority: String
    var productDriver: String
}


class CustomObjects: NSObject {
}
