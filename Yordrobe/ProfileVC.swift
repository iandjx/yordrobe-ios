//
//  ProfileVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/20/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_userID: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var lbl_listingCount: UILabel!
    @IBOutlet weak var lbl_ratingCount: UILabel!
    @IBOutlet weak var lbl_followersCount: UILabel!
    @IBOutlet weak var lbl_followingCount: UILabel!
    
    var isSelfUser:Bool = true
    var otherUser: PFUser!
    var user: PFUser!
    
    @IBOutlet weak var img_back: UIImageView!
    @IBOutlet weak var btn_setting: UIButton!
    @IBOutlet weak var lbl_profile: UILabel!
    
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var btn_profile: UIButton!
    
    // Follow btn 
    @IBOutlet weak var btn_followUnfollow: FollowUnfollowBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //view_secction.frame = CGRect(x: 0, y: 230, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 230 - 50)
        //view_list.frame = CGRect(x: 0, y: 230, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 230 - 50)
        
        view_secction.isHidden = false
        view_list.isHidden = true
        
        //update user
        
        if isSelfUser == false {
            btn_profile.isHidden = true
            btn_setting.isHidden = true
            btn_back.isHidden = false
            img_back.isHidden = false
            btn_add.isHidden = true
            btn_followUnfollow.isHidden = false
            user = otherUser
            print("user ============= \(user!)")
        }
        else {
            btn_profile.isHidden = false
            btn_setting.isHidden = false
            btn_back.isHidden = true
            img_back.isHidden = true
            btn_add.isHidden = false
            btn_followUnfollow.isHidden = true
            user = PFUser.current()!
            print("user == \(user)")
        }
        
        // managing frame of grid view
        if isSelfUser == false {
            colecton_list.frame = CGRect(x: 0, y: colecton_list.frame.origin.y, width: colecton_list.frame.size.width, height: colecton_list.frame.size.height + 55)
            colecton_section.frame = CGRect(x: 0, y: colecton_section.frame.origin.y, width: colecton_section.frame.size.width, height: colecton_section.frame.size.height + 55)
        }

        // Getting the list of section and Product...
        sectionList()
        productList()
        refreshSection.tintColor = .gray
        refreshSection.addTarget(self, action: #selector(refres_Section), for: .valueChanged)
        colecton_section.addSubview(refreshSection)
        colecton_section.alwaysBounceVertical = true
        
        refreshList.tintColor = .gray
        refreshList.addTarget(self, action: #selector(refresh_List), for: .valueChanged)
        colecton_list.addSubview(refreshList)
        colecton_list.alwaysBounceVertical = true

    }
    
    let refreshSection = UIRefreshControl()
    let refreshList = UIRefreshControl()

    @objc func refresh_List()  {
        productList()
    }
    
    @objc func refres_Section()  {
        sectionList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         updateUI()
    }
    
    var imagePicker = UIImagePickerController()

    
    @IBAction func btn_profile(_ sender: Any) {
        
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: "Choose your option !", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Select from gallery", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Open camera", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        API_uploadProfileImage(image: tempImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func API_uploadProfileImage(image: UIImage) -> Void {
        img_user.image = image
        let profilePic = PFFileObject(data: image.jpegData(compressionQuality: 0.5)!, contentType: "image/jpeg")
        if let user = PFUser.current() {
            user["ProfilePic"] = profilePic
            user.saveInBackground()
        }

    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func updateButtonTitle(completionHandler:@escaping ((_ btn_title: String) -> Void))   {
        let followQ = PFQuery(className:"Follows")
        followQ.whereKey("fromUser", equalTo: PFUser.current()!)
        followQ.whereKey("toUser", equalTo:user)
        
        followQ.getFirstObjectInBackground { (object, error) in
            if error == nil {
                if object != nil {
                    completionHandler("Unfollow")
                }
                else{
                    completionHandler("Follow")
                }
            }
            else{
                completionHandler("Follow")
            }
        }
    }
    
    @IBAction func btn_followUnfollow(_ sender: UIButton) {
        if btn_followUnfollow.titleLabel?.text == "Follow" {
            API_follow()
        }
        else if btn_followUnfollow.titleLabel?.text == "Unfollow" {
          API_unfollow()
        }
        
    }
    
    func API_unfollow() {
        self.view.addSubview(progressHUD)
        let item = PFQuery(className:"Follows")
        item.whereKey("fromUser", equalTo: PFUser.current()!)
        item.whereKey("toUser", equalTo: user)
        
        item.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    // Do something
                    self.btn_followUnfollow.setTitle("Follow", for: .normal)
                    object.deleteEventually()
                }
            } else {
                // There was a problem, check error.description
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
    }

    
    let progressHUD = ProgressHUD(text: "Loading..")
    func API_follow() {
        self.view.addSubview(progressHUD)
        let object = PFObject(className:"Follows")
        object["fromUser"] = PFUser.current()!
        object["fromName"] = PFUser.current()!.username
        object["toUser"] = user
        object["toName"] = user.username
        
        
        
        object.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                self.btn_followUnfollow.setTitle("Unfollow", for: .normal)
            } else {
                // There was a problem, check error.description
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            self.progressHUD.removeFromSuperview()
        }
        
    }

    func updateUI() {
        // Follow Unfollow btn 
        if isSelfUser == false {
            updateButtonTitle(completionHandler: { (title) in
                self.btn_followUnfollow.setTitle(title, for: .normal)
            })
        }
        
        
        
        lbl_userName.text = "\(user["firstName"] as? String ?? "") \(user["lastName"] as? String ?? "")"
        lbl_userID.text = "@\(user.username!)"
        
        if let address: String = user["suburb"] as? String {
            lbl_address.text = address 
        }
        
        img_user.setRounded()
        if let ProfilePic = user["ProfilePic"] as? PFFileObject {
            ProfilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.img_user.image = image
                }
            })
        }
        
        // Listing count ..
        let listingQuery = PFQuery(className: "Item")
        listingQuery.whereKey("Owner", equalTo: user)
        listingQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("Object== \(objects!.count)")
                
                if objects!.count > 0 {
                    self.lbl_listingCount.text = "\(objects!.count)"
                }
            }
            else {
                print(error ?? "")
            }
        }
        
        // Listing count ..
        let RatingQuery = PFQuery(className: "Rating")
        RatingQuery.whereKey("toUser", equalTo: user)
        RatingQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count > 0 {
                    self.lbl_ratingCount.text = "\(objects!.count)"
                }
            }
        }

        
        // Followers count ..
        let followerQuery = PFQuery(className: "Follows")
        followerQuery.whereKey("toUser", equalTo: user)
        followerQuery.whereKey("fromUser", notEqualTo: user)
        followerQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("followerQuery == \(objects!.count)")
                if objects!.count > 0 {
                    self.lbl_followersCount.text = "\(objects!.count)"
                }
                else{
                    self.lbl_followersCount.text = "0"
                }
            } else {
                print(error ?? "")
            }
        }
        
        // Followings count ..
        let followingQuery = PFQuery(className: "Follows")
        followingQuery.whereKey("fromUser", equalTo: user)
        followingQuery.whereKey("toUser", notEqualTo: user)
        followingQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                print("followingQuery == \(objects!.count)")
                if objects!.count > 0 {
                    self.lbl_followingCount.text = "\(objects!.count)"
                }
                else{
                    self.lbl_followingCount.text = "0"
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    
    var ary_section:Array! = []
    
    func sectionList() {
        
      //  ary_section.removeAll()
        
        let sectionQuery = PFQuery(className: "Section")
        sectionQuery.order(byDescending: "createdAt")
        sectionQuery.whereKey("User", equalTo: user)
       
        //sectionQuery.includeKey("Item")
        
        sectionQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                self.ary_section.removeAll()
                for object in objects! {
                    
                    let itemQuery = PFQuery(className: "Item")
                    //itemQuery.isEqual(object)
                     itemQuery.order(byDescending: "createdAt")
                    itemQuery.whereKey("Section", equalTo: object["Name"])
                    itemQuery.whereKey("Owner", equalTo: self.user)
                    itemQuery.order(byDescending: "createdAt")
                   
                    itemQuery.findObjectsInBackground(block: { (objects, error) in
                        if error == nil {
                            if (objects?.count)! > 0 {
                                self.ary_section.append(objects![0])
                            }
                            else{
                                 self.ary_section.append(object["Name"])
                            }
                        }
                        else{
                            showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                        }
                        self.colecton_section.reloadData()
                    })
                }
                self.colecton_section.reloadData()
            }
            else
            {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
            self.refreshSection.endRefreshing()
        }
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == colecton_section
        {
            return ary_section.count
        }
        else
        {
            return ary_productList.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! ProductCell
        if collectionView == colecton_section
        {
            let section = indexPath
            print(section)
            if self.ary_section![indexPath.row] is PFObject {
                cell.lbl_sectionName.text = "\((self.ary_section![indexPath.item] as! PFObject)["Section"]!)"
                let coverImageFile = (self.ary_section![indexPath.row] as! PFObject)["CoverImage"]! as! PFFileObject
                coverImageFile.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        cell.img_product.image = image
                    }
                })
            }
            else
            {
                cell.lbl_sectionName.text = "\(self.ary_section![indexPath.row] as! String)"
                cell.img_product.image = UIImage(named: "defaultProduct")
            }
        }
        else  if collectionView == colecton_list
        {
            cell.lbl_brandName.text = "\((self.ary_productList![indexPath.row] as! PFObject)["brand"] ?? "")"
            cell.lbl_price.text = "$\((self.ary_productList![indexPath.row] as! PFObject)["Price"]!)"
           if let coverImageFile = (self.ary_productList![indexPath.row] as! PFObject)["CoverImage"]! as? PFFileObject
           {
                coverImageFile.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil
                    {
                        cell.img_product.image = image
                    }
                })
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
        
    {
        if collectionView == colecton_section
        {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5)
            layout.minimumInteritemSpacing = 2
            layout.minimumLineSpacing = 2
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/3) - 5), height:((self.view.frame.width / 3) + 35))
        }
        else
        {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            layout.invalidateLayout()
            return CGSize(width: ((self.view.frame.width/2) - 0.5), height:((self.view.frame.width / 2) + 25))
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        
    {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if collectionView == colecton_section
        {
            self.performSegue(withIdentifier: "SectionDetailVC", sender: indexPath.item)
        }
        else
        {
            self.performSegue(withIdentifier: "procut_detail", sender: indexPath.item)
        }
    }
    
    @IBOutlet var view_secction: UIView!
    @IBOutlet var view_list: UIView!
    @IBOutlet weak var colecton_section: UICollectionView!
    @IBOutlet weak var colecton_list: UICollectionView!
    @IBOutlet weak var btn_section: UIButton!
    @IBOutlet weak var btn_list: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBAction func btn_section(_ sender: UIButton)
    {
        sender.isSelected = true
        btn_list.isSelected = false
        view_secction.isHidden = false
        view_list.isHidden = true
    }
    @IBAction func btn_list(_ sender: UIButton)
    {
        sender.isSelected = true
        btn_section.isSelected = false
        view_secction.isHidden = true
        view_list.isHidden = false
        //productList()
    }
    
    var ary_productList:Array! = []
    
    func productList()
    {
        let productListQuery = PFQuery(className: "Item")
        productListQuery.whereKey("Owner", equalTo: user)
        productListQuery.includeKey("Owner")
        productListQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                // print("Object count == \(objects!.count)")
                if objects!.count > 0
                {
                    self.ary_productList = objects
                    print(" ary_productList== \(self.ary_productList!)")
                    self.colecton_list.reloadData()
                }
            }
            else
            {
                showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
            }
            self.refreshList.endRefreshing()
        }
    }
    
    @IBAction func btn_rating(_ sender: Any)
    {
        //if lbl_ratingCount.text != "0" {
            self.performSegue(withIdentifier: "RatingListVC", sender: nil)
        //}
    }
    
    var str_followerORfollowing: String!
    
    
    @IBAction func btn_followers(_ sender: Any)
    {
        if lbl_followersCount.text != "0"
        {
            str_followerORfollowing = "FOLLOWERS"
            self.performSegue(withIdentifier: "followerANDfollowing", sender: str_followerORfollowing)
        }
        else
        {
            if isSelfUser == true {
                showDialog(vc: self, title: "Oops!", message: "You have no followers")
            }
            else{
                showDialog(vc: self, title: "Oops!", message: "This Yordrober has no followers")
            }
        }
    }
    
    @IBAction func btn_following(_ sender: Any)
        
    {
        if lbl_followingCount.text != "0"
        {
            str_followerORfollowing = "FOLLOWING"
            self.performSegue(withIdentifier: "followerANDfollowing", sender: str_followerORfollowing)
        }
        else
        {
            if isSelfUser == true
            {
                showDialog(vc: self, title: "Error!", message: "You are not following any awesome Yordrobers")
            }
            else
            {
                showDialog(vc: self, title: "Oops!", message: "This Yordrober has no following")
            }
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "followerANDfollowing"
        {
            let lvc  = segue.destination as! FollowAndFollowingVC
            lvc.str_followerORfollowing = sender as! String
            lvc.isSelfUser = isSelfUser
            lvc.otherUser = user
        }
            
        else if segue.identifier == "SectionDetailVC"
        {
            if ary_section![sender as! Int] is PFObject
            {
                let lvc  = segue.destination as! SectionDetailVC
                lvc.dic_section = ary_section![sender as! Int] as! PFObject
                lvc.isSelfUser  = isSelfUser
            }
            else
            {
                if isSelfUser == false
                {
                    showDialog(vc: self, title: "Oops!", message: "There are no item exist in this wardrobe")
                }
                else
                {
                    let popup = PopupDialog(title: "Delete?", message: "Are you sure you want to delete this wardrobe?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
                        print("Completed")
                    }
                    let yes = DefaultButton(title: "Confirm")
                    {
                        self.API_deleteWordrobe(wordrobeName: self.ary_section![sender as! Int] as! String)
                    }
                    let no = CancelButton(title: "No Thanks")
                    {
                        
                    }
                    // Add buttons to dialog
                    popup.addButtons([no, yes])
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
            
        else if segue.identifier == "procut_detail"
        {
            let lvc  = segue.destination as! ProductDetailVC
            lvc.dic_product = self.ary_productList![sender as! Int] as! PFObject
        }
        else if segue.identifier == "RatingListVC"
        {
            let lvc  = segue.destination as! RatingListVC
            lvc.isSelfUser = false
            lvc.otherUser = user
        }
    }
    
    func API_deleteWordrobe(wordrobeName: String)  {
        
        print("wordrobe name == \(wordrobeName)")
        
        let sectionQ = PFQuery(className: "Section")
        sectionQ.whereKey("Name", equalTo: wordrobeName)
        sectionQ.whereKey("User", equalTo: PFUser.current()!)
        sectionQ.getFirstObjectInBackground { (object, error) in
            if error == nil {
                object?.deleteInBackground(block: { (isDeleted, error) in
                    if error == nil {
                        showDialog(vc: self, title: "Done!", message: "Wardrobe deleted successfully")
                        self.sectionList()
                    }
                    else{
                        showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                    }
                })
            }
            else{
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
        
        
    }
    
    
    @IBAction func btn_addSection(_ sender: Any) {
        showCustomDialog()
    }
    // Create a custom view controller
    let SectionVC = SectionPopUp(nibName: "SectionPopUp", bundle: nil)
    
    func showCustomDialog() {
        
        // Create the dialog
        let popup = PopupDialog(viewController: SectionVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
            
        }
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "DONE", height: 60) {
            
            if self.SectionVC.tf_sectionName.text!.isEmpty {
                showDialog(vc: self, title: "Error!", message: "Please Enter Your Section Name")
            }
            else{
                self.createSection()
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func createSection()  {
        
        let section = PFObject(className:"Section")
        section["Name"] = self.SectionVC.tf_sectionName.text!
        section["User"] = PFUser.current()
        section.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                self.SectionVC.tf_sectionName.text = ""
                 self.sectionList()
            } else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
            }
        }
    }
    
    @IBAction func btn_back(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
}

