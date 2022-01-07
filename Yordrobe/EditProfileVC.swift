//
//  EditProfileVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/28/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0


class EditProfileVC: UIViewController {

    @IBOutlet weak var scrl_main: UIScrollView!
    
    @IBOutlet weak var tf_userName: UITextField!
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_emailId: UITextField!
    @IBOutlet weak var tf_paypalEmail: UITextField!
    @IBOutlet weak var tf_phoneNumber: UITextField!
    
    @IBOutlet weak var tf_streetAddress: UITextField!
    @IBOutlet weak var tf_suburb: UITextField!
    @IBOutlet weak var lbl_state: UILabel!
    @IBOutlet weak var tf_postCode: UITextField!
    
    @IBOutlet weak var lbl_dressSize: UILabel!
    @IBOutlet weak var lbl_shoeSize: UILabel!
    
    @IBOutlet weak var btn_mail: UIButton!
    @IBOutlet weak var btn_femail: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        btn_resetPassword.setAttributedTitle(NSMutableAttributedString(string: btn_resetPassword.currentTitle!, attributes: btn_golden_atribute), for: .normal)
        btn_changes.setAttributedTitle(NSMutableAttributedString(string: btn_changes.currentTitle!, attributes: btn_golden_atribute), for: .normal)
        
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
        
        
    }

    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width:self.view.frame.size.width, height:820)
        updateUI()
    }
    
    var str_gender: String? = ""
    
    
    func updateUI() {
        
        let user = PFUser.current()!
        
        // PERSONAL DETAIL
        
        if let username = user.username {
            tf_userName.text = username
        }
        if let firstName :String = user["firstName"] as? String {
            tf_firstName.text = firstName
        }
        if let lastName :String = user["lastName"] as? String {
            tf_lastName.text = lastName
        }
        if let email :String = user["email"] as? String {
            tf_emailId.text = email
        }
        if let paypalemail :String = user["paypalEmail"] as? String {
            tf_paypalEmail.text = paypalemail
        }
        if let phoneNumber :String = user["phoneNumber"] as? String {
            tf_phoneNumber.text = phoneNumber
        }
        if let gender :String = user["gender"] as? String {
            str_gender = gender
            if str_gender == "Male" {
            btn_mail.backgroundColor = clr_golden
            btn_mail.setTitleColor( .white, for: .normal)
            
            btn_femail.backgroundColor = UIColor.white
            btn_femail.setTitleColor(clr_golden, for: .normal)
        }
            else {
                btn_femail.backgroundColor = clr_golden
                btn_femail.setTitleColor( .white, for: .normal)
                
                btn_mail.backgroundColor = UIColor.white
                btn_mail.setTitleColor(clr_golden, for: .normal)
            }
        }
        //  SHIPPING ADDRESS
        
        if let streetAddress :String = user["address"] as? String {
            tf_streetAddress.text = streetAddress
        }
        if let suburb :String = user["suburb"] as? String {
            tf_suburb.text = suburb
        }
        if let state :String = user["state"] as? String {
            if state != "" {
                lbl_state.textColor = UIColor.black
                lbl_state.text = state
            }
            
        }
        if let postCode :String = user["postCode"] as? String {
            tf_postCode.text = postCode
        }
        
        //  PREFRENCES
        
        if let dressSize :String = user["dressSize"] as? String {
            if dressSize != "" {
                lbl_dressSize.textColor = UIColor.black
                lbl_dressSize.text = dressSize
            }
            
        }
        if let shoeSize :String = user["shoeSize"] as? String {
            if shoeSize != "" {
                lbl_shoeSize.textColor = UIColor.black
                lbl_shoeSize.text = shoeSize
            }
            
        }
        
    }

    @IBAction func btn_gender(_ sender: UIButton) {
        
        if sender.tag == 1  {
            str_gender = "Male"
            btn_mail.backgroundColor = clr_golden
            btn_mail.setTitleColor( .white, for: .normal)
            
            btn_femail.backgroundColor = UIColor.white
            btn_femail.setTitleColor(clr_golden, for: .normal)
        }
        else if sender.tag == 2 {
            str_gender = "Female"
            btn_femail.backgroundColor = clr_golden
            btn_femail.setTitleColor( .white, for: .normal)
            
            btn_mail.backgroundColor = UIColor.white
            btn_mail.setTitleColor(clr_golden, for: .normal)
            
        }
    }
    
    
    
    @IBOutlet weak var btn_resetPassword: UIButton!
    @IBAction func btn_resetPassword(_ sender: Any) {
       // self.performSegue(withIdentifier: "resetPassword", sender: nil)
        
        self.view.addSubview(progressHUD)
        // convert the email string to lower case
        let emailToLowerCase = PFUser.current()?.email?.lowercased()
        // remove any whitespaces before and after the email address
        //let emailClean = emailToLowerCase?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        PFUser.requestPasswordResetForEmail(inBackground: emailToLowerCase!) { (success, error) -> Void in
            if (error == nil) {
                showDialog(vc: self, title: "Password Reset for Yordrobe", message: "Success. An email has been sent to you with instructions for resetting your password")
            }else {
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                
            }
            self.progressHUD.removeFromSuperview()
        }

    }
    
    @IBOutlet weak var btn_changes: UIButton!
    var ary_state = ["New South Wales","Northern Territory","Queensland","South Australia","Tasmania","Victoria","Western Australia"]
    
    
    
    @IBAction func btn_selectSize(_ sender: UIButton) {
        getData(btn_tag: sender.tag)
    }
    
    
    let progressHUD = ProgressHUD(text: "Loading..")
    var ary_size :Array! = []
    func getData(btn_tag:Int)
    {
        self.view.addSubview(progressHUD)
        ary_size.removeAll()
        var query = PFQuery()
        if btn_tag == 1
        {
            query = PFQuery(className:"SizeRanges")
            query.whereKey("Context", equalTo: "clothing")
        }
        else if btn_tag == 2
        {
            query = PFQuery(className:"SizeRanges")
            query.whereKey("Context", equalTo: "shoes")
        }
        query.findObjectsInBackground
            {
            (objects:[PFObject]?, error:Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                //progressHUD.removeFromSuperview()
                self.progressHUD.removeFromSuperview()
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //print(object.value(forKey: "Name")!)
                        self.ary_size.append("\(object["Range"]!)")
                    }
                    self.openPicker(btn_tag: btn_tag, row: self.ary_size)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func openPicker(btn_tag:Int, row: Array<Any>)
    {
        ActionSheetStringPicker.show(withTitle: "Select Brand", rows: row, initialSelection: 0, doneBlock: {
            picker, index, value in
            
            if btn_tag == 1 {
                self.lbl_dressSize.text = "\(value!)"
                self.lbl_dressSize.textColor = UIColor.black
            }
            else if btn_tag == 2 {
                self.lbl_shoeSize.text = "\(value!)"
                self.lbl_shoeSize.textColor = UIColor.black
            }
            print("index = \(index)")
            print("value = \(String(describing: value!))")
            //print("picker = \(String(describing: picker))")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
    }
    
    @IBAction func btn_changes(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "State", rows: ary_state, initialSelection: 0, doneBlock: {
            picker, index, value in
            
            if "\(value!)" == "New South Wales" {
                self.lbl_state.text = "NSW"
            }
            else if "\(value!)" == "Northern Territory" {
                self.lbl_state.text = "NT"
            }
            else if "\(value!)" == "Queensland" {
                self.lbl_state.text = "QLD"
            }
            else if "\(value!)" == "South Australia" {
                self.lbl_state.text = "SA"
            }
            else if "\(value!)" == "Tasmania" {
                self.lbl_state.text = "TAS"
            }
            else if "\(value!)" == "Victoria" {
                self.lbl_state.text = "VIC"
            }
            else if "\(value!)" == "Western Australia" {
                self.lbl_state.text = "WA"
            }
            self.lbl_state.textColor = UIColor.black
            print("index = \(index)")
            print("value = \(String(describing: value!))")
            //print("picker = \(String(describing: picker))")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
    }

    
    @IBAction func btn_update(_ sender: Any)
        
    {
        self.view.endEditing(true)
        let state = lbl_state.text == "State" ? "" : lbl_state.text
        let dressSize = lbl_dressSize.text == "Dress Size" ? "" : lbl_dressSize.text
        let shoeSize = lbl_shoeSize.text == "Shoe Size" ? "" : lbl_shoeSize.text
        API_update(userName: tf_userName.text, firstName: tf_firstName.text, lastName: tf_lastName.text, email: tf_emailId.text, paypalEmail: tf_paypalEmail.text, phoneNumber: tf_phoneNumber.text, gender: str_gender, streetAddress: tf_streetAddress.text, suburb: tf_suburb.text, state: state, postCode: tf_postCode.text, dressSize: dressSize, shoeSize: shoeSize)
    }
    
    func API_update(userName :String?, firstName :String?, lastName :String?, email :String?, paypalEmail :String?, phoneNumber :String?, gender :String?, streetAddress :String?, suburb :String?, state :String?, postCode :String?, dressSize :String?, shoeSize :String?) {
        self.view.addSubview(progressHUD)
        if let user = PFUser.current() {
            user.username = userName
            user["firstName"] = firstName
            user["lastName"] = lastName
            user.email = email
            user["paypalEmail"] = paypalEmail
            user["phoneNumber"] = phoneNumber
            user["gender"] = gender
            user["address"] = streetAddress
            user["suburb"] = suburb
            user["state"] = state
            user["postCode"] = postCode
            user["dressSize"] = dressSize
            user["shoeSize"] = shoeSize
            user.saveInBackground(block: { (sucees, error) in
                if error == nil {
                    if sucees == true {
                        showDialogAndBack(vc: self, title: "Done!", message: "Profile Updated Successfully", btn_Name: nil)
                    }
                }
                else{
                    showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                }
                self.progressHUD.removeFromSuperview()
            })
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
