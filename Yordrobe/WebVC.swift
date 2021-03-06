//
//  WebVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/17/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit

class WebVC: UIViewController {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var web_View: UIWebView!
    
    var  str_title: String!
    var str_webLink: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lbl_title.text  = str_title
        
        web_View.delegate = self as? UIWebViewDelegate
        web_View.loadRequest(URLRequest(url: URL(string: str_webLink)!))
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
