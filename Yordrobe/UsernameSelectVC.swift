//
//  UsernameSelectVC.swift
//  Yordrobe
//
//  Created by Tamim on 27/11/21.
//  Copyright © 2021 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse

protocol UsernameSelectVCDelegate: AnyObject {
    func uniqueUsernameSelected(username: String)
}

class UsernameSelectVC: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: UsernameSelectVCDelegate?
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if let username = userName.text {
            isUsernameTaken(username: username)
        } else {
            showDialog(vc: self, title: "Error!", message: "Please choose your username")
        }
    }
    
    func isUsernameTaken(username: String) -> Void {
        //access PFUsers
        let query : PFQuery = PFUser.query()!
        query.whereKey("username",  equalTo: username.lowercased())
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if (objects?.count)! > 0 {
                    showDialog(vc: self, title: "Error!", message: "User name already taken please choose another one")
                    print("Exist")
                }
                else{
                    print("Username Not Exist")
                    DispatchQueue.main.async {
                        self.delegate?.uniqueUsernameSelected(username: username)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else{
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
    }
}
