//
//  BorderImage.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/18/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class BorderImage: UIImageView {
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}
