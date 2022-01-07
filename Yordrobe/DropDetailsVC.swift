//
//  DropDetailsVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/21/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0

class DropDetailsVC: UIViewController {
    
    @IBOutlet weak var scrl_main: UIScrollView!
    
    @IBOutlet weak var tf_brand: UITextField!
    @IBOutlet weak var tf_category: UITextField!
    @IBOutlet weak var tf_subCategory: UITextField!
    @IBOutlet weak var tf_size: UITextField!
    @IBOutlet weak var tf_colour: UITextField!
    @IBOutlet weak var tf_condition: UITextField!
    @IBOutlet weak var tf_estimatedPrice: UITextField!
    @IBOutlet weak var tv_styleOrNameOfItem: UITextView!
    @IBOutlet weak var lbl_numberOfItem: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
    }
    
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.view.frame.size.width, height: 650)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_back(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        dismiss(animated: true, completion: nil)
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
        else if btn_tag == 3 {
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
            ary_pickerData = ["New","Pre-Loved"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Condition")
            self.progressHUD.removeFromSuperview()

        }
        else if btn_tag == 7 {
            ary_pickerData = ["$20 - $50","$50 - $100","$100 - $200","$200 - $300","$300 - $400","$400 - $500","> $500"]
            self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Price Range")
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
                if value != nil{
                    self.tf_subCategory.text = "\(value!)"
                }
            }
            else if btn_tag == 4 {
                if value != nil{
                    self.tf_size.text = "\(value!)"
                }
            }
            else if btn_tag == 5 {
                if value != nil{
                    self.tf_colour.text = "\(value!)"
                }
            }
            else if btn_tag == 6 {
                if value != nil{
                    self.tf_condition.text = "\(value!)"
                }
            }
            else if btn_tag == 7 {
                if value != nil{
                    self.tf_estimatedPrice.text = "\(value!)"
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
    
    @IBAction func btn_addItemToDrop(_ sender: Any) {
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
        else if tf_estimatedPrice.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Price Range")
        }
        else if tv_styleOrNameOfItem.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter your Style or Name")
        }
        else{
            addItem(brand: tf_brand.text!, category: tf_category.text!, subCategory: tf_subCategory.text!, size: tf_size.text!, colour: tf_colour.text!, condition: tf_condition.text!, price: tf_estimatedPrice.text!, description: tv_styleOrNameOfItem.text!)
        }
    }
    
    var ary_dropBag : Array<Any>! = []

    func addItem(brand: String, category: String, subCategory: String, size: String, colour: String, condition: String, price: String, description: String)  {
        
        var dic_dropBag = Dictionary<AnyHashable, Any>()
        dic_dropBag["brand"] = brand
        dic_dropBag["category"] = category
        dic_dropBag["subCategory"] = subCategory
        dic_dropBag["size"] = size
        dic_dropBag["colour"] = colour
        dic_dropBag["condition"] = condition
        dic_dropBag["price"] = price
        dic_dropBag["description"] = description
        ary_dropBag.append(dic_dropBag)
        print("ary drob bag == \(ary_dropBag!)")
        
        lbl_numberOfItem.text = "\(ary_dropBag!.count)"
        
        tf_brand.text = ""
        tf_category.text = ""
        tf_subCategory.text = ""
        tf_size.text = ""
        tf_colour.text = ""
        tf_condition.text = ""
        tf_estimatedPrice.text = ""
        tv_styleOrNameOfItem.text = ""
    }
    
    
    @IBAction func btn_next(_ sender: Any) {
        if ary_dropBag.count == 0 {
            showDialog(vc: self, title: "Error!", message: "Your Drop Bag is empty please add at least one item.")
        }
        else{
            self.performSegue(withIdentifier: "SubmitDropVC", sender: nil)
        }
    }
    
    @IBAction func btn_cancel(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SubmitDropVC" {
            let lvc = segue.destination as! SubmitDropVC
            lvc.ary_dropBags = ary_dropBag!
        }
        
    }
    
    
    

}
