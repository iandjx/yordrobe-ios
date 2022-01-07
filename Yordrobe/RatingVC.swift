//
//  RatingVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 10/4/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class RatingVC: UIViewController {

    @IBOutlet weak var btn_star1: UIButton!
    @IBOutlet weak var btn_star2: UIButton!
    @IBOutlet weak var btn_star3: UIButton!
    @IBOutlet weak var btn_star4: UIButton!
    @IBOutlet weak var btn_star5: UIButton!
    @IBOutlet weak var tv_comment: UITextView!
    
    var dic_product: PFObject!
    var isPurchase : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("dic product == \(dic_product!)")
    }
    
    @IBAction func btn_submit(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if rating_value == nil {
            showDialog(vc: self, title: "Error!", message: "Please mention your rating")
        }
        else if tv_comment.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please leave a brief comment on your rating.")
        }
        else{
            API_rating()
        }
    }
    
    func API_rating() {
        
        let rating = PFObject(className:"Rating")
        
        if isPurchase == true {
            rating["fromUser"] = PFUser.current()!
            rating["toUser"] = dic_product["seller"]! as! PFUser
        }
        else {
            rating["fromUser"] = PFUser.current()!
            rating["toUser"] = dic_product["buyer"]! as! PFUser
        }

        rating["rating"] = rating_value!
        rating["item"] = dic_product!["item"] as! PFObject
        rating["comment"] = tv_comment.text!
        rating.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                self.tv_comment.text = ""
                self.btn_star1.setBackgroundImage(UIImage(named: "star"), for: .normal)
                self.btn_star2.setBackgroundImage(UIImage(named: "star"), for: .normal)
                self.btn_star3.setBackgroundImage(UIImage(named: "star"), for: .normal)
                self.btn_star4.setBackgroundImage(UIImage(named: "star"), for: .normal)
                self.btn_star5.setBackgroundImage(UIImage(named: "star"), for: .normal)

                //showDialog(vc: self, title: "Done", message: "Rating saved successfully")
                showDialogAndBack(vc: self, title: "Done", message: "Rating saved successfully", btn_Name: "OK")
                
                
                // saving buyer rating in item sale table
                
                let query = PFQuery(className:"ItemSale")
                query.getObjectInBackground(withId: self.dic_product.objectId!) {
                    (object, error) -> Void in
                    if error != nil {
                        print(error!)
                    } else {
                        if let item = object {
                            if self.isPurchase == true {
                                item["buyerRating"] = rating
                            }
                            else{
                                item["sellerRating"] = rating
                            }
                        }
                        object!.saveInBackground()
                    }
                }
                //
            }
            else
            {
                // There was a problem, check error.description
                print("data not save successfully.. ")
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    var rating_value: Int!
    
    @IBAction func btn_star(_ sender: UIButton) {
        
        rating_value = sender.tag
        
        if sender.tag == 1 {
            btn_star1.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star2.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star3.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star4.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star5.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        else if sender.tag == 2 {
            btn_star1.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star2.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star3.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star4.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star5.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        else if sender.tag == 3 {
            btn_star1.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star2.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star3.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star4.setBackgroundImage(UIImage(named: "star"), for: .normal)
            btn_star5.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        else if sender.tag == 4 {
            btn_star1.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star2.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star3.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star4.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star5.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        else if sender.tag == 5 {
            btn_star1.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star2.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star3.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star4.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
            btn_star5.setBackgroundImage(UIImage(named: "star_selected"), for: .normal)
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
