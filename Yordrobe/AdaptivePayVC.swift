//
//  AdaptivePayVC.swift
//  Yordrobe
//
//  Created by Sanjay Pal on 6/21/18.
//  Copyright © 2018 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import Alamofire
class AdaptivePayVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var activitiy: UIActivityIndicatorView!
    
      var  details: NSMutableDictionary = [:]
    
    var dic_product_save: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(details)
        print(dic_product_save)

        // Do any additional setup after loading the view.
//        let baseUrl = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
//        let payKey = details["payKey"] as! String
//        let addPayKey = baseUrl + payKey
        
        
        webView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "index", ofType: "html")!)))
      
        
     //   lvc.dic_product = self.ary_item![sender as! Int] as! PFObject
        
//        let url = URL(string: addPayKey )
//        if let unwrappedURL = url {
//
//            let request = URLRequest(url: unwrappedURL)
//            let session = URLSession.shared
//
//            let task = session.dataTask(with: request) { (data, response, error) in
//
//                if error == nil {
//
//                    self.webView.loadRequest(request)
//
//                } else {
//
//                    print("ERROR: \(String(describing: error))")
//
//                }
//
//            }
//
//            task.resume()
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func webViewDidStartLoad(_ webView: UIWebView) {
         activitiy.startAnimating()
          activitiy.isHidden = false
       // print("Started navigating to url \(String(describing: webView.url))");
        
        if let currentURL = webView.request?.url?.absoluteString{
            
            print(currentURL)
            
            if currentURL ==  "https://paypal.com/" {
                
                retriveTransactionID()
                
                activitiy.stopAnimating()
                activitiy.isHidden = true
                
                print("data save successfully.. ")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPurchaseVC") as! MyPurchaseVC
                vc.controllerName  =  "Confirm"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
//        let url = URL(string: "https://example.com/")
//        let  url1 = webView.url!
//
//
//        if url ==  url1 {
//
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        activitiy.stopAnimating()
        activitiy.isHidden = true
        
       
    }

    func updateRecordToDatabse(totalAmount: String, trackID: String) {
        
        //self.view.addSubview(progressHUD)
        
        print(details)
        
        let strAmount = details["totalPrice"] as! String
       let final_amount = strAmount.replacingOccurrences(of: "$", with: "")
        
        print("totalAmount = \(totalAmount)\ntrackID == \(trackID)")
        
        let itemSale = PFObject(className:"ItemSale")
        itemSale["trackingNumber"] = trackID
        itemSale["item"] = details["item"]
        //item["shipToName"] = category
        itemSale["totalPrice"] = Int(final_amount) //details["totalPrice"]""
        itemSale["shipingMethod"] = details["shipingMethod"]
        itemSale["buyer"] = (details["buyer"] as! PFUser)
        itemSale["seller"] = (details["seller"] as! PFUser)
        
        itemSale.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("data save successfully.. ")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPurchaseVC") as! MyPurchaseVC
                vc.controllerName  =  "Confirm"
                self.navigationController?.pushViewController(vc, animated: true)
                //self.performSegue(withIdentifier: "MyPurchaseVC", sender: nil)
                 showDialog(vc: self, title: "", message: "PayPal Payment Success !")
               
            }

            else {
                // There was a problem, check error.description
                print("data not save successfully.. ")
                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
            }
            //self.progressHUD.removeFromSuperview()
        }
            //let dic_product =  ary_item as! PFObject
           dic_product_save["soldDate"] = Date()
           dic_product_save.saveEventually()
        
    }
    
    
    @IBAction func btn_payCancel(_ sender: Any) {
        
     
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func retriveTransactionID()  {
        
        let parameters1 : [String: Any]  = [
     
            "requestEnvelope": [
                "errorLanguage" : "en_US"  ],
          
            "payKey" : details["payKey"] as! String
        ]
        print(parameters1)
        //HTTP Headers
        let headers: HTTPHeaders  = [
            "X-PAYPAL-SECURITY-USERID": "prat101_api1.gmail.com",
            "X-PAYPAL-SECURITY-PASSWORD": "QA79MZAAQCXKVP3F",
            "X-PAYPAL-SECURITY-SIGNATURE": "A-44B-s8iXo8dUutxeGRdc1PH-69Avp60ucDXVw092NULJTUPVxenla7",
            "X-PAYPAL-REQUEST-DATA-FORMAT": "JSON",
            "X-PAYPAL-RESPONSE-DATA-FORMAT": "JSON",
            "X-PAYPAL-APPLICATION-ID": "APP-80W284485P519543T",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        //
        
        //Alamofire
        let manager = Alamofire.Session.default
        //        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request("https://svcs.sandbox.paypal.com/AdaptivePayments/PaymentDetails", method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                switch (response.result) {
                case .success(let value):
                    
                    let dict = value as? Dictionary <String, Any>
                    let tran_id = (((dict!["paymentInfoList"] as! Dictionary <String, Any>)["paymentInfo"] as! NSArray )[0] as! Dictionary <String, Any>)["transactionId"] as! String
                   
                    self.updateRecordToDatabse(totalAmount: self.details["totalPrice"] as! String, trackID: tran_id)
                    
//                    if let payInfo = tra["transactionId"] as! String {
//
//
//
//                    } else {
//
//
//                        print("Pay key not available")
//                    }
                    
                    
                    
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //HANDLE TIMEOUT HERE
                    }
                    print("\n\nAuth request failed with error:\n \(error)")
                    break
                }
        }
        
        
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
