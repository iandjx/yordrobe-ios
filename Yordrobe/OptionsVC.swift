//
//  SettingVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/26/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import MessageUI
import Parse
import PopupDialog

class OptionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var aTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //print("settingOptions =\(settingOptions().dic_options)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0 {
            return settingOptions().dic_options["wordrobe"]!.count
        }
        else if section == 1 {
            return settingOptions().dic_options["rewards"]!.count
        }
        else if section == 2 {
            return settingOptions().dic_options["spreadTheWords"]!.count
        }
        else if section == 3 {
            return settingOptions().dic_options["FollowFriends"]!.count
        }
        else if section == 4 {
            return settingOptions().dic_options["support"]!.count
        }
        else{
            return settingOptions().dic_options["other"]!.count
        }
        
        //return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
    
        if indexPath.section == 0 {
            cell.lbl_title.text = "\((settingOptions().dic_options["wordrobe"]!)[indexPath.row])"
            cell.lbl_rewardBalance.isHidden = true
        }
        else if indexPath.section == 1 {
            cell.lbl_title.text = "\((settingOptions().dic_options["rewards"]!)[indexPath.row])"
            
            if indexPath.row == 0 {
                if let balance = PFUser.current()!["CurrentRewardsBalance"] {
                    cell.lbl_rewardBalance.text = "$\(balance)"
                }
                cell.lbl_rewardBalance.isHidden = false
            }
            else{
                cell.lbl_rewardBalance.isHidden = true
            }
        }
        else if indexPath.section == 2 {
            cell.lbl_title.text = "\((settingOptions().dic_options["spreadTheWords"]!)[indexPath.row])"
            cell.lbl_rewardBalance.isHidden = true
        }
        else if indexPath.section == 3 {
            cell.lbl_title.text = "\((settingOptions().dic_options["FollowFriends"]!)[indexPath.row])"
            cell.lbl_rewardBalance.isHidden = true
        }
        else if indexPath.section == 4 {
            cell.lbl_title.text = "\((settingOptions().dic_options["support"]!)[indexPath.row])"
            cell.lbl_rewardBalance.isHidden = true
        }
        else  {
            cell.lbl_title.text = "\((settingOptions().dic_options["other"]!)[indexPath.row])"
            cell.lbl_rewardBalance.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "EditProfileVC", sender: nil)
            }
            else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "SettingVC", sender: nil)
            }
            else if indexPath.row == 2 {
                self.performSegue(withIdentifier: "MyPurchaseVC", sender: nil)
            }
            else if indexPath.row == 3 {
                self.performSegue(withIdentifier: "MySoldItemVC", sender: nil)
            }
            else if indexPath.row == 4 {
                self.performSegue(withIdentifier: "MyFavouriteVC", sender: nil)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: "EarnRevardVC", sender: nil)
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 1 {
                //shareToSocialMedia()
            }
            shareToSocialMedia()
            
        }
        else if indexPath.section == 3 {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "WebVC", sender: indexPath.section)
            }
            else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "Yordrobers", sender: nil)
            }
            
        }
        else if indexPath.section == 4 {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2  {
                self.performSegue(withIdentifier: "WebVC", sender: indexPath.row)
            }
            else if indexPath.row == 3 {
                self.performSegue(withIdentifier: "FeedbackVC", sender: nil)
            }
            else if indexPath.row == 4 {
               mailComposer()
            }
        }
        else if indexPath.section == 5 {
            if indexPath.row == 0 {
            // Logout 
                PFUser.logOut()
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "autoLogin")
                let Login = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.present(Login!, animated: true, completion: nil)                
            }
            else if indexPath.row == 1 {
                // Deactivate account funtionality
                deactivateProfile()
            }
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    func mailComposer()  {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            showDialog(vc: self, title: "Error!", message: "Your device is currently not setup to send emails. Please setup your email account in the Mail App on your device or alternatively, send us an email at support@yordrobe.com.au using your usual email client.")
            return
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@yordrobe.com.au"])
            //composeVC.title = "Enquiry from App"
            composeVC.setSubject("Enquiry from App")
            //composeVC.setMessageBody("Hello this is my message body!", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    func deactivateProfile() {
        let popup = PopupDialog(title: "Deactivate Account ?", message: "Are you sure that you want to deactivate your Yordrobe profile, rendering it invisible to all other Yordrobe members? You can only reactivate your account by contacting us directly.", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        let yes = DefaultButton(title: "Yes") {
            self.API_deactivate()
        }
        let no = CancelButton(title: "No") {
            //self.label.text = "You ok'd the default dialog"
        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
    }
    
    func API_deactivate() {
        
         // Implement functionality for deactivating a profile
        
        if PFUser.current() != nil {
            PFCloud.callFunction(inBackground: "deleteUser", withParameters: ["user_id": PFUser.current()!.objectId!]) { (responce, error) in
                if error == nil {
                    print("responce == \(responce!)")
                    PFUser.logOut()
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "autoLogin")
                    let Login = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                    self.present(Login!, animated: true, completion: nil)
                 }
                else{
                    showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                }
            }
        }
        

        
        /*
        if PFUser.current() != nil {
            PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                print("success = \(deleteSuccessful)")
                PFUser.logOut()
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "autoLogin")
                let Login = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.present(Login!, animated: true, completion: nil)
            })
        }
        */
    }
    

    
    func shareToSocialMedia() {
        // text to share
        let text = "Hi, I have a profile on Yordrobe, Australia's #1 social fashion marketplace. Download the App from the App Store and start following my wardrobe today!"
        let url = "https://itunes.apple.com/au/app/yordrobe/id802864021?mt=8"
        let image = UIImage(named: "shareLogo")
        // set up activity view controller
        //let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: [text,url,image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "customHeader") as! ProjectHeader
        headerView.addSubview(headerCell)
        
        if section == 0  {
            headerCell.lbl_sectionTitle.text = "Yordrobe Options".uppercased()
        }
        else if section == 1 {
            headerCell.lbl_sectionTitle.text = "REWARDS"
        }
        else if section == 2 {
            headerCell.lbl_sectionTitle.text = "SPREAD THE WORD"
        }
        else if section == 3 {
            headerCell.lbl_sectionTitle.text = "FOLLOW FRIENDS"
        }
        else if section == 4 {
            headerCell.lbl_sectionTitle.text = "SUPPORT"
        }
        else {
            headerCell.lbl_sectionTitle.text = "OTHER"
        }
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingOptions().dic_options.count
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WebVC"{
            let lvc = segue.destination as! WebVC
            
            if  sender as! Int == 0  {
                lvc.str_title = "FAQ"
                lvc.str_webLink = "http://www.yordrobe.com.au/faq"
            }
            else if  sender as! Int == 1  {
                lvc.str_title = "Help Centre"
                lvc.str_webLink = "http://www.yordrobe.com.au/help"
            }
            else if  sender as! Int == 2  {
                lvc.str_title = "Legal"
                lvc.str_webLink = "http://www.yordrobe.com.au/terms"
            }
            else if sender as! Int == 3 {
                lvc.str_title = "Facebook"
                lvc.str_webLink = "https://www.facebook.com/Yordrobe/"
            }
        }
        else if segue.identifier == "Yordrobers" {
            let lvc  = segue.destination as! FollowAndFollowingVC
            lvc.str_followerORfollowing = "YORDROBERS"
        }
    }
}
