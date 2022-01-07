//
//  DropDescriptionVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/21/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class DropDescriptionVC: UIViewController {
    @IBOutlet weak var scrl_main: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.perform(#selector(adjustScroll), with: self, afterDelay: 0.3)
        
    }
    
    @objc func adjustScroll() {
        scrl_main.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var btn_noThanks: UIButton!
    @IBAction func btn_noThanks(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var btn_yesPlease: UIButton!
    @IBAction func btn_yesPlease(_ sender: Any) {
        self.performSegue(withIdentifier: "DropDetailVC", sender: nil)
    }
    
    
    @IBAction func btn_termAndCond(_ sender: Any) {
        self.performSegue(withIdentifier: "WebVC", sender: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "WebVC"{
            let lvc = segue.destination as! WebVC
            lvc.str_title = "Terms & Conditions"
            lvc.str_webLink = "http://www.yordrobe.com.au/terms"
        }
    }
    

}
