//
//  ProductListVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/17/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ImageSlideshow


class ProductListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var aCollection: UICollectionView!
    
    var reusableView: ReusableView?
    var isDiscover:Bool! = false
  
    var strBrand:String!
    var strTag:String!

    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var lbl_brandName: UILabel!
    @IBOutlet weak var img_back: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // getting the list of banners
        
        API_bannerList()
        refreshList.tintColor = .gray
        refreshList.addTarget(self, action: #selector(refresh_List), for: .valueChanged)
        aCollection.addSubview(refreshList)
        aCollection.alwaysBounceVertical = true
        
        if isDiscover {
            aCollection.frame = CGRect(x: 0, y: 65, width: aCollection.frame.size.width, height: aCollection.frame.size.height + 55)
        }
    }
    
    let refreshList = UIRefreshControl()
    @objc func refresh_List()  {
        API_getProduct()
    }
    
    var imageList = [ImageSource]()

    
    func API_bannerList() {
        // Banner Image
        imageList.removeAll()
        
        let bannerImageList = PFQuery(className: "FeedBannerImage")
        bannerImageList.whereKey("Active", equalTo: true)
        bannerImageList.addAscendingOrder("DisplayOrder")
        
        bannerImageList.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                for object in objects! {
                    (object["ImageResHigh"] as! PFFileObject).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                        let imagedata = UIImage(data: imageData!)
                        if imagedata != nil {
                            //img_product.image = image
                            self.imageList.append(ImageSource(image: imagedata!))
                            self.aCollection.reloadData()
                        }
                        //print("image list == \(imageList)")
                        //self.view_slideShow.setImageInputs(imageList)
                    })
                }
                
                // Print("Object== \(objects!)")
            } else {
                print(error ?? "")
            }
            // Getting list of wordrobe user
            self.API_wordrobeList()
        }
        
    }

    func API_wordrobeList() {
        
        let query = PFUser.query()!
        query.whereKey("username", notEqualTo: PFUser.current()!.username!)
        query.whereKey("firstName", notEqualTo: NSNull())
        query.addDescendingOrder("Followers")
        query.limit = 10
        
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                self.reusableView?.data = objects!
                self.reusableView?.bCollectionView.reloadData()
            } else {
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
        //Done Mayank
        API_getProduct()
        
        let defaults = UserDefaults.standard
        let userLogin = defaults.bool(forKey: "isPopUp")
        
        if userLogin == false {
            
            defaults.set(true, forKey: "isPopUp")
            showAlertMessage(vc: self, titleStr: "", messageStr: "Great News! Yordrobe is currently free from all fees until further notice, list your items today to receive full payment on all your listings before the 10% commission kicks in. Enjoy!")
        }
        
      
        
     
    
}

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
}

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        //print("dic_filterProduct  = \(appDelegate.dic_filterProduct!)")
        
        if isDiscover == true {
            btn_back.isHidden = false
            lbl_brandName.isHidden = false
            if strBrand == "no" {
                lbl_brandName.text = strTag
            }
            else{
                lbl_brandName.text = strBrand
            }
            img_back.isHidden = false
            img_logo.isHidden = true
            btn_filter.isHidden = true
            
            //API_getProduct()
        }
        else{
            
            btn_back.isHidden = true
            lbl_brandName.isHidden = true
            img_back.isHidden = true
            img_logo.isHidden = false
            btn_filter.isHidden = false

            
            if appDelegate.dic_filterProduct.count > 0  {
                API_filterProduct()
            }
            else{
                // Mayank
                //API_getProduct()
            }
        }
        
        
    }
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func API_filterProduct() {
        
        self.view.addSubview(progressHUD)
        
        let item_query = PFQuery(className:"Item")
        //item_query.order(byAscending: "updatedAt")
        item_query.includeKey("Owner")
        
        for (key, value) in appDelegate.dic_filterProduct {
            print("key: \(key)")
            print("value: \(value)")
            
            if key as! String == "sort_order"{
                if value as! String == "Most Recent" {
                    item_query.order(byDescending: "updatedAt")
                }
                else if value as! String == "Price High to Low" {
                    item_query.order(byDescending: "Price")
                }
                else if value as! String == "Price Low to High" {
                    item_query.order(byAscending: "Price")
                }
            }
            else if key as! String == "brand" {
                item_query.whereKey("brand", equalTo: value)
            }
            else if key as! String == "category" {
                item_query.whereKey("Category", equalTo: value)
            }
            else if key as! String == "sub_category" {
                item_query.whereKey("SubCategory", equalTo: value)
            }
            else if key as! String == "size" {
                item_query.whereKey("Size", equalTo: value)
            }
            else if key as! String == "colour" {
                item_query.whereKey("Colour", equalTo: value)
            }
            else if key as! String == "price_range" {
                if value as! String == "$20 - $50" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 20)
                    item_query.whereKey("Price", lessThanOrEqualTo: 50)
                }
                else if value as! String == "$50 - $100" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 50)
                    item_query.whereKey("Price", lessThanOrEqualTo: 100)
                }
                else if value as! String == "$100 - $200" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 100)
                    item_query.whereKey("Price", lessThanOrEqualTo: 200)
                }
                else if value as! String == "$200 - $300" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 200)
                    item_query.whereKey("Price", lessThanOrEqualTo: 300)
                }
                else if value as! String == "$300 - $400" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 300)
                    item_query.whereKey("Price", lessThanOrEqualTo: 400)
                }
                else if value as! String == "$400 - $500" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 400)
                    item_query.whereKey("Price", lessThanOrEqualTo: 500)
                }
                else if value as! String == "> $500" {
                    item_query.whereKey("Price", greaterThanOrEqualTo: 500)
                }
            }
            else if key as! String == "condition" {
                item_query.whereKey("Condition", equalTo: value)
            }
        }
        item_query.limit = 10000
        item_query.findObjectsInBackground { (objects, error) -> Void in
            
            if error == nil {
                self.ary_item = objects
               // print("\(self.ary_item!)")
                self.aCollection.reloadData()
                
            } else {
                print(error ?? "")
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    var ary_item: Array! = []
    let progressHUD = ProgressHUD(text: "Loading..")
    func API_getProduct() {
        
        //print("BrandName == \(str_brandName!)")
        
        self.view.addSubview(progressHUD)
        let item_query = PFQuery(className:"Item")
        
        if isDiscover == true {
            if strBrand == "no" {
                item_query.whereKey("Description", matchesRegex: "#" + strTag, modifiers: "i")
            }
            else
            {
                item_query.whereKey("brand", equalTo: strBrand)
            }
        }

        item_query.order(byDescending: "createdAt")
        //item_query.order(byAscending: "updatedAt")
        item_query.includeKey("Owner")
        item_query.limit = 10000
        item_query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.ary_item = objects
                    //print(self.ary_item.count)
                    self.aCollection.reloadData()
                }
            }
            else
            {
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
//            self.aCollection.reloadData()
            
            self.progressHUD.removeFromSuperview()
            self.refreshList.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UICollectionViewDataSource protocol
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    {
        return ary_item.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        
    {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! ProductCell
        cell.lbl_productName.text = "\(String(describing: (self.ary_item?[indexPath.row] as? PFObject)?["brand"] ?? ""))"
        cell.lbl_price.text = "$\(String(describing: (self.ary_item?[indexPath.row] as? PFObject)?["Price"] ?? ""))"
        
        if  ((self.ary_item[indexPath.item] as! PFObject)["soldDate"]) != nil
        {
            cell.img_sold.isHidden = false
        }
        else
        {
            cell.img_sold.isHidden = true
        }
        
//        guard  ((self.ary_item[indexPath.row] as! PFObject)["Owner"]) != nil else {
//            cell.lbl_userName.text = ""
//            cell.img_userIcon?.image = UIImage(named: "userIcon")
//            return cell
//        }
        print((self.ary_item![indexPath.row] as! PFObject))
        let user  = (self.ary_item![indexPath.row] as! PFObject)["Owner"]! as! PFUser
        cell.lbl_userName.text = "\(user.username!)"
        cell.btn_like.addTarget(self, action: #selector(ProductListVC.btn_like(_:)), for: .touchUpInside)
        cell.btn_like.tag = indexPath.row
        
        // Like button ..
        
        let likeQuery = PFQuery(className: "Love")
        likeQuery.whereKey("User", equalTo: PFUser.current()!)
        likeQuery.whereKey("Item", equalTo: self.ary_item[indexPath.row])
        likeQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    cell.btn_like.isSelected = true
                }
                else{
                    cell.btn_like.isSelected = false
                }
            }
        }
        
        // user icon image and product image
        if ((self.ary_item![indexPath.row] as! PFObject)["CoverImage"] != nil)
        {
            let coverImageFile = (self.ary_item![indexPath.row] as! PFObject)["CoverImage"]! as! PFFileObject
            coverImageFile.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_product.image = image
                }
            })
        }
        
        
        // icon user
        if let ProfilePic = user["ProfilePic"] as? PFFileObject {
            ProfilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                if(imageData != nil)
                {
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_userIcon?.image = image
                    }
                }
                else
                {
                   cell.img_userIcon.image = UIImage(named: "userIcone")
                }
                               }
            )
        }
        else {
            cell.img_userIcon.image = UIImage(named: "userIcone")
        }
        
        
        return cell
    }
    
    @IBAction func btn_like(_ sender: UIButton) {
        
        self.view.addSubview(progressHUD)
        if sender.isSelected == true {
            sender.isSelected = false
            self.API_disLike(index: sender.tag)
        }
        else{
            sender.isSelected = true
            self.API_like(index: sender.tag)
        }
    }
    
    func API_like(index:Int) {
        
        let item = PFObject(className:"Love")
        item["Item"] = self.ary_item[index]
        item["User"] = PFUser.current()
        
        item.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
            } else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
            }
            self.progressHUD.removeFromSuperview()
        }

    }
    
    func API_disLike(index: Int) {
        
        let item = PFQuery(className:"Love")
        item.whereKey("User", equalTo: PFUser.current()!)
        item.whereKey("Item", equalTo: self.ary_item[index])
        item.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // Do something
                    object.deleteEventually()
                }
            } else {
                print(error ?? "")
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if collectionView == aCollection {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/2) - 0.5), height:((self.view.frame.width / 2) + 43))
        }
        else
        {
            return CGSize(width: 70, height:56)
        }
    }
    
   // let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.reusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "customHeader", for: indexPath) as! ReusableView) //Storing the reference to reusableView
        self.reusableView?.view_slideShow?.backgroundColor = UIColor.white
        self.reusableView?.view_slideShow?.slideshowInterval = 2.0
        self.reusableView?.view_slideShow?.pageControlPosition = PageControlPosition.insideScrollView
        self.reusableView?.view_slideShow?.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.reusableView?.view_slideShow?.pageControl.pageIndicatorTintColor = UIColor.black
        self.reusableView?.view_slideShow?.contentScaleMode = UIViewContentMode.scaleAspectFill
        self.reusableView?.delegate = self
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        //self.reusableView?.view_slideShow.activityIndicator = DefaultActivityIndicator()
        self.reusableView?.view_slideShow?.currentPageChanged = { page in
            //print("current page:", page)
        }
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        self.reusableView?.view_slideShow?.setImageInputs(imageList)
        print("local source == \(imageList)")
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductListVC.didTap(_ : )))
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductListVC.labelTicked(withSender: )))
        self.reusableView?.view_slideShow.currentSlideshowItem?.tag = indexPath.row
        //self.reusableView?.view_slideShow?.addGestureRecognizer(recognizer)
        self.reusableView?.view_slideShow.currentSlideshowItem?.addGestureRecognizer(recognizer)
        return self.reusableView!
    }
    
    @objc func didTap(sender: UIGestureRecognizer)
        
    {
         let tag = sender.view!.tag
        //self.reusableView?.view_slideShow?.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        print("tap sucess = \(tag)")
        self.performSegue(withIdentifier: "EarnRevardVC", sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)

    {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegue(withIdentifier: "productDetail", sender: indexPath.item)
    }
    
    @IBAction func btn_filter(_ sender: Any)
    {
        self.performSegue(withIdentifier: "FilterVC", sender: nil)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
     {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "productDetail"{
            let lvc  = segue.destination as! ProductDetailVC
            lvc.dic_product = self.ary_item![sender as! Int] as! PFObject
        }
     }

    @IBAction func btn_back(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
}

protocol HeaderDelegate {
    func headerTapped(sender: Int)
}

extension ProductListVC: HeaderDelegate {
    func headerTapped(sender: Int) {
        let lvc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        lvc.isSelfUser = false
        lvc.otherUser = self.reusableView?.data[sender] as! PFUser
        self.navigationController?.pushViewController(lvc, animated: true)
        
    }
}
