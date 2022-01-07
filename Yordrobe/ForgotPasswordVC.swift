//
//  ForgotPasswordVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/19/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var tf_email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let progressHUD = ProgressHUD(text: "Loading..")
    
    @IBAction func btn_resetPassword(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if tf_email.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter and submit your email address to reset your password")
        }
        else{
            
            self.view.addSubview(progressHUD)
            // convert the email string to lower case
            let emailToLowerCase = tf_email.text?.lowercased()
            // remove any whitespaces before and after the email address
            //let emailClean = emailToLowerCase?.trimmingCharacters(in: CharacterSet.whitespaces)
            
            PFUser.requestPasswordResetForEmail(inBackground: emailToLowerCase!) { (success, error) -> Void in
                if (error == nil) {
                    showDialog(vc: self, title: "Password Reset for Yordrobe", message: "Success. An email has been sent to you with instructions for resetting your password")
                    print("success")
                    self.tf_email.text = ""
                    
                }else {
                    showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                    
                }
                self.progressHUD.removeFromSuperview()
            }
        }
    }

    @IBAction func btn_back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
