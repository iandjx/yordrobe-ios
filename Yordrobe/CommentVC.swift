//
//  CommentVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/4/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var view_footer: UIView!
    @IBOutlet weak var aTable: UITableView!
    var item:PFObject!
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("item == \(item!)")
        aTable.tableFooterView = view_footer
    }
    
    override func viewWillAppear(_ animated: Bool)
        
    {
        super.viewWillAppear(true)
        API_commentList()
    }
    
    var ary_commentList: Array! = []
    func API_commentList() {
        
         self.view.addSubview(progressHUD)
        let commentList = PFQuery(className:"Comment")
        commentList.whereKey("item", equalTo: item)
        commentList.includeKey("item")
        commentList.includeKey("user")
        commentList.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                self.ary_commentList = objects
                self.aTable.reloadData()
            } else {
                print(error ?? "")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    // MARK: -  Table view delegate and data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ary_commentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        let user  = (self.ary_commentList?[indexPath.row] as? PFObject)?["user"] as? PFUser
        cell.lbl_userName.text = "@\(user?.username ?? "")"
        cell.lbl_title.text = "\((self.ary_commentList?[indexPath.row] as? PFObject)?["comment"] ?? "")"
        cell.lbl_date.text = "\(timeAgoSinceDate(((self.ary_commentList?[indexPath.row] as? PFObject)?.updatedAt)!, currentDate: Date(), numericDates: true))"
        // icon user
        if let ProfilePic = user?["ProfilePic"] as? PFFileObject {
            ProfilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_userIcon?.image = image
                }
            })
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
    }

    @IBOutlet weak var tv_comment: UITextView!
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    
    @IBAction func btn_send(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if tv_comment.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please Enter your Comment")
        }
        else{
            API_leaveComment()
        }
     }
    
    func API_leaveComment()
    {
        self.view.addSubview(progressHUD)
        let comment = PFObject(className:"Comment")
        comment["item"] = item
        comment["comment"] = tv_comment.text
        comment["user"] = PFUser.current()
        comment.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                
                self.tv_comment.text = ""
                
                self.API_commentList()
            }
            else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
            }
            self.progressHUD.removeFromSuperview()
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
