//
//  ResetPasswordVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 10/26/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import PassKit

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var tf_currentPassword: UITextField!
    @IBOutlet weak var tf_newPassword: UITextField!
    @IBOutlet weak var tf_confirmPassword: UITextField!
   
    let user = PFUser()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btn_submit(_ sender: Any) {
        
        if tf_newPassword.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please Enter your new Password")
        }
        else  if tf_confirmPassword.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please Confirm your new Password")
        }
        else  if tf_confirmPassword.text! != tf_newPassword.text! {
            showDialog(vc: self, title: "Error!", message: "Your Password Does not Match")
        }
        else{
            user.password = tf_newPassword.text
            user.saveInBackground()
        }
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
