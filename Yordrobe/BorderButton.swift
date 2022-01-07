//
//  BorderButton.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/2/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class BorderButton: UIButton {
    
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        //self.layer.cornerRadius = 0.5 * self.bounds.size.height
        self.clipsToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        //self.backgroundColor = UIColor.white
        
        
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
