//
//  LoginVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/13/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var tf_userName: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_forgotPwd: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btn_forgotPwd.setAttributedTitle(NSMutableAttributedString(string: "Forgot Password?", attributes: btn_forgotPwd_atribute), for: .normal)
        // Do any additional setup after loading the view.
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)

        // Avoiding special character
        tf_userName.delegate = self
        tf_userNameFb.delegate = self
        //
        view_userName.isHidden = true
        view_userName.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.view.frame.size.width, height: 568)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //tf_userName.text = "museer.ansari"
        //tf_password.text = "123456789" 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_login(_ sender: Any) {
        
        self.view.endEditing(true)
        //self.performSegue(withIdentifier: "tabVC", sender: nil)
        
        if tf_userName.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_userName", comment: "user din not input user name"))
        }
        else if tf_password.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("empty_password", comment: "user din not input user password"))
        }
        else{
            api_login()
        }
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isPopUp")
    }
    
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }

    let progressHUD = ProgressHUD(text: "Loading..")

    func api_login()  {
        
        self.view.addSubview(progressHUD)
        
        print("user name == \(tf_userName.text!.lowercased())\npassword == \(tf_password.text!)")
                
        PFUser.logInWithUsername(inBackground: tf_userName.text!.lowercased(), password: tf_password.text!) { (user, error) -> Void in
            if error == nil {
                
                let defaults = UserDefaults.standard
                let dict = ["Name": self.tf_userName.text!, "Password": self.tf_password.text!]
                defaults.set(dict, forKey: "autoLogin")
                //defaults.set(false, forKey: "isPopUp")
                // Store the deviceToken in the current installation and save it to Parse.
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let installation =  PFInstallation.current()
                if (installation != nil) {
                    installation?.setDeviceTokenFrom(appDelegate.deviceToken_data)
                    installation?.setObject(PFUser.current()!, forKey: "user")
                    installation?.saveEventually()
                }
                self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
                
            } else {
                print("error: \(error!)")
                showAlertMessage(vc: self, titleStr: NSLocalizedString("error_title", comment: ""), messageStr: NSLocalizedString("error_authentication", comment: "user din not input user password"))

            }
            self.progressHUD.removeFromSuperview()
        }        
    }
    
    // Login with facebook ...
    var dict : [String : AnyObject]!
    
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btn_back(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
