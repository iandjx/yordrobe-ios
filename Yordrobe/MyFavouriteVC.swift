//
//  MyFavouriteVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/2/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

class MyFavouriteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var aCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        API_getProduct()
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    var ary_itemList :Array! = []
    
    
    
    func API_getProduct() {
        
        self.view.addSubview(progressHUD)
        
        let fev_list = PFQuery(className:"Love")
        fev_list.whereKey("User", equalTo: PFUser.current()!)
        fev_list.includeKey("Item")
        fev_list.includeKey("User")
        fev_list.includeKey("Item.Owner")
        fev_list.order(byDescending: "updatedAt")
        fev_list.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if (objects?.count)! > 0 {
                    self.ary_itemList = objects
                    print("\(self.ary_itemList!)")
                    self.aCollection.reloadData()
                }
                
            } else {
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
            
         }
        

        
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ary_itemList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! ProductCell
        //cell.lbl_productName.text = "Product \(indexPath.row + 1)"
        //cell.lbl_price.text = "$\(indexPath.row * 11)"
        if let item = (self.ary_itemList![indexPath.row] as! PFObject)["Item"] as? PFObject {
            if let love = (item)["Brand"] {
            cell.lbl_productName.text = (love as! String)
            }
            else {
                cell.lbl_productName.text = ((item)["brand"] as! String)
            }
        }
        //cell.lbl_productName.text = "\(((self.ary_itemList![indexPath.row] as! PFObject)["Item"] as! PFObject)["brand"] ?? "")"
        if let item_price = (self.ary_itemList![indexPath.row] as! PFObject)["Item"] as? PFObject {
            let price = (item_price)["Price"] as! Int
            cell.lbl_price.text = "$\(price)"
        }
        //cell.lbl_price.text = "$\(((self.ary_itemList![indexPath.row] as! PFObject)["Item"] as! PFObject)["Price"]!)"

//        let user  = (self.ary_itemList![indexPath.row] as! PFObject)["User"]! as! PFUser
//        cell.lbl_userName.text = "\(user.username!)"
        // user i con image and product image
        
       if let coverImageFile = ((self.ary_itemList![indexPath.row] as! PFObject)["Item"] as? PFObject)
       {
        let item_img : PFFileObject = (coverImageFile)["CoverImage"] as! PFFileObject
        item_img.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
            let image = UIImage(data: imageData!)
            if image != nil {
                cell.img_product.image = image
            }
        })
      }
       
        
//        // icon user
//        if let ProfilePic = user["ProfilePic"] as? PFFile {
//            ProfilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
//                let image = UIImage(data: imageData!)
//                if image != nil {
//                    cell.img_userIcon?.image = image
//                }
//            })
//        }
       // cell.btn_like.addTarget(self, action: #selector(ProductListVC.btn_like(_:)), for: UIControlEvents.touchUpInside)
       // cell.btn_like.tag = indexPath.row
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
        
    {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.invalidateLayout()
        return CGSize(width: ((self.view.frame.width/2) - 0.5), height:((self.view.frame.width / 2) + 3))
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        
    {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegue(withIdentifier: "procut_detail", sender: indexPath.row)
    }
    
    @IBAction func btn_back(_ sender: Any)
        
    {
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
        if segue.identifier == "procut_detail" {
            let lvc  = segue.destination as! ProductDetailVC
            lvc.dic_product = (self.ary_itemList![sender as! Int] as! PFObject )["Item"] as! PFObject
        }
        
     }
    
    
}
