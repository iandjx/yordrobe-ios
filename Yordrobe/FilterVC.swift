//
//  FilterVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/29/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0

class FilterVC: UIViewController {

    
    @IBOutlet weak var tf_sortOrder: UITextField!
    @IBOutlet weak var tf_brand: UITextField!
    @IBOutlet weak var tf_category: UITextField!
    @IBOutlet weak var tf_subCategory: UITextField!
    @IBOutlet weak var tf_size: UITextField!
    @IBOutlet weak var tf_colour: UITextField!
    @IBOutlet weak var tf_priceRange: UITextField!
    @IBOutlet weak var tf_condition: UITextField!
    
    
    
    @IBOutlet weak var scrl_main: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
        
    }
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.scrl_main.frame.size.width, height: 615)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_select(_ sender: UIButton) {
        
        getData(btn_tag: sender.tag)
    }

    let progressHUD = ProgressHUD(text: "Loading..")
    var ary_pickerData: Array! = []
    
    func getData(btn_tag:Int)  {
        
        
        self.view.addSubview(progressHUD)
        ary_pickerData.removeAll()
        
        if btn_tag == 0 {
            ary_pickerData = ["Most Recent","Price High to Low","Price Low to High"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Select Order")
            self.progressHUD.removeFromSuperview()
            
        }
        else if btn_tag == 1  {
            getPickerData(btn_tag: btn_tag, keyValue: "", Vc: self, completionHandler: { result -> Void in
                print("result == \(result)")
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Brand")
                self.progressHUD.removeFromSuperview()
                
            })
        }
            
        else if btn_tag == 2 {
            getPickerData(btn_tag: btn_tag, keyValue:tf_brand.text!, Vc: self, completionHandler: { result -> Void in
                print("result == \(result)")
                for index in result {
                    self.ary_pickerData.append("\(((index as! PFObject)["category"]! as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Category")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 3
        {
            getPickerData(btn_tag: btn_tag, keyValue:tf_category.text!, Vc: self, completionHandler: { result -> Void in
                print("result == \(result)")
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["SubCategoryName"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Sub Category")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 4 {
            getPickerData(btn_tag: btn_tag, keyValue:tf_category.text!, Vc: self, completionHandler: { result -> Void in
                print("result == \(result)")
                for index in result {
                    self.ary_pickerData.append("\(((index as! PFObject)["size"]! as! PFObject)["Size"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Size")
                self.progressHUD.removeFromSuperview()
            })
        }
        else if btn_tag == 5 {
            getPickerData(btn_tag: btn_tag, keyValue:"", Vc: self, completionHandler: { result -> Void in
                print("result == \(result)")
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Colour")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 6 {
            ary_pickerData = ["$20 - $50","$50 - $100","$100 - $200","$200 - $300","$300 - $400","$400 - $500","> $500"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Price Range")
            self.progressHUD.removeFromSuperview()

        }
        else if btn_tag == 7 {
            ary_pickerData = ["New","Pre-Loved"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Condition")
            self.progressHUD.removeFromSuperview()
        }
        
    }

    var dic_filter: Dictionary! = [:]

    func openPicker(btn_tag:Int, row: Array<Any>, title : String) {
        
        ActionSheetStringPicker.show(withTitle: title, rows: row, initialSelection: 0, doneBlock: {
            picker, index, value in
            
            if btn_tag == 0 {
                if value != nil {
                    self.tf_sortOrder.text = "\(value!)"
                    self.dic_filter["sort_order"] = "\(value!)"
                }
            }
            else if btn_tag == 1 {
                if value != nil {
                self.tf_brand.text = "\(value!)"
                self.dic_filter["brand"] = "\(value!)"
                }
            }
            else if btn_tag == 2 {
                if value != nil {
                self.tf_category.text = "\(value!)"
                self.dic_filter["category"] = "\(value!)"
                }
            }
            else if btn_tag == 3 {
                if value != nil {
                self.tf_subCategory.text = "\(value!)"
                self.dic_filter["sub_category"] = "\(value!)"
                }
            }
            else if btn_tag == 4 {
                if value != nil {
                self.tf_size.text = "\(value!)"
                self.dic_filter["size"] = "\(value!)"
                }
            }
            else if btn_tag == 5 {
                if value != nil {
                self.tf_colour.text = "\(value!)"
                self.dic_filter["colour"] = "\(value!)"
                }
            }
            else if btn_tag == 6 {
                if value != nil {
                self.tf_priceRange.text = "\(value!)"
                self.dic_filter["price_range"] = "\(value!)"
                }
            }
            else if btn_tag == 7 {
                if value != nil {
                self.tf_condition.text = "\(value!)"
                self.dic_filter["condition"] = "\(value!)"
                }

            }
            print("index = \(index)")
            //print("self.dic_filter = \(self.dic_filter!)")
            //print("self.dic_filter = \(self.dic_filter!["sort_order"]!)")
            //print("value = \(String(describing: value!))")
            //print("picker = \(String(describing: picker))")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
    }

    @IBAction func btn_cross(_ sender: UIButton) {
        
        if sender.tag == 0 {
            tf_sortOrder.text = ""
            dic_filter.removeValue(forKey: "sort_order")
        }
        else if sender.tag == 1 {
            tf_brand.text = ""
            dic_filter.removeValue(forKey: "brand")
        }
        else if sender.tag == 2 {
            tf_category.text = ""
            dic_filter.removeValue(forKey: "category")
        }
        else if sender.tag == 3 {
            tf_subCategory.text = ""
            dic_filter.removeValue(forKey: "sub_category")
        }
        else if sender.tag == 4 {
            tf_size.text = ""
            dic_filter.removeValue(forKey: "size")
        }
        else if sender.tag == 5 {
            tf_colour.text = ""
            dic_filter.removeValue(forKey: "colour")
        }
        else if sender.tag == 6 {
            tf_priceRange.text = ""
            dic_filter.removeValue(forKey: "price_range")
        }
        else if sender.tag == 7 {
            tf_condition.text = ""
            dic_filter.removeValue(forKey: "condition")
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBAction func btn_filter(_ sender: Any) {
        
        
        
        appDelegate.dic_filterProduct = self.dic_filter

        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        
    }
    @IBAction func btn_getFirstDIBs(_ sender: Any) {
        self.performSegue(withIdentifier: "FirstDIBsVC", sender: nil)
    }
    @IBAction func btn_back(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
            self.dic_filter.removeAll()
            appDelegate.dic_filterProduct = self.dic_filter
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
