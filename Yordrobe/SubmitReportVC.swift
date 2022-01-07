//
//  SubmitReportVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/28/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import PopupDialog
import Parse


class SubmitReportVC: UIViewController {
    
    @IBOutlet weak var img_product: image_EditProfile!
    @IBOutlet weak var tv_reason: UITextView!
    var dic_product: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let ProfilePic = dic_product["CoverImage"] as? PFFileObject  {
            (ProfilePic ).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.img_product.image = image
                }
            })
        }
    }

    @IBAction func btn_submit(_ sender: Any) {
        if tv_reason.text!.isEmpty {
            showDialog(vc: self, title: "Error!", message: "Please leave a brief comment on why you are making this report")
        }
        else{
            let popup = PopupDialog(title: "Submit Report?", message: "Are you sure that you want to submit this report to Yordrobe for investigation?", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
                print("Completed")
            }
            let yes = DefaultButton(title: "Yes") {
                //self.label.text = "You ok'd the default dialog"
                self.API_report ()
            }
            let no = CancelButton(title: "No Thanks") {
                //self.label.text = "You ok'd the default dialog"
            }
            // Add buttons to dialog
            popup.addButtons([no, yes])
            self.present(popup, animated: true, completion: nil)
            
        }
    }
    
    func API_report ()  {
        showDialog(vc: self, title: "Success", message: "Your report has been submitted to Yordrobe. Thank you for taking the time to help improve Yordrobe.")
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
