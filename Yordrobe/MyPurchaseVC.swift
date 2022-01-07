//
//  MuPurchaseVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/2/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class MyPurchaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var aTable: UITableView!
    var controllerName  = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aTable.delegate = self
        aTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        API_purchaseList()
    }
    

    var ary_purchaseList: Array! = []
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    func API_purchaseList()  {

        self.view.addSubview(self.progressHUD)
        
        let purchaseList = PFQuery(className: "ItemSale")
        purchaseList.whereKey("buyer", equalTo: PFUser.current()!)
        purchaseList.addDescendingOrder("updatedAt")
        purchaseList.includeKey("item")
        purchaseList.includeKey("item.Owner")
        purchaseList.includeKey("buyer")
        purchaseList.includeKey("seller")
        purchaseList.includeKey("buyerRating")
    
        
        purchaseList.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                if objects!.count > 0 {
                    self.ary_purchaseList = objects!
                    print("ary purchase list = \(self.ary_purchaseList)")
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
        return ary_purchaseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: "customCell")! as! ProjectCell
        
//        print([indexPath.row])
//        print (((ary_purchaseList[indexPath.row] as! PFObject)["item"] as? PFObject) ?? "")
        
        if let ProductImage = ((ary_purchaseList[indexPath.row] as! PFObject)["item"] as? PFObject)  {
            (ProductImage["CoverImage"] as! PFFileObject).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_userIcon.image = image
                }
            })
        }

        
        cell.lbl_PurchaseDate.text = "Purchased: \(CustomDateFunctions.shortString(fromDate: (ary_purchaseList[indexPath.row] as! PFObject).updatedAt!))"
       
        if let Productseller = ((ary_purchaseList[indexPath.row] as! PFObject)["seller"] as? PFUser)  {

            cell.lbl_itemPosted.text = "Item Posted: (\(Productseller.username!))"
            
        }
        cell.btn_amount.setTitle("$\((ary_purchaseList[indexPath.row] as! PFObject)["totalPrice"]!)", for: .normal)
        
        if let buyerRating: PFObject = (ary_purchaseList[indexPath.row] as! PFObject)["buyerRating"] as? PFObject {
            cell.btn_rateSeller.isHidden = true
            cell.lbl_myFeedback.text = "My Feedback: \(buyerRating["rating"]!)"

        }
        else{
            cell.btn_rateSeller.setAttributedTitle(NSMutableAttributedString(string: "Rate Seller", attributes: btn_golden_atribute), for: .normal)
            cell.btn_rateSeller.addTarget(self, action: #selector(MyPurchaseVC.btn_rate(_:)), for: .touchUpInside)
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
        if self.controllerName == "Confirm"{
           self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
        }else{
            if let navController = self.navigationController {
               navController.popViewController(animated: true)
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
            lvc.dic_product = ary_purchaseList[sender as! Int] as! PFObject
            lvc.isPurchase = true
        }
        else if segue.identifier == "productDetail" {
            let lvc = segue.destination as! ProductDetailVC
            lvc.dic_product = (ary_purchaseList[sender as! Int] as! PFObject)["item"] as! PFObject
        }
        
    }
    
}


