//
//  FollowAndFollowingVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/21/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class FollowAndFollowingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var isSelfUser:Bool = true
    var otherUser: PFUser!
    var user: PFUser!
    
    var str_followerORfollowing: String!
    
    @IBOutlet weak var lbl_navigationTitle: UILabel!
    @IBOutlet weak var aTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSelfUser == true {
            user  = PFUser.current()!
        }
        else {
            user = otherUser!
        }
        
        
        // Do any additional setup after loading the view.
        lbl_navigationTitle.text = str_followerORfollowing
        if str_followerORfollowing == "FOLLOWERS" {
            API_followerList()
        }
        else if str_followerORfollowing == "FOLLOWING" {
            API_followingList()
        }
        else if str_followerORfollowing == "YORDROBERS" {
            API_yordrobersList()
        }
    }
    
    var ary_list: Array! = []
    
    
    func API_followerList() {
        
        // Followers lsit ..
        let followerQuery = PFQuery(className: "Follows")
        followerQuery.whereKey("toUser", equalTo: user)
        followerQuery.includeKey("fromUser")
        followerQuery.includeKey("toUser")
        if isSelfUser == true{
            followerQuery.whereKey("fromUser", notEqualTo: user)
        }
        followerQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("Object FOLLOWERS == \(objects!)")
                
                if objects!.count > 0 {
                    self.ary_list = objects
                    self.aTable.reloadData()
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func API_followingList() {
        
        // Followers list ..
        let followingQuery = PFQuery(className: "Follows")
        followingQuery.whereKey("fromUser", equalTo: user)
        followingQuery.includeKey("fromUser")
        followingQuery.includeKey("toUser")
        
        if isSelfUser == true {
            followingQuery.whereKey("toUser", notEqualTo: user)
        }
        
        followingQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("Object FOLLOWING == \(objects!)")
                
                if objects!.count > 0 {
                    self.ary_list = objects
                    self.aTable.reloadData()
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func API_yordrobersList() {
        
        let queryInner = PFQuery(className: "Follows")
        queryInner.whereKey("fromUser", equalTo: user)
        queryInner.includeKey("fromUser")
        queryInner.includeKey("toUser")
        
        // yordrobers list ..
        let yordrobersQuery = PFUser.query()!
        yordrobersQuery.whereKey("username", doesNotMatchKey: "toName", in: queryInner)
        yordrobersQuery.whereKey("objectId", notEqualTo: user.objectId!)
        yordrobersQuery.whereKey("firstName", notEqualTo: NSNull())

        yordrobersQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("Object==**** \(objects!)")
                
                if objects!.count > 0 {
                    self.ary_list = objects
                    self.aTable.reloadData()
                }
            } else {
                print(error ?? "")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ary_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        // If Follower list
        if str_followerORfollowing == "FOLLOWERS" {
            
            cell.lbl_userName.text = "\(((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser)["firstName"]!) \(((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser)["lastName"]!)"
            cell.lbl_userID.text = "@\(((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser).username!)"
            
            
            if let ProfilePic = ((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser)["ProfilePic"] {
                (ProfilePic as? PFFileObject)?.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                        let image = UIImage(data: imageData!)
                        if image != nil {
                            cell.img_userIcon.image = image
                        }
                })
            }
            // checking If self user in list then hide button
            if  ((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser).objectId == PFUser.current()?.objectId {
                cell.btn_follower.isHidden = true
            }
            else{
                cell.btn_follower.isHidden = false
            }
            
            // Check if user is already following user ?..
            let FQuery = PFQuery(className: "Follows")
            FQuery.whereKey("fromUser", equalTo: PFUser.current()!)
            FQuery.whereKey("toUser", equalTo: ((ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser))
            
            FQuery.findObjectsInBackground { (objects, error) -> Void in
                if error == nil {
                    if objects!.count > 0 {
                        cell.btn_follower.isSelected = false
                    }
                    else{
                        cell.btn_follower.isSelected = true
                    }
                }
            }
            cell.btn_follower.tag = indexPath.row
            //
        }
            // If Following list
        else if str_followerORfollowing == "FOLLOWING" {
            
            cell.lbl_userName.text = "\(((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser)["firstName"]!) \(((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser)["lastName"]!)"
            cell.lbl_userID.text = "@\(((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser).username!)"
            
            
            if let ProfilePic = ((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser)["ProfilePic"]{
                (ProfilePic as? PFFileObject)?.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                        let image = UIImage(data: imageData!)
                        if image != nil {
                            cell.img_userIcon.image = image
                        }
                })
            }
            
            // checking If self user in list then hide button
            if  ((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser).objectId == PFUser.current()?.objectId {
                cell.btn_follower.isHidden = true
            }
            else{
                cell.btn_follower.isHidden = false
            }
            
            // Check if user is already following user ?..
            let likeQuery = PFQuery(className: "Follows")
            likeQuery.whereKey("fromUser", equalTo: PFUser.current()!)
            
            likeQuery.whereKey("toUser", equalTo: ((ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser))
            
            
            likeQuery.findObjectsInBackground { (objects, error) -> Void in
                if error == nil {
                    if objects!.count > 0 {
                        cell.btn_follower.isSelected = false
                    }
                    else{
                        cell.btn_follower.isSelected = true
                    }
                }
            }
            //
            
            //cell.btn_follower.setTitle("UNFOLLOW", for: .normal)
            cell.btn_follower.tag = indexPath.row
        }
            // If Yordrober list
        else if str_followerORfollowing == "YORDROBERS" {
            cell.lbl_userName.text = "\((ary_list[indexPath.row] as! PFUser)["firstName"]!) \((ary_list[indexPath.row] as! PFUser)["lastName"]!)"
            cell.lbl_userID.text = "\((ary_list[indexPath.row] as! PFUser).username!)"
            
            if let ProfilePic = (ary_list[indexPath.row] as! PFUser)["ProfilePic"]  {
                (ProfilePic as? PFFileObject)?.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
            
            cell.btn_follower.tag = indexPath.row
            cell.btn_follower.isSelected = true
        }
        
        cell.btn_follower.addTarget(self, action: #selector(btn_followAndUnfollow(_:)), for: .touchUpInside)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lvc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        lvc.isSelfUser = false
        if str_followerORfollowing == "FOLLOWERS" {
            lvc.otherUser = (ary_list[indexPath.row] as! PFObject)["fromUser"] as! PFUser
        }
        else if str_followerORfollowing == "FOLLOWING" {
            lvc.otherUser = (ary_list[indexPath.row] as! PFObject)["toUser"] as! PFUser
        }
        else if str_followerORfollowing == "YORDROBERS" {
            lvc.otherUser = (ary_list[indexPath.row] as! PFUser)
        }
        self.navigationController?.pushViewController(lvc, animated: true)
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")

    @objc func btn_followAndUnfollow(_ sender : UIButton) {
        
        //self.view.addSubview(progressHUD)
        
        if sender.isSelected != true {
            sender.isSelected = true
            API_unfollow(index: sender.tag)
        }
        else{
            sender.isSelected = false
            API_follow(index: sender.tag)
        }
    }
    /*
    func btn_follow(_ sender : UIButton) {
        
        self.view.addSubview(progressHUD)
        
        if sender.isSelected == true {
            sender.isSelected = false
            API_unfollow(index: sender.tag)
        }
        else{
            sender.isSelected = true
            API_follow(index: sender.tag)
        }
        
        
    }
     */
    func API_follow(index:Int) {
        
        self.view.addSubview(progressHUD)
        let object = PFObject(className:"Follows")
        object["fromUser"] = PFUser.current()!
        object["fromName"] = PFUser.current()!.username
        
        if str_followerORfollowing == "YORDROBERS" {
            object["toUser"] = ary_list[index] as! PFUser
            object["toName"] = (ary_list[index] as! PFUser).username
        }
        else if str_followerORfollowing == "FOLLOWERS" {
            object["toUser"] = (ary_list[index] as! PFObject)["fromUser"] as! PFUser
            object["toName"] = ((ary_list[index] as! PFObject)["fromUser"] as! PFUser).username
        }
        else if str_followerORfollowing == "FOLLOWING" {
            object["toUser"] = (ary_list[index] as! PFObject)["toUser"] as! PFUser
            object["toName"] = ((ary_list[index] as! PFObject)["toUser"] as! PFUser).username
        }
        object.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
        
    }
    
    func API_unfollow(index:Int) {
        self.view.addSubview(progressHUD)
        
        let item = PFQuery(className:"Follows")
        item.whereKey("fromUser", equalTo: PFUser.current()!)
        
        if str_followerORfollowing == "YORDROBERS" {
            item.whereKey("toUser", equalTo: ary_list[index] as! PFUser)
        }
        else if str_followerORfollowing == "FOLLOWERS" {
            item.whereKey("toUser", equalTo: (ary_list[index] as! PFObject)["fromUser"] as! PFUser)
        }
        else if str_followerORfollowing == "FOLLOWING" {
            item.whereKey("toUser", equalTo: (ary_list[index] as! PFObject)["toUser"] as! PFUser)
        }
        
        item.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // Do something
                    object.deleteEventually()
                }
            } else {
                // There was a problem, check error.description
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
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
