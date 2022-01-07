//
//  SignUpVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/17/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_firstName: UITextField!

    @IBOutlet weak var tf_lastName: UITextField!
    @IBOutlet weak var tf_userName: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_confirmPassword: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    
    @IBOutlet weak var btn_termsAndCondition: UIButton!
    
    @IBOutlet weak var scrl_main: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btn_termsAndCondition.setAttributedTitle(NSMutableAttributedString(string: "Terms & Conditions", attributes: btn_forgotPwd_atribute), for: .normal)
        
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
        
        // avoiding special characters
        tf_userName.delegate = self
        tf_userNameFb.delegate = self
        //
        view_userName.isHidden = true
        view_userName.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    @objc func adjustScroll()
        
    {
        scrl_main.contentSize = CGSize(width: self.view.frame.size.width, height: 568)
    }

    override func didReceiveMemoryWarning()
    
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    
    @IBAction func btn_signUp(_ sender: Any) {
        
        if tf_firstName.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_firstName", comment: "user din not input first name"))
        }
        else if tf_lastName.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_LastName", comment: "user din not input last name"))
        }
        else if tf_userName.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_userName", comment: ""))
        }
        else if tf_password.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_password", comment: ""))
        }
        else if tf_confirmPassword.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_confirmPassword", comment: ""))
        }
        else if tf_password.text! != tf_confirmPassword.text! {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("passwordNotMatches", comment: ""))
        }
        else if tf_email.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_email", comment: ""))
        }
        else if !isValidEmail(testStr: tf_email.text!)
        {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("worng_email", comment: ""))
        }
        else{
            API_signUp()
        }
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isPopUp")
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    func API_signUp()
    {
        self.view.addSubview(progressHUD)
        let user = PFUser()
        user.username = tf_userName.text?.lowercased()
        user.password = tf_password.text
        user.email = tf_email.text?.lowercased()
        user["firstName"] = tf_firstName.text
        user["lastName"] = tf_lastName.text
        user["allItemInFeed"] = true
        user["notifiedItemListed"] = true
        user["notifiedFollwMe"] = true
        user["notifiedLovesMyItem"] = true
        user["notifiedCommentMyItem"] = true
        user["notifiedPurchaseMyItem"] = true
        user["notifiedItemLovePurchasePosted"] = true
        
        user.signUpInBackground { (user, error) in
            if error == nil {
                // Hooray! Let them use the app now.
                print("success");
                let defaults = UserDefaults.standard
                let dict = ["Name": self.tf_userName.text!, "Password": self.tf_password.text!]
                defaults.set(dict, forKey: "autoLogin")
                //defaults.set(false, forKey: "isPopUp")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let installation =  PFInstallation.current()
                if (installation != nil) {
                    installation?.setDeviceTokenFrom(appDelegate.deviceToken_data)
                    installation?.setObject(PFUser.current()!, forKey: "user")
                    installation?.saveEventually()
                }
            self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
            }
            else {
                print("error == \(String(describing: error))");
                // Show the errorString somewhere and let the user try again.
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
           self.progressHUD.removeFromSuperview()
        }
    }


    @IBAction func btn_termsAndCondition(_ sender: Any)
    {
        self.performSegue(withIdentifier: "WebVC", sender: nil)
    }

    // sign up with facebook ...
    var dict : [String : AnyObject]!
    
    @IBAction func btn_facebookSignup(_ sender: Any) {
        
        let permissions = ["email"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            
            if let error = error{
                print(error)
                showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("fb_loginError", comment: "unknown error"))
            }
                
            else{
                if let user = user {
                    
                    if user.isNew {
                        print("User signed up and logged in through Facebook!")
                        //self.getFBUserInfo()
                        self.pick_userName()
                        
                    } else {
                        print("user first name \(user["firstName"])")
                        if user["firstName"] == nil {
                            self.pick_userName()
                        }
                        else{
                            self.loggedUser()
                        }
                        print("END User logged in through Facebook!")
                    }
                }
                else {
                    print("Uh oh. The user cancelled the Facebook login.")
                    
                }
            }
        }
        
    }
    
    func pick_userName() -> Void {
        view_userName.isHidden = false
    }
    
    
    @IBOutlet weak var view_userName: UIView!
    @IBOutlet weak var tf_userNameFb: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    
    @IBAction func btn_next(_ sender: Any) {
        if tf_userNameFb.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please choose your username")
        }
        else  {
            usernameIsTaken(username: tf_userNameFb.text!)
        }
    }
    
    func usernameIsTaken(username: String) -> Void {
        //access PFUsers
        let query : PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo: username.lowercased())
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if (objects?.count)! > 0 {
                    showDialog(vc: self, title: "Error!", message: "User name already taken please choose another one")
                    print("Exist")
                }
                else{
                    print("Not Exist")
                    self.getFBUserInfo(username: username)
                }
            }
            else{
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func getFBUserInfo(username: String){
        
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    
                    print(result!)
                    print("name == \(String(describing: self.dict["name"]!))")
                    // print(self.dict)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let installation =  PFInstallation.current()
                    if (installation != nil) {
                        installation?.setDeviceTokenFrom(appDelegate.deviceToken_data)
                        installation?.setObject(PFUser.current()!, forKey: "user")
                        installation?.saveEventually()
                    }

                    
                    if let currentUser = PFUser.current() {
                        if let email = self.dict["email"] as? String {
                            currentUser.email = email
                        }
                        currentUser.username = String(describing: username)
                        currentUser["firstName"] = String(describing: self.dict["first_name"]!)
                        currentUser["lastName"] = String(describing: self.dict["last_name"]!)
                        
                        currentUser["allItemInFeed"] = true
                        currentUser["notifiedItemListed"] = true
                        currentUser["notifiedFollwMe"] = true
                        currentUser["notifiedLovesMyItem"] = true
                        currentUser["notifiedCommentMyItem"] = true
                        currentUser["notifiedPurchaseMyItem"] = true
                        currentUser["notifiedItemLovePurchasePosted"] = true
                        currentUser.saveInBackground()
                    }
                    
                    let defaults = UserDefaults.standard
                    let dict = ["Name": PFUser.current()?.username, "Password": "*******"]
                    defaults.set(dict, forKey: "autoLogin")

                    self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
                    //self.performSegue(withIdentifier: "productList", sender: nil)
                }
            })
        }
    }
    
    func loggedUser() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let installation =  PFInstallation.current()
        if (installation != nil) {
            installation?.setDeviceTokenFrom(appDelegate.deviceToken_data)
            installation?.setObject(PFUser.current()!, forKey: "user")
            installation?.saveEventually()
        }
        let defaults = UserDefaults.standard
        let dict = ["Name": PFUser.current()?.username, "Password": "*******"]
        defaults.set(dict, forKey: "autoLogin")
        
        self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
        //self.performSegue(withIdentifier: "productList", sender: nil)


    }

    @IBAction func btn_back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WebVC"{
            let lvc = segue.destination as! WebVC
            lvc.str_title = "Terms & Conditions"
            lvc.str_webLink = "http://www.yordrobe.com.au/terms"
        }
    }
    

}
