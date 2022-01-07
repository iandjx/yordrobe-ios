//
//  SettingOptions.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/27/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import Foundation

struct settingOptions {
    
    // Dear developer letter i realize this dictionary is created my mistake. i accept this is not a proper way. sorry for inconvenience
   // var dic_options :[String : [String]]  = ["wordrobe": ["Edit Profile", "Setting", "My Purchase", "My Swaps", "My Sold Items", "My Favourites"], "rewards": ["My Balance", "Earn $20 Credit"], "spreadTheWords": ["Facebook" , "Contacts"], "FollowFriends" : ["Facebook" , "Yordrobe"], "support" : ["FAQ", "Help Centre", "Legal", "Feedback", "Contact"], "other" : ["Logout", "Deactivate Your Account"]]
    // Remove Swap feature ...
    var dic_options :[String : [String]]  = ["wordrobe": ["Edit Profile", "Settings", "My Purchases", "My Sold Items", "My Favourites"], "rewards": ["My Balance", "Earn $20 Credit"], "spreadTheWords": ["Share"], "FollowFriends" : ["Facebook" , "Yordrobe"], "support" : ["FAQ", "Help Centre", "Legal", "Feedback", "Contact"], "other" : ["Logout", "Deactivate Your Account"]]
    
    /*
    lazy var info : [String: [String]] = {
        
        var dictionary = [String: [String]]()
        dictionary["Key1"] = ["A", "B", "C"]
        dictionary["Key2"] = ["D", "E", "F"]
        
        return dictionary
    }()
    */
}

var ary_settingsHeader = ["FILL MY MAIN FEED WITH ITEMS FROM", "Get notified when someone I am following lists an item","Get notified when someone follows me", "GET NOTIFITED WHEN A USER LOVES MY ITEM", "GET NOTIFITED WHEN A USER COMMENTS ON MY ITEM", "Get notified when a user purchases an item", "Get notified when any items I’ve purchased are posted"]
