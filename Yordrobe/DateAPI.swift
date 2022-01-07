//
//  DateAPI.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/28/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import Foundation

class CustomDateFunctions {
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        // make sure the following are the same as that used in the API
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        
        return formatter
    }()
    
    class func shortString(fromDate date: Date) -> String {
        return formatter.string(from: date)
    }
    
    class func date(fromShortString string: String) -> Date? {
        return formatter.date(from: string)
    }
}
