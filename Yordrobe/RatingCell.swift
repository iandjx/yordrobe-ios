//
//  RatingCell.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 10/4/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {
    @IBOutlet weak var img_userIcon: UIImageView!
    @IBOutlet weak var lbl_userID: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var tv_description: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
