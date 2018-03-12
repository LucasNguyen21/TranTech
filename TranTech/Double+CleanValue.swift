//
//  Double+CleanValue.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 1/3/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import Foundation

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}
