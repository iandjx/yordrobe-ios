//
//  SectionDetailVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/25/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class SectionDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var dic_section: PFObject!
    
    var isSelfUser:Bool = true
    
    @IBOutlet weak var lbl_sectionName: UILabel!
    @IBOutlet weak var aCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("dic section == \(dic_section!)")
        
        // Showing section name here 
        lbl_sectionName.text = "\(dic_section!["Section"] as! String)"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        API_sectionDetail(sectionName: dic_section!["Section"] as! String, owner: dic_section!["Owner"] as! PFUser)

    }
    
    var ary_productList:Array! = []
    
    func API_sectionDetail(sectionName: String, owner:PFUser) {
        
        print("section name = \(sectionName)\nOwner == \(owner)")
        
        let productListQuery = PFQuery(className: "Item")
        productListQuery.whereKey("Owner", equalTo: owner)
        productListQuery.whereKey("Section", equalTo: sectionName)
        productListQuery.includeKey("Owner")
        
        productListQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                // print("Object count == \(objects!.count)")
                // print("Object Section == \(objects!)")
                if objects!.count > 0 {
                    self.ary_productList = objects
                    self.aCollection.reloadData()
                }
                
            } else {
                print(error ?? "fsfdsfdsfdsfdsfdsfdsfdsfdsf")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ary_productList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! ProductCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        cell.lbl_brandName.text = "\((self.ary_productList![indexPath.row] as! PFObject)["Brand"] ?? "")"
        cell.lbl_price.text = "$\((self.ary_productList![indexPath.row] as! PFObject)["Price"] ?? "")"
        
        let coverImageFile = (self.ary_productList![indexPath.row] as! PFObject)["CoverImage"]! as! PFFileObject
        coverImageFile.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_product.image = image
                }
        })
        
        if isSelfUser == true {
            cell.btn_edit.addTarget(self, action: #selector(SectionDetailVC.btn_edit(_:)), for: .touchUpInside)
            cell.btn_edit.tag = indexPath.row
        }
        else {
            cell.btn_edit.isHidden = true
        }
        return cell
    }
    
    @IBAction func btn_edit(_ sender: UIButton) {
        print("btn tag === \(sender.tag)")
        self.performSegue(withIdentifier: "UploadItemVC", sender: sender.tag)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.invalidateLayout()
        return CGSize(width: ((self.view.frame.width/2) - 0.5), height:((self.view.frame.width / 2) + 25))
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegue(withIdentifier: "ProductDetailVC", sender: indexPath.item)
    }
    
    @IBAction func btn_back(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
//        for aViewController in viewControllers {
//            if(aViewController is TabViewController){
//                self.navigationController!.popToViewController(aViewController, animated: true);
//            }
//        }
        
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }

    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "UploadItemVC" {
            let lvc  = segue.destination as! UploadItemVC
            lvc.dic_product = ary_productList![sender as! Int] as! PFObject
        }
        else if segue.identifier == "ProductDetailVC" {
            let lvc = segue.destination as! ProductDetailVC
            lvc.dic_product = self.ary_productList![sender as! Int] as! PFObject
        }
        
     }
    
    
}
