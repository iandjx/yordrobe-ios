//
//  ProductDetailVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/21/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ImageSlideshow
import PopupDialog

class ProductDetailVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var scrl_productImage: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_userID: UILabel!
    @IBOutlet weak var lbl_viewsCount: UILabel!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet weak var lbl_condition: UILabel!
    @IBOutlet weak var lbl_size: UILabel!
    @IBOutlet weak var lbl_shipping: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_likeCount: UILabel!
    @IBOutlet weak var lbl_commentCount: UILabel!

    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var btn_comment: UIButton!
    
    var dic_product: PFObject!
    
    @IBOutlet weak var btn_follow: UIButton!
    
    @IBOutlet weak var btn_buy: UIButton!
    @IBAction func btn_buy(_ sender: Any) {
        self.performSegue(withIdentifier: "confirmVC", sender: nil)
    }
    
    @IBOutlet weak var view_slideShow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dicProduct === \(dic_product!)")
        
        // Do any additional setup after loading the view.
        if let views = dic_product!["ViewsCount"] {
            lbl_viewsCount.text = "Views: \(views)"
        }
        dic_product.incrementKey("ViewsCount", byAmount: 1)
        dic_product.saveInBackground()    
    
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("hastag Selected!")
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        ary_image.removeAll()
        
        
        if PFUser.current()!.objectId == (dic_product!["Owner"] as! PFUser).objectId {
            btn_follow.isHidden = true
        }
        
        let user  = dic_product?["Owner"] as? PFUser
        lbl_userName.text = "\(String(describing: user?["firstName"] ?? "")) \(String(describing: user?["lastName"] ?? ""))"
        lbl_userID.text = "@\(String(describing: user?.username ?? ""))"
        
        if PFUser.current()?.username == (dic_product?["Owner"] as? PFUser)?.username {
            btn_buy.isHidden = true
        }
        else if dic_product["soldDate"] != nil {
            btn_buy.setTitle("SOLD", for: .normal)
            btn_buy.isEnabled = false
        }
      
            if let ProfilePic = user?["ProfilePic"] as? PFFileObject
            {
                (ProfilePic ).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        self.btn_user.setBackgroundImage(image, for: .normal)
                        //self.img_user.image = image
                    }
                })
            }
        
        lbl_title.text = "\(dic_product?["Brand"] ?? "")"
        //self.tv_description.delegate = self
        self.tv_description.attributedText = tv_description.convertHashtags(text: "\(dic_product?["Description"] ?? "")")
        lbl_condition.text = "\(dic_product?["Condition"] ?? "")"
        lbl_size.text = "Size: \(String(describing: dic_product?["Size"] ?? ""))"
        if dic_product?["ExpresCost"] != nil {
        lbl_shipping.text = "Shipping: Std: $\(dic_product?["StandardCost"] ?? "0"), Exp: $\(dic_product?["ExpresCost"] ?? "0")"
        }
        else {
            lbl_shipping.text = "Shipping: Std: $\(dic_product?["StandardCost"] ?? "0"), Exp: $\(dic_product?["ExpressCost"] ?? "0")"
        }
        lbl_price.text = "$\(dic_product?["Price"] ?? "")"
        
        // Check if product is already liked  ..
        
        let likeQuery = PFQuery(className: "Love")
        likeQuery.whereKey("User", equalTo: PFUser.current()!)
        likeQuery.whereKey("Item", equalTo: dic_product!)
        
        likeQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.btn_like.isSelected = true
                }
                // Print("Object== \(objects!)")
            } else {
                print(error ?? "")
            }
        }
        
        // like count
        let likecount = PFQuery(className: "Love")
        likecount.whereKey("Item", equalTo: dic_product!)
        likecount.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.lbl_likeCount.text = "\(objects!.count)"
                }
                // Print("Object== \(objects!)")
            } else {
                print(error ?? "")
            }
        }
        
        // comment count
        let commentcount = PFQuery(className: "Comment")
        commentcount.whereKey("item", equalTo: dic_product!)
        commentcount.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.lbl_commentCount.text = "\(objects!.count)"
                }
                // Print("Object== \(objects!)")
            } else {
                print(error ?? "")
            }
        }
        
       // product images ...
        
        if let coverImageFile = dic_product["CoverImage"] as? PFFileObject {
            ary_image.append(coverImageFile)
        }
        if let Image2 = dic_product["Image2"] {
            ary_image.append(Image2 as! PFFileObject)
        }
        if let Image3 = dic_product["Image3"] {
            ary_image.append(Image3 as! PFFileObject)
        }
        if let Image4 = dic_product["Image4"] {
            ary_image.append(Image4 as! PFFileObject)
        }
        
        showImages()
        
        // Check is user is following
        
        let 🖼 = PFQuery(className: "Follows")
        🖼.whereKey("fromUser", equalTo: PFUser.current()!)
        
        if let owner = dic_product["Owner"] {
            🖼.whereKey("toUser", equalTo: owner)
        }
        🖼.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.btn_follow.isSelected = true
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    @IBOutlet weak var btn_user: UIButton!
    @IBAction func btn_user(_ sender: Any) {
        
        if PFUser.current()!.objectId != (dic_product!["Owner"] as! PFUser).objectId {
            let lvc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            lvc.isSelfUser = false
            lvc.otherUser = dic_product!["Owner"]! as! PFUser
            self.navigationController?.pushViewController(lvc, animated: true)
        }
    }
    

    
    var ary_image = [PFFileObject]()
    
    func showImages() {
        
        view_slideShow.backgroundColor = UIColor.white
        view_slideShow.slideshowInterval = 2.5
        view_slideShow.pageControlPosition = PageControlPosition.underScrollView
        view_slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        view_slideShow.pageControl.pageIndicatorTintColor = UIColor.black
        view_slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit

        
        var imageList = [ImageSource]()
        
        for image in ary_image {
            
            image.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let imagedata = UIImage(data: imageData!)
                    //img_product.image = image
                    imageList.append(ImageSource(image: imagedata!))
                //print("image list == \(imageList)")
                self.view_slideShow.setImageInputs(imageList)
            })
        }
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        //slideshow.activityIndicator = DefaultActivityIndicator()
        view_slideShow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        //view_slideShow.setImageInputs(imageList)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view_slideShow.addGestureRecognizer(recognizer)
        
    }

    @objc func didTap() {
         view_slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    let progressHUD = ProgressHUD(text: "Loading..")
    
    @IBAction func btn_follow(_ sender: UIButton) {
        
        self.view.addSubview(progressHUD)
        
        if sender.isSelected == true {
            sender.isSelected = false
            unFollow()
        }
        else{
            sender.isSelected = true
            Follow()
        }
    }
    
    func unFollow() {
        
        let item = PFQuery(className:"Follows")
        item.whereKey("fromUser", equalTo: PFUser.current()!)
        item.whereKey("toUser", equalTo: dic_product!["Owner"] as! PFUser)
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

    func Follow() {
        
        let object = PFObject(className:"Follows")
        object["fromUser"] = PFUser.current()
        object["fromName"] = PFUser.current()!.username
        object["toUser"] = dic_product!["Owner"] as! PFUser
        object["toName"] = (dic_product!["Owner"] as! PFUser).username
        
        object.saveInBackground {
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
    
    
    @IBAction func btn_like(_ sender: UIButton) {
        self.view.addSubview(progressHUD)
        if sender.isSelected == true
        {
            sender.isSelected = false
            self.API_disLike()
        }
        else
        {
            sender.isSelected = true
            self.API_like()
        }
    }
    
    func API_like()
    {
        let likeCount: Int = Int(lbl_likeCount.text!)!
        lbl_likeCount.text = "\(likeCount + 1)"
        let item = PFObject(className:"Love")
        item["Item"] = self.dic_product
        item["User"] = PFUser.current()
//        let postACL = PFACL.init(user: PFUser.current()!)
//     //   postACL.setReadAccess(true, for: PFUser.current()!)
//        postACL.setWriteAccess(true, for: PFUser.current()!)
//        item.acl = postACL
        item.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success)
            {
                // The object has been saved.
                print("data save successfully.. ")
            }
            else
            {
                // There was a problem, check error.description
                print("data not save successfully.. ")
                self.lbl_likeCount.text = "\(likeCount - 1)"
            }
            self.progressHUD.removeFromSuperview()
        }
    }
    
    func API_disLike()
    {
        let likeCount: Int = Int(lbl_likeCount.text!)!
        lbl_likeCount.text = "\(likeCount - 1)"
        
        let item = PFQuery(className:"Love")
        item.whereKey("User", equalTo: PFUser.current()!)
        item.whereKey("Item", equalTo: dic_product!)
        item.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // Do something
                    object.deleteEventually()
                }
            } else {
                print(error ?? "")
                self.lbl_likeCount.text = "\(likeCount + 1)"
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    @IBAction func btn_commnet(_ sender: Any) {
        self.performSegue(withIdentifier: "CommentVC", sender: nil)
    }
    
    
    @IBAction func btn_back(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
//        self.navigationController?.pushViewController(vc, animated: false)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btn_share(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "SHARE TO", message: "", preferredStyle: .actionSheet)
        
        var text = ""
        
        let shareToSocialMedia = UIAlertAction(title: "Facebook", style: .default) { action -> Void in
            print("Facebook")
            // text to share
            if (self.dic_product!["Brand"]) != nil {
              text = "BUY this great \(self.dic_product!["Brand"]!) fashion piece for \(self.dic_product!["Price"]!) $ on Yordrobe today!"
            }
            else {
                  text = "BUY this great \(self.dic_product!["brand"]!) fashion piece for \(self.dic_product!["Price"]!) $ on Yordrobe today!"
            }
            
            if let productPic = self.dic_product["CoverImage"] as? PFFileObject  {
                productPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        //self.img_user.image = image
                        self.shareToSocialMedia(text: text, profuctImage: image!)
                    }
                })
                
            }

        }
        actionSheetController.addAction(shareToSocialMedia)
        //
        let shareToYordrobe = UIAlertAction(title: "Yordrobe", style: .default) { action -> Void in
            print("Yordrobe")
            self.shareToYordrobe()
        }
        actionSheetController.addAction(shareToYordrobe)
        //
        let report = UIAlertAction(title: "Report as Inappropriate", style: .default) { action -> Void in
            print("Inappropriate")
            self.performSegue(withIdentifier: "SubmitReportVC", sender: nil)
        }
        actionSheetController.addAction(report)
        //
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        //
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func shareToSocialMedia(text: String, profuctImage: UIImage) {
        
        let url = "https://itunes.apple.com/au/app/yordrobe/id802864021?mt=8"

        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [text,profuctImage,url], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func shareToYordrobe() {
        let popup = PopupDialog(title: "SHARE ITEM", message: "Would you like to send all of your followers a notification about this item?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            print("Completed")
        }
        
        let yes = DefaultButton(title: "Yes") {
            //self.label.text = "You ok'd the default dialog"
            showDialog(vc: self, title: "Share This Item", message: "Great! We'll let all of your followers know about this item. This will happen in the background so please continue using the app and see what other great pieces you can find.")
            self.sendNotification()
        }
        let no = CancelButton(title: "No Thanks")
        {
            //self.label.text = "You ok'd the default dialog"
        }
        // Add buttons to dialog
        popup.addButtons([no, yes])
        self.present(popup, animated: true, completion: nil)
    }
    
    func sendNotification() {
        // Implement notification functionality here ...
    }
    

    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
        print("current index == %@", currentPage)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
{
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CommentVC" {
            let lvc = segue.destination as! CommentVC
            lvc.item = dic_product!
        }
        else if segue.identifier == "confirmVC" {
            let lvc  = segue.destination as! ConfirmPayVC
            lvc.dic_product = dic_product
        }
        else if segue.identifier == "SubmitReportVC" {
            let lvc  = segue.destination as! SubmitReportVC
            lvc.dic_product = dic_product
        }
    }
}
