//
//  ProductCollectionViewCell.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 14/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productModelLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productGenDesc: UILabel!
}
