
//
//  HasTagHelper.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 10/12/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func convertHashtags(text:String) -> NSAttributedString {
        
        let attr = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0),
            NSAttributedString.Key.foregroundColor : clr_golden,
            //NSLinkAttributeName : "https://Laitkor.com"
        ] as [NSAttributedString.Key : Any]

        
        let attrString = NSMutableAttributedString(string: text)
        attrString.beginEditing()
        // match all hashtags
        do {
            // Find all the hashtags in our string
            let regex = try NSRegularExpression(pattern: "(?:\\s|^)(#(?:[a-zA-Z].*?|\\d+[a-zA-Z]+.*?))\\b", options: NSRegularExpression.Options.anchorsMatchLines)
            let results = regex.matches(in: text,
                                                options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, text.count))
            let array = results.map { (text as NSString).substring(with: $0.range) }
            for hashtag in array {
                // get range of the hashtag in the main string
                let range = (attrString.string as NSString).range(of: hashtag)
                // add a colour to the hashtag
                //attrString.addAttribute(NSForegroundColorAttributeName, value: clr_golden , range: range)
                attrString.addAttributes(attr, range: range)
            }
            attrString.endEditing()
        }
        catch {
            attrString.endEditing()
        }
        return attrString
    }
}
