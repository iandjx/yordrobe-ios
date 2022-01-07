//
//  FavouritVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/20/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class FavouritVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var aTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        API_notificationList()
    }
    
    var ary_notificationList : Array<Any>! = []
    let progressHUD = ProgressHUD(text: "Loading..")
    
    func API_notificationList() {
        self.view.addSubview(progressHUD)
        let notificationQ = PFQuery(className: "Notifications")
        notificationQ.whereKey("toUser", equalTo: PFUser.current()!)
        notificationQ.includeKey("fromUser")
        notificationQ.includeKey("item")
        notificationQ.includeKey("item.Owner")
        notificationQ.addDescendingOrder("createdAt")
        notificationQ.limit = 100
        notificationQ.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.ary_notificationList = objects
                print("ary notification == \(self.ary_notificationList!)")
                self.aTable.reloadData()
            }
            else{
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // # Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ary_notificationList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        
        if (self.ary_notificationList[indexPath.row] as! PFObject)["hasBeenSeen"] as? Bool == false {
            cell.btn_new.isHidden = false
        }
        else{
            cell.btn_new.isHidden = true
        }
        
        if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Comment" {
            cell.lbl_userEvent.text = "Commented on your item"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Love" {
            cell.lbl_userEvent.text = "Favourited your item"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Follows" {
            cell.lbl_userEvent.text = "Followed you"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Rating" {
            cell.lbl_userEvent.text = "Left a rating for you"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "New Item" {
            cell.lbl_userEvent.text = "Added a new item"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Purchase" {
            cell.lbl_userEvent.text = "You purchased an item"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Sale" {
            cell.lbl_userEvent.text = "Purchased your item"
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Reward" {
            cell.lbl_userEvent.text = "$20 Creadited in your account"
        }
        
        if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Purchase" || (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Sale" {
            if let profilePic  = ((ary_notificationList[indexPath.row] as! PFObject)["item"] as? PFObject) {
                
                let pro : PFFileObject = profilePic["CoverImage"] as! PFFileObject
                pro.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
        }
        else{
            if let fromUserData = (ary_notificationList[indexPath.row] as! PFObject)["fromUser"]! as? PFUser{
                if fromUserData.isDataAvailable {
//                let arrayOfKeys = fromUserData.allKeys
//                if arrayOfKeys.isEmpty{
//                    print("No Data.")
//                    cell.img_userIcon.image = UIImage(named: "userIcone")
//                }else{
                    if let profilePic : PFFileObject =  fromUserData["ProfilePic"] as? PFFileObject{
                        profilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                            let image = UIImage(data: imageData!)
                            if image != nil {
                                cell.img_userIcon.image = image
                            }
                        })
                    }else {
                        //cell.img_userIcon.image = UIImage(named: "userIcon")
                        cell.img_userIcon.image = UIImage(named: "userIcone")
                        //cell.img_userIcon?.image = UIImage(named: "userIcone")
                        
                    }
                }
                else {
                    print("No Data.")
                    cell.img_userIcon.image = UIImage(named: "userIcone")
                }
            }
            /*
            if let profilePic : PFFile = ((ary_notificationList[indexPath.row] as! PFObject)["fromUser"]! as! PFUser)["ProfilePic"] as? PFFile {
                profilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
            else {
                //cell.img_userIcon.image = UIImage(named: "userIcon")
                cell.img_userIcon.image = UIImage(named: "userIcone")
                //cell.img_userIcon?.image = UIImage(named: "userIcone")
                
            }
 */
        }
        if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Purchase" {
            cell.lbl_userName.text = ""

        }
        else {
            
            if let fromUserData  =  (ary_notificationList[indexPath.row]) as? PFObject {
                if (fromUserData["fromUser"] as? PFUser) != nil {
                    let name = (self.ary_notificationList[indexPath.row] as! PFObject)
                    cell.lbl_userName.text = "@\((name["fromUser"] as! PFUser).username!)"
                }
                else {
                    print("No Data.")
                    cell.lbl_userName.text = ""
                    }
                }
            }
        
        
        cell.lbl_date.text = "\(CustomDateFunctions.shortString(fromDate: (self.ary_notificationList[indexPath.row] as! PFObject).updatedAt!))"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.ary_notificationList[indexPath.row] as! PFObject
        object["hasBeenSeen"] = true
        object.saveInBackground()

        if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Comment" {
            self.performSegue(withIdentifier: "CommentVC", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Love" {
            self.performSegue(withIdentifier: "productDetail", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Follows" {
            self.performSegue(withIdentifier: "profile", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Rating" {
            self.performSegue(withIdentifier: "RatingListVC", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "New Item" {
            self.performSegue(withIdentifier: "productDetail", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Purchase" {
            self.performSegue(withIdentifier: "productDetail", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Sale" {
            self.performSegue(withIdentifier: "productDetail", sender: indexPath.row)
        }
        else if (self.ary_notificationList[indexPath.row] as! PFObject)["reason"] as? String == "Reward" {
            //self.performSegue(withIdentifier: "CommentVC", sender: indexPath.row)
        }

    }

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CommentVC" {
            let lvc = segue.destination as! CommentVC
            lvc.item = (ary_notificationList[sender as! Int] as! PFObject)["item"] as! PFObject
        }
        else if segue.identifier == "productDetail" {
            let lvc = segue.destination as! ProductDetailVC
            lvc.dic_product = (ary_notificationList[sender as! Int] as! PFObject)["item"] as! PFObject
        }
        else if segue.identifier == "profile" {
            let lvc = segue.destination as! ProfileVC
            lvc.isSelfUser = false
            lvc.otherUser = (ary_notificationList[sender as! Int] as! PFObject)["fromUser"] as! PFUser
        }
        else if segue.identifier == "RatingListVC"{
            let lvc  = segue.destination as! RatingListVC
            lvc.isSelfUser = false
            lvc.otherUser = (ary_notificationList[sender as! Int] as! PFObject)["fromUser"] as! PFUser
        }

    }
    

}
