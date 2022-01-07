//
//  FirstDIBsVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/30/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0

class FirstDIBsVC: UIViewController {
    @IBOutlet weak var tf_brand: UITextField!
    @IBOutlet weak var tf_category: UITextField!
    @IBOutlet weak var tf_subCategory: UITextField!
    @IBOutlet weak var tf_size: UITextField!
    @IBOutlet weak var tf_colour: UITextField!
    @IBOutlet weak var tf_condition: UITextField!
    @IBOutlet weak var tf_itemName: UITextField!
    @IBOutlet weak var scrl_main: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)

    }
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.scrl_main.frame.size.width, height: 565)
    }

    @IBAction func btn_select(_ sender: UIButton) {
        getData(btn_tag: sender.tag)
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")
    var ary_pickerData: Array! = []
    
    func getData(btn_tag:Int)  {
        
        
        self.view.addSubview(progressHUD)
        ary_pickerData.removeAll()
        
        if btn_tag == 1  {
            getPickerData(btn_tag: btn_tag, keyValue: "", Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Brand")
                self.progressHUD.removeFromSuperview()
                
            })
        }
            
        else if btn_tag == 2 {
            getPickerData(btn_tag: btn_tag, keyValue:tf_brand.text!, Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\(((index as! PFObject)["category"]! as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Category")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 3 {
            getPickerData(btn_tag: btn_tag, keyValue:tf_category.text!, Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["SubCategoryName"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Sub Category")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 4 {
            getPickerData(btn_tag: btn_tag, keyValue:tf_category.text!, Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\(((index as! PFObject)["size"]! as! PFObject)["Size"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Size")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 5 {
            getPickerData(btn_tag: btn_tag, keyValue:"", Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Colour")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 6 {
            ary_pickerData = ["New","Pre-Loved"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Condition")
            self.progressHUD.removeFromSuperview()
        }
        
    }
    func openPicker(btn_tag:Int, row: Array<Any>, title : String) {
        
        ActionSheetStringPicker.show(withTitle: title, rows: row, initialSelection: 0, doneBlock: {
            picker, index, value in
            
            if btn_tag == 1 {
                if value != nil {
                    self.tf_brand.text = "\(value!)"
                }
            }
            else if btn_tag == 2 {
                if value != nil {
                    self.tf_category.text = "\(value!)"
                }
            }
            else if btn_tag == 3 {
                if value != nil {
                    self.tf_subCategory.text = "\(value!)"
                }
            }
            else if btn_tag == 4 {
                if value != nil {
                    self.tf_size.text = "\(value!)"
                }
            }
            else if btn_tag == 5 {
                if value != nil {
                    self.tf_colour.text = "\(value!)"
                }
            }
            else if btn_tag == 6 {
                if value != nil {
                    self.tf_condition.text = "\(value!)"
                }
            }
            print("index = \(index)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
    }


    @IBAction func btn_getFirstDibs(_ sender: Any) {
        
        if tf_brand.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Brand")
        }
        else if tf_category.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Category")
        }
        else if tf_subCategory.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Sub Category")
        }
        else if tf_size.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Size")
        }
        else if tf_colour.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Colour")
        }
        else if tf_condition.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Condition")
        }
        else if tf_itemName.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Item Name")
        }
        else{
            API_saveFirstDIBs(brand: tf_brand.text!, category: tf_category.text!, sub_category: tf_subCategory.text!, size: tf_size.text!, colour: tf_colour.text!, condition: tf_condition.text!, itemName: tf_itemName.text!)
        }
    }
    
    func API_saveFirstDIBs(brand: String, category: String, sub_category: String, size: String, colour: String, condition: String, itemName: String) {
        
        self.view.addSubview(progressHUD)
        
        let item = PFObject(className:"FirstDIBs")
        item["brand"] = brand
        item["category"] = category
        item["subCategory"] = sub_category
        item["size"] = size
        item["colour"] = colour
        item["condition"] = condition
        item["itemName"] = itemName
        item["requestedBy"] = PFUser.current()
        
        item.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                
                self.tf_brand.text = ""
                self.tf_category.text = ""
                self.tf_subCategory.text = ""
                self.tf_size.text = ""
                self.tf_colour.text = ""
                self.tf_condition.text = ""
                self.tf_itemName.text = ""
            }
            else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_back(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
