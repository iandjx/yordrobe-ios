//
//  MySoldItemVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/2/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class MySoldItemVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var aTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        API_soldList()
    }
    var ary_soldList: Array! = []
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    func API_soldList()  {
        
        self.view.addSubview(self.progressHUD)
        
        let purchaseList = PFQuery(className: "ItemSale")
        purchaseList.whereKey("seller", equalTo: PFUser.current()!)
        purchaseList.addDescendingOrder("updatedAt")
        purchaseList.includeKey("item")
        purchaseList.includeKey("item.Owner")
        purchaseList.includeKey("buyer")
        purchaseList.includeKey("seller")
        purchaseList.includeKey("sellerRating")
        
        purchaseList.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                if objects!.count > 0 {
                    self.ary_soldList = objects!
                    print("ary purchase list = \(self.ary_soldList)")
                    self.aTable.reloadData()
                }
            }
            else {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    
    // MARK: -  Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ary_soldList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        
//        if let ProductImage = ((ary_soldList[indexPath.row] as! PFObject)["item"]! as! PFObject)["CoverImage"]  {
//            (ProductImage as! PFFile).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
//                let image = UIImage(data: imageData!)
//                if image != nil {
//                    cell.img_userIcon.image = image
//                }
//            })
//        }
        if let item = (ary_soldList[indexPath.row] as! PFObject)["item"] as? PFObject {
            
            let ProductImage : PFFileObject = (item)["CoverImage"] as! PFFileObject
            ProductImage.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_userIcon.image = image
                    }
                })
        }

        
        
        cell.lbl_soldDate.text = "Sold: \(CustomDateFunctions.shortString(fromDate: (ary_soldList[indexPath.row] as! PFObject).updatedAt!))"
        cell.btn_amount.setTitle("$\((ary_soldList[indexPath.row] as! PFObject)["totalPrice"]!)", for: .normal)
        
        
        if let buyerRating: PFObject = (ary_soldList[indexPath.row] as! PFObject)["sellerRating"] as? PFObject {
            cell.btn_rateSeller.isHidden = true
            cell.lbl_myFeedback.text = "My Feedback: \(buyerRating["rating"]!)"
            
        }
        else{
            cell.btn_rateSeller.setAttributedTitle(NSMutableAttributedString(string: "Rate Buyer", attributes: btn_golden_atribute), for: .normal)
            cell.btn_rateSeller.addTarget(self, action: #selector(MySoldItemVC.btn_rate(_:)), for: .touchUpInside)
            cell.btn_rateSeller.tag = indexPath.row
            cell.btn_rateSeller.isHidden = false
        }

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "productDetail", sender: indexPath.row)
    }

    @IBAction func btn_rate(_ sender: UIButton) {
        print("btn tag === \(sender.tag)")
        self.performSegue(withIdentifier: "feedback", sender: sender.tag)
        
    }

    
    
    @IBAction func btn_back(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
        for aViewController in viewControllers {
            if(aViewController is OptionsVC){
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "feedback" {
            let lvc = segue.destination as! RatingVC
            lvc.dic_product = ary_soldList[sender as! Int] as! PFObject
            lvc.isPurchase = false
        }
        else if segue.identifier == "productDetail" {
            let lvc = segue.destination as! ProductDetailVC
            lvc.dic_product = (ary_soldList[sender as! Int] as! PFObject)["item"] as! PFObject
        }

    }
    

}
