//
//  ProductCell.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/17/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    // Product List Outlets
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var img_sold: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var img_userIcon: UIImageView!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var btn_like: UIButton!
    // Wordrobe list 
    @IBOutlet weak var lbl_firstName: UILabel!
    // Profile
    @IBOutlet weak var lbl_sectionName: UILabel!
    @IBOutlet weak var lbl_brandName: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    
    
    override func layoutSubviews() {
        img_userIcon?.layer.cornerRadius = (img_userIcon?.bounds.height)! / 2
        img_userIcon?.clipsToBounds = true
        img_userIcon?.layer.borderWidth = 1
        img_userIcon?.layer.borderColor = UIColor.darkGray.cgColor
    }
}


