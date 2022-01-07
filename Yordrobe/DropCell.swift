//
//  DropCell.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/26/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class DropCell: UITableViewCell {

    @IBOutlet weak var lbl_brand: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_subCategory: UILabel!
    @IBOutlet weak var lbl_priceRange: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var lbl_condition: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_colour: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
