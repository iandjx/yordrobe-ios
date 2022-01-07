//
//  UploadItemVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/2/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Parse
import PopupDialog

class UploadItemVC: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrl_main: UIScrollView!
    
    @IBOutlet weak var btn_image1: BorderButton!
    @IBOutlet weak var btn_image2: BorderButton!
    @IBOutlet weak var btn_image3: BorderButton!
    @IBOutlet weak var btn_image4: BorderButton!
    
    @IBOutlet weak var lbl_brand: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_subCategory: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var lbl_colour: UILabel!
    @IBOutlet weak var lbl_section: UILabel!
    
    @IBOutlet weak var tf_price: UITextField!
    @IBOutlet weak var tf_standardCost: UITextField!
    @IBOutlet weak var tf_expressCost: UITextField!
    @IBOutlet weak var tv_description: UITextView!

    var dic_product: PFObject!
    
    @IBOutlet weak var sw_freeShipping: UISwitch!
    @IBOutlet weak var sw_standard: UISwitch!
    @IBOutlet weak var sw_expressCost: UISwitch!
    @IBOutlet weak var sw_postToFB: UISwitch!
    
    var isSale:Bool! = false
    
    // delete item 
    @IBOutlet weak var btn_deleteItem: UIButton!
    @IBAction func btn_deleteItem(_ sender: Any)
    {
        let popup = PopupDialog(title: "Delete?", message: "Are you sure you want to delete this item?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        let yes = DefaultButton(title: "Confirm") {
            self.API_deleteItem()
        }
        let no = CancelButton(title: "No Thanks") {
        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
        
        
        if let productDetail = dic_product {
            print("productDetail  \(productDetail)")
            updateUI()
            btn_deleteItem.isHidden = false
        }
        else{
            btn_deleteItem.isHidden = true
        }
        
        if isSale == true {
            btn_shippingGuide.isHidden = false
        }
        else{
            btn_shippingGuide.isHidden = true
        }
        
        tf_standardCost.isEnabled = false
        tf_expressCost.isEnabled = false
        
        btn_preLoved.backgroundColor = clr_golden
        btn_preLoved.setTitleColor(.white, for: .normal)
    }
    
    @IBOutlet weak var btn_upload: UIButton!
    
    func updateUI() {
        
        print("product detail == \(dic_product!)")
        
        btn_upload.setTitle("UPDATE", for: .normal)
        
        let coverImageFile = dic_product!["CoverImage"]! as! PFFileObject
        coverImageFile.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
            let image = UIImage(data: imageData!)
            if image != nil {
                //cell.img_product.image = image
                self.btn_image1.setBackgroundImage(image, for: .normal)
                self.btn_image1.setTitle(nil, for: .normal)
            }
        })
        
        if let image2 = dic_product!["Image2"] {
            (image2 as! PFFileObject).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.btn_image2.setBackgroundImage(image, for: .normal)
                    self.btn_image2.setTitle(nil, for: .normal)
                }
            })
        }
        if let image3 = dic_product!["Image3"] {
            (image3 as! PFFileObject).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.btn_image3.setBackgroundImage(image, for: .normal)
                    self.btn_image3.setTitle(nil, for: .normal)
                }
            })
        }
        if let image4 = dic_product!["Image4"] {
            (image4 as! PFFileObject).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.btn_image4.setBackgroundImage(image, for: .normal)
                    self.btn_image4.setTitle(nil, for: .normal)
                }
            })
        }
        
        if let type = dic_product!["Condition"]
        {
            if type as! String == "Pre-Loved"
            {
                condition = "Pre-Loved"
                btn_preLoved.backgroundColor = clr_golden
                btn_preLoved.setTitleColor(.white, for: .normal)
            }
            else
            {
                condition = "New"
                btn_new.backgroundColor = clr_golden
                btn_new.setTitleColor(.white, for: .normal)
            }
        }
        if (dic_product["Brand"]) != nil {
            lbl_brand.text = "\(dic_product!["Brand"]!)"
        }
        else {
            lbl_brand.text = "\(dic_product!["brand"]!)"
        }
        lbl_brand.textColor = UIColor.darkGray
        lbl_category.text = "\(dic_product!["Category"]!)"
        lbl_category.textColor = UIColor.darkGray
        
        if let sub_category = dic_product!["SubCategory"]
            
        {
            lbl_subCategory.text = "\(sub_category)"
            lbl_subCategory.textColor = UIColor.darkGray
        }
        
        lbl_size.text = "\(dic_product!["Size"]!)"
        lbl_size.textColor = UIColor.darkGray
        lbl_colour.text = "\(dic_product!["Colour"]!)"
        lbl_colour.textColor = UIColor.darkGray
        lbl_section.text = "\(dic_product!["Section"]!)"
        lbl_section.textColor = UIColor.darkGray
        tv_description.text = "\(dic_product!["Description"]!)"
        tf_price.text = "\(dic_product!["Price"]!)"
        sw_freeShipping.setOn(dic_product!["FreeShipping"] as! Bool, animated: false)
        sw_standard.setOn(dic_product!["Standard"] as! Bool, animated: false)
        sw_expressCost.setOn(dic_product!["Express"] as! Bool, animated: false)
        sw_postToFB.setOn(dic_product!["PostToFB"] as! Bool, animated: false)
        tf_standardCost.text = "\(dic_product!["StandardCost"]!)"
        tf_expressCost.text = "\(dic_product!["ExpresCost"]!)"
    }
    
    func API_deleteItem() -> Void
    {
        self.view.addSubview(progressHUD)
        let item = PFQuery(className:"Item")
        item.whereKey("objectId", equalTo: dic_product!.objectId!)
        
        item.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // Do something
                    //object.deleteEventually()
                    object.deleteInBackground(block: { (deleted, error) in
                        if error == nil {
                            if deleted == true {
                                showDialogAndBack(vc: self, title: "Deleted", message: "Your Item has been deleted successfully", btn_Name: "OK")
                            }
                        }
                        else{
                            showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                        }
                    })
                }
            } else {
                // There was a problem, check error.description
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    
    
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.scrl_main.frame.size.width, height: 860)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var btn_preLoved: BorderButton!
    @IBOutlet weak var btn_new: BorderButton!
    
    var condition = "Pre-Loved"
    
    @IBAction func btn_preLoved(_ sender: Any) {
        
        condition = "Pre-Loved"
        
        btn_preLoved.backgroundColor = clr_golden
        btn_preLoved.setTitleColor(.white, for: .normal)
        
        btn_new.backgroundColor = UIColor.white
        btn_new.setTitleColor(clr_golden, for: .normal)

        
    }
    
    @IBAction func btn_new(_ sender: Any) {
        
        condition = "New"
        
        btn_preLoved.backgroundColor = UIColor.white
        btn_preLoved.setTitleColor(clr_golden, for: .normal)
        
        btn_new.backgroundColor = clr_golden
        btn_new.setTitleColor( .white, for: .normal)
        
    }
    
    
    var ary_brand = [String]()
    let progressHUD = ProgressHUD(text: "Loading..")

    @IBAction func btn_addSection(_ sender: Any) {
        
        showCustomDialog()
    }
    
    // Create a custom view controller
    let SectionVC = SectionPopUp(nibName: "SectionPopUp", bundle: nil)
    
    func showCustomDialog() {
        
        // Create the dialog
        let popup = PopupDialog(viewController: SectionVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true, panGestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "DONE", height: 60) {
            
            if self.SectionVC.tf_sectionName.text!.isEmpty {
                showDialog(vc: self, title: "Error!", message: "Please Enter Your Wardrobe Name")
            }
            else{
                self.createSection()
            }
    }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        // Present dialog
        present(popup, animated: true, completion: nil)
    }

    func createSection()  {
        
        let section = PFObject(className:"Section")
        section["Name"] = self.SectionVC.tf_sectionName.text!
        section["User"] = PFUser.current()
        section.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
            } else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
            }
        }
    }
    
    
    @IBAction func btn_select(_ sender: UIButton) {
        
        if sender.tag == 3 {
            if lbl_category.text! == "Category" {
                showDialog(vc: self, title: "Error!", message: "Please select a category first")
            }
            else{
                getData(btn_tag: sender.tag)
            }
        }
        else{
            getData(btn_tag: sender.tag)
        }
        
    }
    
    
    var ary_pickerData: Array! = []
    
    func getData(btn_tag:Int)  {
        
        self.view.addSubview(progressHUD)
        ary_pickerData.removeAll()
        
        if btn_tag == 1  {
            getPickerData(btn_tag: btn_tag, keyValue: "", Vc: self, completionHandler: { result -> Void in
                print(result)
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Brand")
                self.progressHUD.removeFromSuperview()
                
            })
        }
            
        else if btn_tag == 2 {
            getPickerData(btn_tag: btn_tag, keyValue:lbl_brand.text!, Vc: self, completionHandler: { result -> Void in
                for index in result {
//                    if let category_name = (index as! PFObject)["category"] as? PFObject {
//                        let name = [category_name["Name"]]
//                    self.ary_pickerData.append("\(name)")
                    self.ary_pickerData.append("\(((index as! PFObject)["category"]! as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Category")
                self.progressHUD.removeFromSuperview()
                })
        }
        else if btn_tag == 3 {
            getPickerData(btn_tag: btn_tag, keyValue:lbl_category.text!, Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["SubCategoryName"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Sub Category")
                self.progressHUD.removeFromSuperview()
                
            })
        }
        else if btn_tag == 4
        {
            getPickerData(btn_tag: btn_tag, keyValue:lbl_category.text!, Vc: self, completionHandler: { result -> Void in
                for index in result
                {
                    self.ary_pickerData.append("\(((index as! PFObject)["size"]! as! PFObject)["Size"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Size")
                self.progressHUD.removeFromSuperview()
            })
        }
        else if btn_tag == 5
        {
            getPickerData(btn_tag: btn_tag, keyValue:"", Vc: self, completionHandler: { result -> Void in
                for index in result {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Colour")
                self.progressHUD.removeFromSuperview()
            })
        }
        else if btn_tag == 6
        {
            getPickerData(btn_tag: btn_tag, keyValue:"", Vc: self, completionHandler: { result -> Void in
                for index in result
                {
                    self.ary_pickerData.append("\((index as! PFObject)["Name"]!)")
                }
                self.openPicker(btn_tag: btn_tag, row: self.ary_pickerData, title: "Wardrobe")
                self.progressHUD.removeFromSuperview()
            })
        }
    }
    
    func openPicker(btn_tag:Int, row: Array<Any>, title: String)
    {
        ActionSheetStringPicker.show(withTitle: title, rows: row, initialSelection: 0, doneBlock: {
            picker, index, value in
            if btn_tag == 1 {
                if let _value = value {
                    self.lbl_brand.text = "\(_value)"
                    self.lbl_brand.textColor = UIColor.darkGray
                }
            }
            else if btn_tag == 2 {
                if let _value = value {
                    self.lbl_category.text = "\(_value)"
                    self.lbl_category.textColor = UIColor.darkGray
                }
            }
            else if btn_tag == 3 {
                if let _value = value {
                    self.lbl_subCategory.text = "\(_value)"
                    self.lbl_subCategory.textColor = UIColor.darkGray
                }
            }
            else if btn_tag == 4 {
                if let _value = value {
                    self.lbl_size.text = "\(_value)"
                    self.lbl_size.textColor = UIColor.darkGray
                }
            }
            else if btn_tag == 5 {
                if let _value = value {
                    self.lbl_colour.text = "\(_value)"
                    self.lbl_colour.textColor = UIColor.darkGray
                }
            }
            else if btn_tag == 6 {
                if let _value = value {
                    self.lbl_section.text = "\(_value)"
                    self.lbl_section.textColor = UIColor.darkGray
                }
            }
            //print("index = \(index)")
            //print("value = \(String(describing: value!))")
            //print("picker = \(String(describing: picker))")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)

    }
    
    var imagePicker = UIImagePickerController()
    var btn_tag:Int = 0
    
    @IBAction func btn_uploadImage(_ sender: UIButton) {
        btn_tag = sender.tag
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self

        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Choose your option !", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Select from gallery", style: .default) { action -> Void in
            print("gallery")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }

        }
        actionSheetController.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: "Open camera", style: .default) { action -> Void in
            print("Delete")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //imagePreview.image  = tempImage
        
        if btn_tag == 1 {
            btn_image1.setBackgroundImage(tempImage, for: .normal)
            btn_image1.setTitle(nil, for: .normal)
        }
        else if btn_tag == 2 {
            btn_image2.setBackgroundImage(tempImage, for: .normal)
            btn_image2.setTitle(nil, for: .normal)
        }
        else if btn_tag == 3 {
            btn_image3.setBackgroundImage(tempImage, for: .normal)
            btn_image3.setTitle(nil, for: .normal)
        }
        else if btn_tag == 4 {
            btn_image4.setBackgroundImage(tempImage, for: .normal)
            btn_image4.setTitle(nil, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_switch(_ sender: UISwitch) {
        
        print("\(sender.tag)")
        
        if sender.tag == 1 {
            
            if sender.isOn {
                sw_standard.setOn(false, animated: true)
                sw_expressCost.setOn(false, animated: true)
                tf_standardCost.isEnabled = false
                tf_standardCost.text = ""
                tf_expressCost.isEnabled = false
                tf_expressCost.text = ""
            }
        }
        else if sender.tag == 2 {
            sw_freeShipping.setOn(false, animated: true)

            if sender.isOn {
                tf_standardCost.isEnabled = true
            }
            else{
                tf_standardCost.isEnabled = false
                tf_standardCost.text = ""
            }

        }
        else if sender.tag == 3 {
            sw_freeShipping.setOn(false, animated: true)
            
            if sender.isOn {
                tf_expressCost.isEnabled = true
            }
            else{
                tf_expressCost.isEnabled = false
                tf_expressCost.text = ""
            }
        }
        /*
        else if sender.tag == 4 {
            if sender.isOn {
                
            }
            else {
                
            }
        }
         */
    }

    
    func isHasTag(description: String) -> Bool {
        
        let words:[String] = description.components(separatedBy: " ")
        
        for word in words {
            if word.hasPrefix("#") {
                return true
            }
        }
        return false
    }
    
    @IBAction func btn_upload(_ sender: Any) {
        
        let progressHUD = ProgressHUD(text: "Loading..")
        self.view.addSubview(progressHUD)

        if PFUser.current()!["paypalEmail"] == nil || PFUser.current()!["paypalEmail"]! as! String == "" {
            let popup = PopupDialog(title: "Error!", message: "Looks like we don't have your Paypal address on file. We need your PayPal address for payments before you can list an item.", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
                print("Completed")
            }
            let buttonOk = DefaultButton(title: "OK") {
                //self.label.text = "You ok'd the default dialog"
                self.performSegue(withIdentifier: "EditProfileVC", sender: nil)
            }
            // Add buttons to dialog
            popup.addButtons([buttonOk])
            self.present(popup, animated: true, completion: nil)
        }
        else {

        let image1: UIImage? = btn_image1.backgroundImage(for: .normal)
        
        if image1 == nil {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Cover Image")
        }
        else if lbl_brand.text == "Brand" {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Brand")
        }
        else if lbl_category.text == "Category" {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Category")
        }
        else if lbl_size.text == "Size" {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Size")
        }
        else if lbl_colour.text == "Colour" {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Colour")
        }
        else if lbl_section.text == "Wardrobe" {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Wardrobe")
        }
        else if tv_description.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Description")
        }
        else if isHasTag(description: tv_description.text) == false {
            showDialog(vc: self, title: "Error!", message: "Description, #tags, please include at least one hashtag.")
        }
        else if tf_price.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Price")
        }
        else if tf_standardCost.text!.isEmpty && sw_standard.isOn == true {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Standard Cost")
        }
        else if tf_expressCost.text!.isEmpty && sw_expressCost.isOn == true {
            showDialog(vc: self, title: "Error!", message: "Please Enter Your Express Cost")
        }
        else if sw_standard.isOn == false && sw_expressCost.isOn == false && sw_freeShipping.isOn == false {
            showDialog(vc: self, title: "Error!", message: "Please Select Your Shipping Option")
        }
        else if sw_expressCost.isOn == true && sw_standard.isOn == true {
            let image2: UIImage? = btn_image2.backgroundImage(for: .normal)
            let image3: UIImage? = btn_image3.backgroundImage(for: .normal)
            let image4: UIImage? = btn_image4.backgroundImage(for: .normal)
            let subCtegory = lbl_subCategory.text! == "Sub-Category(Optional)" ? "" : lbl_subCategory.text!
                let ExpresCost = Int(tf_expressCost.text!)
                let StandardCost = Int(tf_standardCost.text!)
                if ExpresCost! < StandardCost! {
                    showAlertMessage(vc: self, titleStr: NSLocalizedString("Cost_Error", comment: ""), messageStr: NSLocalizedString("Please Re-Enter Your Express Cost. It must be higher than your Standard Delivery Cost.", comment: ""))
                        }
                else if btn_upload.titleLabel?.text == "UPLOAD" {
                    UploadItem(image1: image1!, Image2: image2, image3: image3, Image4: image4, condition: condition, brand: lbl_brand.text!, category: lbl_category.text!, subCategory: subCtegory, size: lbl_size.text!, colour: lbl_colour.text!, section: lbl_section.text!, description: tv_description.text!, price: Int(tf_price.text!)!, freeShipping: sw_freeShipping.isOn, standard: sw_standard.isOn, standardCost: Int(tf_standardCost.text!.isEmpty ? "0":tf_standardCost.text!)!, express: sw_expressCost.isOn, expressCost: Int(tf_expressCost.text!.isEmpty ? "0": tf_expressCost.text!)!, postToFacebook: sw_postToFB.isOn)
            }
                else {
                    UpdateItem(image1: image1!, Image2: image2, image3: image3, Image4: image4, condition: condition, brand: lbl_brand.text!, category: lbl_category.text!, subCategory: subCtegory, size: lbl_size.text!, colour: lbl_colour.text!, section: lbl_section.text!, description: tv_description.text!, price: Int(tf_price.text!)!, freeShipping: sw_freeShipping.isOn, standard: sw_standard.isOn, standardCost: Int(tf_standardCost.text!.isEmpty ? "0":tf_standardCost.text!)!, express: sw_expressCost.isOn, expressCost: Int(tf_expressCost.text!.isEmpty ? "0": tf_expressCost.text!)!, postToFacebook: sw_postToFB.isOn)
                    }
            }
        else {
            let image2: UIImage? = btn_image2.backgroundImage(for: .normal)
            let image3: UIImage? = btn_image3.backgroundImage(for: .normal)
            let image4: UIImage? = btn_image4.backgroundImage(for: .normal)
            let subCtegory = lbl_subCategory.text! == "Sub-Category(Optional)" ? "" : lbl_subCategory.text!
            if btn_upload.titleLabel?.text == "UPLOAD" {
              UploadItem(image1: image1!, Image2: image2, image3: image3, Image4: image4, condition: condition, brand: lbl_brand.text!, category: lbl_category.text!, subCategory: subCtegory, size: lbl_size.text!, colour: lbl_colour.text!, section: lbl_section.text!, description: tv_description.text!, price: Int(tf_price.text!)!, freeShipping: sw_freeShipping.isOn, standard: sw_standard.isOn, standardCost: Int(tf_standardCost.text!.isEmpty ? "0":tf_standardCost.text!)!, express: sw_expressCost.isOn, expressCost: Int(tf_expressCost.text!.isEmpty ? "0": tf_expressCost.text!)!, postToFacebook: sw_postToFB.isOn)
                        }
            else {
                UpdateItem(image1: image1!, Image2: image2, image3: image3, Image4: image4, condition: condition, brand: lbl_brand.text!, category: lbl_category.text!, subCategory: subCtegory, size: lbl_size.text!, colour: lbl_colour.text!, section: lbl_section.text!, description: tv_description.text!, price: Int(tf_price.text!)!, freeShipping: sw_freeShipping.isOn, standard: sw_standard.isOn, standardCost: Int(tf_standardCost.text!.isEmpty ? "0":tf_standardCost.text!)!, express: sw_expressCost.isOn, expressCost: Int(tf_expressCost.text!.isEmpty ? "0": tf_expressCost.text!)!, postToFacebook: sw_postToFB.isOn)
                    }
                }
            }
        }
    
    
    
    func UpdateItem(image1: UIImage, Image2: UIImage?, image3: UIImage?, Image4: UIImage?, condition: String, brand: String, category: String, subCategory: String, size: String, colour: String, section: String, description: String, price: Int, freeShipping: Bool?, standard: Bool?, standardCost: Int?, express: Bool?, expressCost: Int?, postToFacebook: Bool?) {
        
        self.view.addSubview(progressHUD)
        
        let query = PFQuery(className:"Item")
        query.getObjectInBackground(withId: dic_product.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                if let item = object {
                    item["Condition"] = condition
                    item["Brand"] = brand
                    item["Category"] = category
                    item["SubCategory"] = subCategory
                    item["Size"] = size
                    item["Colour"] = colour
                    item["Section"] = section
                    item["Description"] = description
                    item["Price"] = price
                    item["FreeShipping"] = freeShipping
                    item["Standard"] = standard
                    item["StandardCost"] = standardCost
                    item["Express"] = express
                    item["ExpresCost"] = expressCost
                    item["PostToFB"] = postToFacebook
                    item["Owner"] = PFUser.current()
                    
                    let file_coverImage = PFFileObject(data: image1.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
                    item["CoverImage"] = file_coverImage
                    
                    if let image = Image2 {
                        let file_image2 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
                        item["Image2"] = file_image2
                        
                    }
                    if let image = image3 {
                        let file_image3 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
                        item["Image3"] = file_image3
                        
                    }
                    if let image = Image4 {
                        let file_image4 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
                        item["Image4"] = file_image4
                        
                    }

                }
                //object!.saveInBackground()
                object?.saveInBackground(block: { (isSaved, error) in
                    if error == nil {
                        if isSaved == true {
                            showDialogAndBack(vc: self, title: "Done!", message: "Your item has been updated successfully", btn_Name: "OK")
                        }
                    }
                    else{
                        showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                    }
                })
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    func UploadItem(image1: UIImage, Image2: UIImage?, image3: UIImage?, Image4: UIImage?, condition: String, brand: String, category: String, subCategory: String, size: String, colour: String, section: String, description: String, price: Int, freeShipping: Bool?, standard: Bool?, standardCost: Int?, express: Bool?, expressCost: Int?, postToFacebook: Bool?)
    
    {
        
        self.view.addSubview(progressHUD)
        print("free shipping = \(freeShipping!)\n standrad == \(standard!)")
        let item = PFObject(className:"Item")
        item["Condition"] = condition
        item["Brand"] = brand
        item["Category"] = category
        item["SubCategory"] = subCategory
        item["Size"] = size
        item["Colour"] = colour
        item["Section"] = section
        item["Description"] = description
        item["Price"] = price
        item["FreeShipping"] = freeShipping
        item["Standard"] = standard
        item["StandardCost"] = standardCost
        item["Express"] = express
        item["ExpresCost"] = expressCost
        item["PostToFB"] = postToFacebook
        item["Owner"] = PFUser.current()
        
        let file_coverImage = PFFileObject(data: image1.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
        item["CoverImage"] = file_coverImage
        
        if let image = Image2 {
            let file_image2 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
            item["Image2"] = file_image2
        }
        if let image = image3 {
            let file_image3 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
            item["Image3"] = file_image3
        }
        if let image = Image4 {
            let file_image4 = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
            item["Image4"] = file_image4
        }
        
        item.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                if self.sw_postToFB.isOn == true {
                    self.askToPostOnFacebook(postString: " Brand:\(brand) Category:\(category) Description:\(description) Price:\(price)", message: "Your item uploaded successfully.", productImage: image1)
                }
                else{
                    showDialogAndBack(vc: self, title: "Done!", message: "Your item uploaded successfully.", btn_Name: "OK")
                }
                /*
                self.btn_image1.setBackgroundImage(nil, for: .normal)
                self.btn_image2.setBackgroundImage(nil, for: .normal)
                self.btn_image3.setBackgroundImage(nil, for: .normal)
                self.btn_image4.setBackgroundImage(nil, for: .normal)
                */
            }
                
            else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
        
        //
    }
    
    func askToPostOnFacebook(postString: String, message: String, productImage : UIImage) {
        let popup = PopupDialog(title: message, message: "Would you like to share this item with your friends?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        let yes = DefaultButton(title: "Yes") {
            //self.label.text = "You ok'd the default dialog"
            self.PostToFacebook(text:postString, profuctImage: productImage)
        }
        let no = CancelButton(title: "No Thanks") {
            //self.label.text = "You ok'd the default dialog"
            if let navigationController = self.navigationController {
                if navigationController.viewControllers.count > 1 {
                    navigationController.popViewController(animated: true)
                    return
                }
            }
            self.dismiss(animated: true, completion: nil)

        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
        
    }

    
    func PostToFacebook(text: String, profuctImage: UIImage) {
        
        let url = "https://itunes.apple.com/au/app/yordrobe/id802864021?mt=8"
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [text,profuctImage,url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        //self.present(activityViewController, animated: true, completion: nil)
        
        self.present(activityViewController, animated: true) {
            if let navigationController = self.navigationController {
                if navigationController.viewControllers.count > 1 {
                    navigationController.popViewController(animated: true)
                    return
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    

    

    @IBAction func btn_back(_ sender: UIButton) {
        
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var btn_shippingGuide: UIButton!
    
    @IBAction func btn_shippingCostGuide(_ sender: Any) {
        self.performSegue(withIdentifier: "shippingGuide", sender: nil)
    }
    
    
    
}
