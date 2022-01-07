//
//  FeedbackVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/11/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class FeedbackVC: UIViewController {

    @IBOutlet weak var tv_feedback: UITextView!
    @IBOutlet weak var tf_brand: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_submitFeedback(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if tv_feedback.text!.isEmpty && tf_brand.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please enter a general feedback comment or request a specific clothing brand")
        }
        else{
            API_feedback(brand: tf_brand.text, feedback: tv_feedback.text)
        }
        
        
    }
    
    func API_feedback(brand: String?, feedback: String?)  {
        
        let user = PFUser.current()!
        
        PFCloud.callFunction(inBackground: "feedBack", withParameters: ["userID":user.objectId!,"userEmail":user.email!,"userName":user.username!,"brand":"","comment":""]) { (responce, error) in
            if error == nil {
                print("responce == \(responce!)")
                if Int((responce! as! Dictionary)["status"]!)! == 1 {
                    showDialog(vc: self, title: "", message: "\((responce! as! Dictionary<String, String>)["msg"]!)")
                    self.tv_feedback.text = ""
                    self.tf_brand.text = ""
                }
            }
            else{
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
        }
        
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
