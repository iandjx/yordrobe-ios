//
//  FilterHelper.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/22/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import Foundation
import Parse
import ActionSheetPicker_3_0

func getPickerData(btn_tag: Int, keyValue: String, Vc: UIViewController,completionHandler: @escaping (_ result : Array<Any>) -> Void) {
    
    var query = PFQuery()
    if btn_tag == 1 {
        query = PFQuery(className:"Brands")
        if let gender: String = PFUser.current()!["gender"] as? String {
            if gender == "Male" {
                query.whereKey("forMales", equalTo: true)
            }
            else if gender == "Female" {
                query.whereKey("forFemales", equalTo: true)
            }
        }
    }
    else if btn_tag == 2 {
        query = PFQuery(className:"CatsPerBrand")
        query.includeKey("category")
        query.whereKey("brandName", equalTo: keyValue)
    }
    else if btn_tag == 3 {
        query = PFQuery(className:"SubCategory")
        query.whereKey("CategoryName", equalTo: keyValue)
    }
    else if btn_tag == 4 {
        query = PFQuery(className:"SizesPerCategory")
        query.order(byAscending: "displayOrder")
        query.whereKey("category", equalTo: keyValue)
        query.includeKey("size")
    }
    else if btn_tag == 5
    {
        query = PFQuery(className:"Colour")
        query.order(byAscending: "DisplayOrder")
    }
    else if btn_tag == 6
    {
        query = PFQuery(className:"Section")
        query.whereKey("User", equalTo: PFUser.current()!)
    }
    query.findObjectsInBackground { (objects, error) -> Void in
        if error == nil
        {
            if let objects = objects {
                print("objects == \(objects)")
                completionHandler(objects)
            }
        }
        else
        {
            showDialog(vc: Vc, title: "Error!", message: "\(error!.localizedDescription)")
        }
    }
}



