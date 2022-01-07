//
//  EarnRevardVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/29/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class EarnRevardVC: UIViewController {
    
    @IBOutlet weak var tf_email1: UITextField!
    @IBOutlet weak var tf_email2: UITextField!
    @IBOutlet weak var tf_email3: UITextField!
    @IBOutlet weak var tf_email4: UITextField!
    @IBOutlet weak var tf_email5: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_sendInvitation(_ sender: Any) {
    
        if tf_email1.text!.isEmpty && tf_email2.text!.isEmpty && tf_email3.text!.isEmpty && tf_email4.text!.isEmpty && tf_email5.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter at least one email address")
        }
        else if !isValidEmail(testStr: tf_email1.text!) {
            showDialog(vc: self, title: NSLocalizedString("error_title", comment: ""), message: "The email address <\(tf_email1.text!)> that you have specified is invalid")
        }
        else if !isValidEmail(testStr: tf_email2.text!) && !tf_email2.text!.isEmpty {
            showDialog(vc: self, title: NSLocalizedString("error_title", comment: ""), message: "The email address <\(tf_email2.text!)> that you have specified is invalid")
        }
        else if !isValidEmail(testStr: tf_email3.text!) && !tf_email3.text!.isEmpty {
            showDialog(vc: self, title: NSLocalizedString("error_title", comment: ""), message: "The email address <\(tf_email3.text!)> that you have specified is invalid")
        }
        else if !isValidEmail(testStr: tf_email4.text!) && !tf_email4.text!.isEmpty{
            showDialog(vc: self, title: NSLocalizedString("error_title", comment: ""), message: "The email address <\(tf_email4.text!)> that you have specified is invalid")
        }
        else if !isValidEmail(testStr: tf_email5.text!) && !tf_email5.text!.isEmpty{
            showDialog(vc: self, title: NSLocalizedString("error_title", comment: ""), message: "The email address <\(tf_email5.text!)> that you have specified is invalid")
        }
        else{
            API_sendInvitaion(email1: tf_email1.text!, email2: tf_email2.text, email3: tf_email3.text, email4: tf_email4.text, email5: tf_email5.text)
        }
    
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    func API_sendInvitaion(email1 :String, email2 :String?, email3 :String?, email4 :String?, email5 :String?)  {
        
        self.view.endEditing(true)
        
        let ary_email:Array = [email1, email2, email3, email4, email5]
        API_sendEmail(userList: ary_email as! Array<String>)
        for email in ary_email {
            if email != "" {
                let inviteQ = PFObject(className:"RewardsInvite")
                inviteQ["fromUser"] = PFUser.current()!
                inviteQ["toUser"] = email
                
                inviteQ.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("data save successfully.. ")
                    }
                    else {
                        // There was a problem, check error.description
                        print("data not save successfully.. ")
                    }
                }
            }
        }
        
    }
    
    func API_sendEmail(userList: Array<String>)  {
        self.view.addSubview(progressHUD)
        let user = PFUser.current()!
        
        //print("user== \(user)\nlist == \(userList)")
        
        PFCloud.callFunction(inBackground: "sendInvitation", withParameters: ["fromUser":user.email!,"firstName": user["firstName"]!,"lastName":user["lastName"]!, "toUser":userList]) { (response, error) in
            if error == nil {
                print("response == \(response!)")
                if Int((response! as! Dictionary)["status"]!)! == 1 {
                    //showDialog(vc: self, title: "", message: "\((responce! as! Dictionary<String, String>)["msg"]!)")
                    showDialogAndBack(vc: self, title: "", message: "\((response! as! Dictionary<String, String>)["msg"]!)", btn_Name: "OK")
                    //self.tv_feedback.text = ""
                    //self.tf_brand.text = ""
                    self.progressHUD.removeFromSuperview()
                    self.tf_email1.text = ""
                    self.tf_email2.text = ""
                    self.tf_email3.text = ""
                    self.tf_email4.text = ""
                    self.tf_email5.text = ""
                }
            }
            else{
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
        }
        
    }

    
    
    @IBAction func btn_back(_ sender: Any) {
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
//        for aViewController in viewControllers {
//            if(aViewController is OptionsVC){
//                self.navigationController!.popToViewController(aViewController, animated: true);
//            }
//        }
        
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

