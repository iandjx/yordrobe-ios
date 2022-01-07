//
//  SettingsVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/27/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var aTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0  {
            return 2
        }
        else{
            return 1
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = indexPath.section == 0 ? "customCell" : "checkBoxCell"
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: identifier)! as! ProjectCell
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell.lbl_title.text = "Everyone"
                if let user = PFUser.current() {
                    if let yes: Bool = user["allItemInFeed"] as? Bool {
                        if yes  == true {
                            cell.btn_checkBox.isSelected = true
                        }
                        else {
                            cell.btn_checkBox.isSelected = false
                        }
                    }
                }

            }
            else{
                cell.lbl_title.text = "Wardobes I am Following"
                if let user = PFUser.current() {
                    if let yes: Bool = user["allItemInFeed"] as? Bool {
                        if yes  == false {
                            cell.btn_checkBox.isSelected = true
                        }
                        else {
                            cell.btn_checkBox.isSelected = false
                        }
                    }
                }

            }
            cell.btn_checkBox.addTarget(self, action: #selector(SettingsVC.btn_checkBox(_:)), for: .touchUpInside)
            cell.btn_checkBox.tag = indexPath.row
            
        }
        else {
            
            if indexPath.section == 1 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedItemListed"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }
            else if indexPath.section == 2 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedFollwMe"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }
            else if indexPath.section == 3 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedLovesMyItem"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }
            else if indexPath.section == 4 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedCommentMyItem"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }
            else if indexPath.section == 5 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedPurchaseMyItem"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }
            else if indexPath.section == 6 {
                if let user = PFUser.current() {
                    if let yes: Bool = user["notifiedItemLovePurchasePosted"] as? Bool {
                        if yes  == true {
                            cell.btn_yes.isSelected = true
                        }
                        else {
                            cell.btn_no.isSelected = true
                        }
                    }
                }
            }

            
            
            cell.btn_yes.addTarget(self, action: #selector(btn_yes(_:)), for: .touchUpInside)
            cell.btn_yes.indexPath = indexPath.row
            cell.btn_yes.section = indexPath.section

            cell.btn_no.addTarget(self, action: #selector(btn_no(_:)), for: .touchUpInside)
            cell.btn_no.indexPath = indexPath.row
            cell.btn_no.section = indexPath.section
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func btn_yes(_ sender: checkBox ) {
        
        let indexPath = NSIndexPath(row: sender.tag, section: sender.section!) // This defines what indexPath is which is used later to define a cell
        let cell = aTable.cellForRow(at: indexPath as IndexPath) as! ProjectCell // This is where the magic happens - reference to the cell
        
        if sender.isSelected == false {
            sender.isSelected = true
            cell.btn_no.isSelected = false
            
            if indexPath.section == 1 {
                if let user = PFUser.current() {
                    user["notifiedItemListed"] = true
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 2 {
                if let user = PFUser.current() {
                    user["notifiedFollwMe"] = true
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 3 {
                if let user = PFUser.current() {
                    user["notifiedLovesMyItem"] = true
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 4 {
                if let user = PFUser.current() {
                    user["notifiedCommentMyItem"] = true
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 5 {
                if let user = PFUser.current() {
                    user["notifiedPurchaseMyItem"] = true
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 6 {
                if let user = PFUser.current() {
                    user["notifiedItemLovePurchasePosted"] = true
                    user.saveInBackground()
                }
            }
        }
        
        
        
        /*
        if sender.isSelected == true {
            sender.isSelected = false
            cell?.btn_no.isSelected = true
        }
        else{
            sender.isSelected = true
            cell?.btn_no.isSelected = false
        }
         */
        
        
    }
    
    @IBAction @objc func btn_no(_ sender: checkBox) {
        
        let indexPath = NSIndexPath(row: sender.tag, section: sender.section!)
        let cell = aTable.cellForRow(at: indexPath as IndexPath) as! ProjectCell
        
        if sender.isSelected == false {
            sender.isSelected = true
            cell.btn_yes.isSelected = false
            
            if indexPath.section == 1 {
                if let user = PFUser.current() {
                    user["notifiedItemListed"] = false
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 2 {
                if let user = PFUser.current() {
                    user["notifiedFollwMe"] = false
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 3 {
                if let user = PFUser.current() {
                    user["notifiedLovesMyItem"] = false
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 4 {
                if let user = PFUser.current() {
                    user["notifiedCommentMyItem"] = false
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 5 {
                if let user = PFUser.current() {
                    user["notifiedPurchaseMyItem"] = false
                    user.saveInBackground()
                }
            }
            else if indexPath.section == 6 {
                if let user = PFUser.current() {
                    user["notifiedItemLovePurchasePosted"] = false
                    user.saveInBackground()
                }
            }
        }
        /*
        if sender.isSelected == true {
            sender.isSelected = false
            cell?.btn_yes.isSelected = true
        }
        else{
            sender.isSelected = true
            cell?.btn_yes.isSelected = false
        }
         */
    }
    

    
    
    @IBAction func btn_checkBox(_ sender: UIButton) {
        
        if sender.tag == 0 {
            let indexPath = NSIndexPath(row: 1, section: 0)
            let cell = aTable.cellForRow(at: indexPath as IndexPath) as! ProjectCell
            cell.btn_checkBox.isSelected = false
            sender.isSelected = true

            if let user = PFUser.current() {
                user["allItemInFeed"] = true
                user.saveInBackground()
            }
            
            
        }
        else{
            let indexPath = NSIndexPath(row: 0, section: 0)
            let cell = aTable.cellForRow(at: indexPath as IndexPath) as! ProjectCell
            cell.btn_checkBox.isSelected = false
            sender.isSelected = true
            
            if let user = PFUser.current() {
                user["allItemInFeed"] = false
                user.saveInBackground()
            }
        }

        /*
        if sender.isSelected == true {
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
         */
    }
    


    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "customHeader") as! ProjectHeader
        headerCell.lbl_sectionTitle.text = ary_settingsHeader[section].uppercased()
        headerView.addSubview(headerCell)
        
            return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ary_settingsHeader.count
    }

    @IBAction func btn_back(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
        for aViewController in viewControllers {
            if(aViewController is OptionsVC){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
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
