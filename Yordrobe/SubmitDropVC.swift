//
//  SubmitDropVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/26/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import PopupDialog
import Parse

class SubmitDropVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var aTable: UITableView!
    @IBOutlet weak var view_footer: UIView!

    var ary_dropBags: Array<Any>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ary drob bags == \(ary_dropBags!)")
        aTable.reloadData()
        aTable.tableFooterView = view_footer
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_cancel(_ sender: Any) {
        
        let popup = PopupDialog(title: "Cancel Your Drop?", message: "Are you sure thet you want to empty your DROP bag and cancel this DROP?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        let yes = DefaultButton(title: "Yes") {
            if let navigationController = self.navigationController {
                if navigationController.viewControllers.count > 1 {
                    navigationController.popViewController(animated: true)
                    return
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        let no = CancelButton(title: "No") {
            //self.label.text = "You ok'd the default dialog"
        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    // Create a custom view controller
    let SectionVC = SectionPopUp(nibName: "PaypalEmail", bundle: nil)
    
    func showCustomDialog() {
        
        // Create the dialog
        let popup = PopupDialog(viewController: SectionVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "DONE", height: 60) {
            
            if self.SectionVC.tf_sectionName.text!.isEmpty {
                showDialog(vc: self, title: "Error!", message: "Please Enter Your Paypal Email")
            }
            else{
               self.API_paypalEmail(paypalEmail: self.SectionVC.tf_sectionName.text!)
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        // Present dialog
        present(popup, animated: true, completion: nil)
    }

    func API_paypalEmail(paypalEmail:String)  {
        if let user = PFUser.current() {
            user["paypalEmail"] = paypalEmail
            user.saveInBackground()
        }

    }
    
    
    @IBAction func btn_submiit(_ sender: Any) {
        
        if PFUser.current()!["paypalEmail"] == nil || PFUser.current()!["paypalEmail"]! as? String == "" {
            showCustomDialog()
        }
        else {
            submitDrop()
        }
        
     }
    
    var address: String!
    
    func submitDrop()  {
        let popup = PopupDialog(title: "Submit Your Drop?", message: "Are you sure thet you want to submit your DROP bag?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        let yes = DefaultButton(title: "Yes") {
            self.API_submitDrop()
        }
        let no = CancelButton(title: "No") {
            //self.label.text = "You ok'd the default dialog"
        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func API_submitDrop()  {
        
        address = "\(PFUser.current()!["firstName"]!) \(PFUser.current()!["lastName"]!)\n"
        
        if let _address: String = PFUser.current()?["address"] as? String {
            address = address + _address
        }
        if let suburb = PFUser.current()?["suburb"] {
            address = address + " \(suburb)"
        }
        if let state = PFUser.current()?["state"] {
            if "\(state)" != "State" {
                address = address + "\n\(state)"
            }
        }
        if let postCode = PFUser.current()?["postCode"] {
            address = address + " \(postCode)"
        }

        
        PFCloud.callFunction(inBackground: "dropMail", withParameters: ["data":ary_dropBags!, "postAddress":address, "phoneNumber":"9956475244"]) { (responce, error) in
            if error == nil {
                print("responce == \(responce!)")
                if Int((responce! as! Dictionary)["status"]!)! == 1 {
                    let popup = PopupDialog(title: "", message: "\((responce! as! Dictionary<String, String>)["msg"]!)", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
                        print("Completed")
                    }
                    let btn_ok = DefaultButton(title: "OK") {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
                        self.navigationController!.popToViewController(viewControllers[0], animated: true);

//                        for aViewController in viewControllers {
//                            if(aViewController is ESTabBarController){
//                                self.navigationController!.popToViewController(aViewController, animated: true);
//                            }
//                        }
                    }

                    // Add buttons to dialog
                    popup.addButtons([btn_ok])
                    self.present(popup, animated: true, completion: nil)
                    
                    //showDialog(vc: self, title: "", message: "\((responce! as! Dictionary<String, String>)["msg"]!)")
                }
            }
            else{
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
        }
        
    }
    
    // # Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ary_dropBags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: DropCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! DropCell
        
        cell.lbl_brand.text = "Brand: \(((ary_dropBags[indexPath.row] as! Dictionary)["brand"]!) as String)"
        cell.lbl_category.text = "Category: \(((ary_dropBags[indexPath.row] as! Dictionary)["category"]!) as String)"
        cell.lbl_subCategory.text = "Sub Category: \(((ary_dropBags[indexPath.row] as! Dictionary)["subCategory"]!) as String)"
        cell.lbl_size.text = "Size: \(((ary_dropBags[indexPath.row] as! Dictionary)["size"]!) as String)"
        cell.lbl_colour.text = "Colour: \(((ary_dropBags[indexPath.row] as! Dictionary)["colour"]!) as String)"
        cell.lbl_condition.text = "Condition: \(((ary_dropBags[indexPath.row] as! Dictionary)["condition"]!) as String)"
        cell.lbl_priceRange.text = "Price: \(((ary_dropBags[indexPath.row] as! Dictionary)["price"]!) as String)"
        cell.lbl_description.text = "Description: \(((ary_dropBags[indexPath.row] as! Dictionary)["description"]!) as String)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            ary_dropBags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("ary drob bags after edit == \(ary_dropBags)")
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
