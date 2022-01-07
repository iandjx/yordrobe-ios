//
//  ProjectCell.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/26/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    // Notfication screen
    @IBOutlet weak var img_userIcon: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_userEvent: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var btn_new: UIButton!
    // Discover || Options || Setting screen
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var lbl_rewardBalance: UILabel!
    
    @IBOutlet weak var img_cellBg: UIImageView!
    
    // Setting screen
    @IBOutlet weak var btn_checkBox: UIButton!
    @IBOutlet weak var btn_yes: checkBox!
    @IBOutlet weak var btn_no: checkBox!
    
    // My Purchases
    @IBOutlet weak var btn_rateSeller: UIButton!
    @IBOutlet weak var lbl_myFeedback: UILabel!
    @IBOutlet weak var lbl_PurchaseDate: UILabel!
    @IBOutlet weak var lbl_itemPosted: UILabel!
    @IBOutlet weak var btn_amount: UIButton!
    @IBOutlet weak var lbl_soldDate: UILabel!
    
    // Follower
    @IBOutlet weak var lbl_userID: UILabel!
    @IBOutlet weak var btn_follower: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img_userIcon?.layer.cornerRadius = (img_userIcon?.bounds.height)! / 2
        img_userIcon?.clipsToBounds = true
        img_userIcon?.layer.borderWidth = 1
        img_userIcon?.layer.borderColor = UIColor.darkGray.cgColor

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
