//
//  EditAddressVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/18/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0

class EditAddressVC: UIViewController {
    
    @IBOutlet weak var tf_firstName: UITextField!
    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_streetAddress: UITextField!
    @IBOutlet weak var tf_suburb: UITextField!
    @IBOutlet weak var lbl_state: UILabel!
    @IBOutlet weak var tf_postCode: UITextField!
    @IBOutlet weak var bool_saveAsDefault: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    func updateUI() {
        
        let user = PFUser.current()!
        
        // PERSONAL DETAIL
        
        if let firstName :String = user["firstName"] as? String {
            tf_firstName.text = firstName
        }
        if let lastName :String = user["lastName"] as? String {
            tf_lastName.text = lastName
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
        
    }

    var ary_state = ["New South Wales","Northern Territory","Queensland","South Australia","Tasmania","Victoria","Western Australia"]
    
    @IBAction func btn_change(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select Brand", rows: ary_state, initialSelection: 0, doneBlock: {
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
    
    @IBAction func btn_update(_ sender: Any) {
        
        self.view.endEditing(true)
        
        API_update(firstName: tf_firstName.text, lastName: tf_lastName.text, streetAddress: tf_streetAddress.text, suburb: tf_suburb.text, state: lbl_state.text, postCode: tf_postCode.text)
    }
    func API_update(firstName :String?, lastName :String?, streetAddress :String?, suburb :String?, state :String?, postCode :String?) {
        
        if let user = PFUser.current() {
            user["firstName"] = firstName
            user["lastName"] = lastName
            user["address"] = streetAddress
            user["suburb"] = suburb
            user["state"] = state
            user["postCode"] = postCode
            user.saveInBackground()
        }
    }
    
    @IBAction func btn_back(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
