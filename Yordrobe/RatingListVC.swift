//
//  RatingListVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 10/4/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class RatingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var img_star1: UIImageView!
    @IBOutlet weak var img_star2: UIImageView!
    @IBOutlet weak var img_star3: UIImageView!
    @IBOutlet weak var img_star4: UIImageView!
    @IBOutlet weak var img_star5: UIImageView!
    
    @IBOutlet weak var btn_received: BorderButton!
    @IBOutlet weak var btn_given: BorderButton!
    
    @IBOutlet weak var aTable: UITableView!
    @IBOutlet weak var view_header: UIView!
    
    var isSelfUser:Bool = true
    var otherUser: PFUser!
    var user: PFUser!
    var ary_ratingList: Array<Any>! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isSelfUser == false {
            user = otherUser
            print("user == \(user)")
        }
        else {
            user = PFUser.current()!
        }

        
        API_ratingReceived()
    }
    
    
    
    let progressHUD = ProgressHUD(text: "Loading..")

    
    
    func API_ratingReceived() {
        
        self.view.addSubview(self.progressHUD)
        
        let ratingReceived = PFQuery(className: "Rating")
        ratingReceived.whereKey("toUser", equalTo: user)
        ratingReceived.addAscendingOrder("updatedAt")
        ratingReceived.includeKey("fromUser")
        
        ratingReceived.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                if objects!.count > 0 {
                    self.ary_ratingList = objects!
                    print(" ary_ratingList list = \(self.ary_ratingList)")
                    self.updateAvgRating()
                }
                self.aTable.reloadData()
            }
            else {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                self.aTable.reloadData()
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    func API_ratingGiven() {
        
        self.view.addSubview(self.progressHUD)
        
        let ratingGiven = PFQuery(className: "Rating")
        ratingGiven.whereKey("fromUser", equalTo: user)
        ratingGiven.addAscendingOrder("updatedAt")
        ratingGiven.includeKey("toUser")
        
        ratingGiven.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                if objects!.count > 0 {
                    self.ary_ratingList = objects!
                    self.updateAvgRating()
                    //self.aTable.reloadData()
                }
                self.aTable.reloadData()
            }
            else {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                self.aTable.reloadData()
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    
    func allRating(completion: @escaping (_ result : Int) -> Void)  {
        var totalRating = 0
        for rating in ary_ratingList {
            totalRating += (rating as! PFObject)["rating"] as! Int
        }
        //print("final rating == \(totalRating/ary_ratingList.count)")
        completion(totalRating/ary_ratingList.count)

    }
    
    
    func updateAvgRating() {
        allRating { (totalRating) in
            if totalRating == 1 {
                self.img_star1.image = UIImage(named: "star_selected")
                self.img_star2.image = UIImage(named: "star")
                self.img_star3.image = UIImage(named: "star")
                self.img_star4.image = UIImage(named: "star")
                self.img_star5.image = UIImage(named: "star")
            }
            else if totalRating == 2 {
                self.img_star1.image = UIImage(named: "star_selected")
                self.img_star2.image = UIImage(named: "star_selected")
                self.img_star3.image = UIImage(named: "star")
                self.img_star4.image = UIImage(named: "star")
                self.img_star5.image = UIImage(named: "star")
            }
            else if totalRating == 3 {
                self.img_star1.image = UIImage(named: "star_selected")
                self.img_star2.image = UIImage(named: "star_selected")
                self.img_star3.image = UIImage(named: "star_selected")
                self.img_star4.image = UIImage(named: "star")
                self.img_star5.image = UIImage(named: "star")
            }
            else if totalRating == 4 {
                self.img_star1.image = UIImage(named: "star_selected")
                self.img_star2.image = UIImage(named: "star_selected")
                self.img_star3.image = UIImage(named: "star_selected")
                self.img_star4.image = UIImage(named: "star_selected")
                self.img_star5.image = UIImage(named: "star")
            }
            else if totalRating == 5 {
                self.img_star1.image = UIImage(named: "star_selected")
                self.img_star2.image = UIImage(named: "star_selected")
                self.img_star3.image = UIImage(named: "star_selected")
                self.img_star4.image = UIImage(named: "star_selected")
                self.img_star5.image = UIImage(named: "star_selected")
            }
        }
    }
    
    
    var isReceived = true
    

    @IBAction func btn_receivedAndGiven(_ sender: UIButton) {
        ary_ratingList = [Any]()
        if sender.tag == 1  {
            btn_received.backgroundColor = clr_golden
            btn_received.setTitleColor( .white, for: .normal)
            btn_given.backgroundColor = UIColor.white
            btn_given.setTitleColor(clr_golden, for: .normal)
            isReceived = true
            API_ratingReceived()
        }
        else if sender.tag == 2 {
            btn_given.backgroundColor = clr_golden
            btn_given.setTitleColor( .white, for: .normal)
            btn_received.backgroundColor = UIColor.white
            btn_received.setTitleColor(clr_golden, for: .normal)
            isReceived = false
            API_ratingGiven()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ary_ratingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RatingCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! RatingCell
        
        if isReceived == true {
            if let profilePic : PFFileObject = ((ary_ratingList[indexPath.row] as! PFObject)["fromUser"]! as! PFUser)["ProfilePic"] as? PFFileObject {
                profilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
            
            cell.lbl_userID.text = "\(((ary_ratingList[indexPath.row] as! PFObject)["fromUser"] as! PFUser).username!)"
            cell.lbl_date.text = "\(CustomDateFunctions.shortString(fromDate: (ary_ratingList[indexPath.row] as! PFObject).updatedAt!))"
            cell.lbl_rating.text = "Rating: \((ary_ratingList[indexPath.row] as! PFObject)["rating"]!)"
            cell.tv_description.text = "\((ary_ratingList[indexPath.row] as! PFObject)["comment"]!)"
        }
        else{
            if let profilePic : PFFileObject = ((ary_ratingList[indexPath.row] as! PFObject)["toUser"]! as! PFUser)["ProfilePic"] as? PFFileObject {
                profilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon.image = image
                    }
                })
            }
            
            cell.lbl_userID.text = "\(((ary_ratingList[indexPath.row] as! PFObject)["toUser"] as! PFUser).username!)"
            cell.lbl_date.text = "\(CustomDateFunctions.shortString(fromDate: (ary_ratingList[indexPath.row] as! PFObject).updatedAt!))"
            cell.lbl_rating.text = "Rating: \((ary_ratingList[indexPath.row] as! PFObject)["rating"]!)"
            cell.tv_description.text = "\((ary_ratingList[indexPath.row] as! PFObject)["comment"]!)"
        }
        

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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
