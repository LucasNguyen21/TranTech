//
//  TypeCell.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 15/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit

class TypeCell: UITableViewCell {
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var imageTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var nameTop: NSLayoutConstraint!
    @IBOutlet weak var nameLeading: NSLayoutConstraint!
    @IBOutlet weak var nameBottom: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeConstraint(typeName: String){
        if typeName == "INTERCOMS" {
            imageTrailing.constant = (view.bounds.width - typeImage.bounds.width + 20)/2
        }
    }

}
