//
//  ReusableView.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 8/10/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import ImageSlideshow

class ReusableView: UICollectionReusableView, UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet weak var view_slideShow: ImageSlideshow!
    @IBOutlet weak var bCollectionView: UICollectionView!
    
    var data : Array<Any> = []
    
    // Implementing custom delegate ..
    var delegate: HeaderDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! ProductCell
        
        let user  = (data[indexPath.row] as! PFObject) as! PFUser
        cell.lbl_firstName.text = "\(user["firstName"]!)"
        
        if let ProfilePic = user["ProfilePic"] as? PFFileObject {
            ProfilePic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.img_userIcon?.image = image
                }
            })
        }
        else{
            cell.img_userIcon?.image = UIImage(named: "userIcone")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "productDetail", sender: indexPath.item)
        print("# selected row == \(indexPath.item)")
        delegate?.headerTapped(sender: indexPath.item)
        
    }
    
   
}
