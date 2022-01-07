//
//  ConfirmPayVC.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 9/16/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import UIKit
import Parse
import Alamofire


class ConfirmPayVC: UIViewController { //PayPalPaymentDelegate {
    
    
    
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet weak var lbl_isfreeShipiing: UILabel!
    @IBOutlet weak var btn_standard: BorderButton!
    @IBOutlet weak var btn_express: BorderButton!
    @IBOutlet weak var lbl_totalAmount: UILabel!
    @IBOutlet weak var tv_shippingAddress: UITextView!
    @IBOutlet weak var btn_edit: BorderButton!
    @IBOutlet weak var btn_pay: BorderButton!
    
    var dic_product: PFObject!
    var shipType : String!
    
    
    // Pay pal 
    var resultText = "" // empty
    //var payPalConfig = PayPalConfiguration() // default
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        print("dicProduct === \(dic_product!)")
        
        
        //        title = "PayPal SDK Demo"
        //successView.isHidden = true
        
        // Set up payPalConfig
        //        payPalConfig.acceptCreditCards = true
        
        //payPalConfig.merchantName = "\(PFUser.current()!["firstName"]!) \(PFUser.current()!["lastName"]!)"
        //        payPalConfig.merchantName = "Yordrobe Inc."
        //        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        //        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        //        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        //        payPalConfig.payPalShippingAddressOption = .payPal;
        
        //        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // PayPalMobile.preconnect(withEnvironment: environment)
        //PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
        if let ProfilePic = dic_product["CoverImage"] as? PFFileObject  {
            (ProfilePic ).getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.img_product.image = image
                }
            })
        }
        if (dic_product["Brand"]) != nil {
            lbl_category.text = "\(dic_product!["Brand"]!)"
        }
        else {
            lbl_category.text = "\(dic_product!["brand"]!)"
        }
        tv_description.text = "\(dic_product!["Description"]!)"
        var intcost  =  0
        
        if dic_product!["FreeShipping"] as! Bool == true
        {
            shipType = "Free"
            lbl_isfreeShipiing.text = "YES"
            btn_express.isEnabled = false
            btn_standard.isEnabled = false
        }
        else if dic_product["Standard"] as! Bool == true && dic_product["Express"] as! Bool == true {
            if (dic_product!["ExpresCost"]) != nil {
                intcost = dic_product!["ExpresCost"] as! Int
            }
            else {
                intcost = dic_product!["ExpressCost"] as! Int
            }
                btn_shippingType(UIButton())
            
        }
         
        else {
            if dic_product["Standard"] as! Bool == true {
                shipType = "Standard"
                btn_standard.backgroundColor = clr_golden
                btn_standard.setTitleColor(.white, for: .normal)
                lbl_isfreeShipiing.text = "NO"
                if let stdCost =  dic_product!["StandardCost"] {
                    btn_standard.setTitle("Standard: $\(stdCost)", for: .normal)
                    intcost = stdCost as! Int
                }
                btn_express.setTitle("Express : $0", for: .normal)
                btn_express.backgroundColor = UIColor.white
                btn_express.setTitleColor(clr_golden, for: .normal)
                btn_express.isEnabled = false
            }
            else if dic_product["Express"] as! Bool == true {
            shipType = "Express"
            btn_express.backgroundColor = clr_golden
            btn_express.setTitleColor(.white, for: .normal)
            lbl_isfreeShipiing.text = "NO"
            if let standardCost =  dic_product!["StandardCost"] {
                btn_standard.setTitle("Standard: $\(standardCost)", for: .normal)
                }
            if let cost = dic_product!["ExpresCost"] {
                btn_express.setTitle("Express: $\(cost)", for: .normal)
                intcost =  cost as! Int
            }
            else {
                btn_express.setTitle("Express: $\(dic_product!["ExpressCost"]!)", for: .normal)
                intcost =  dic_product!["ExpressCost"] as! Int
                }
            btn_standard.backgroundColor = UIColor.white
            btn_standard.setTitleColor(clr_golden, for: .normal)
            btn_standard.isEnabled = false
            }
        }
            //shipType = "Express"
            //btn_express.backgroundColor = clr_golden
            //btn_express.setTitleColor(.white, for: .normal)
            //lbl_isfreeShipiing.text = "NO"
            //btn_standard.backgroundColor = UIColor.white
            //btn_standard.setTitleColor(clr_golden, for: .normal)
            //btn_standard.setTitle("Standard: $\(dic_product!["StandardCost"]!)", for: .normal)
            //            if(dic_product!["ExpresCost"] != nil) {
            //btn_express.setTitle("Express: $\(dic_product!["ExpresCost"]!)", for: .normal)
            
            //intcost =  dic_product!["ExpresCost"]! as! Int
            //            }
            //            else
            //            {
            //            btn_express.setTitle("Express: $\(dic_product!["ExpressCost"]!)", for: .normal)
            //            intcost =  dic_product!["ExpressCost"]! as! Int
            //            }
        
        let intPrice : Int =  dic_product!["Price"] as? Int ?? 0// + Int(dic_product!["ExpressCost"] as? String ?? "0")!
        print(intPrice)
        print(intcost)
        let mainCost   =   intPrice + intcost
        print(mainCost)
        lbl_totalAmount.text = "$\(mainCost)"
        address = "\(PFUser.current()!["firstName"]!) \(PFUser.current()!["lastName"]!)\n"
        
        if let _address: String = PFUser.current()?["address"] as? String {
            address = address + _address
        }
        if let suburb = PFUser.current()?["suburb"] {
            address = address + " \(suburb)"
        }
        if let state = PFUser.current()?["state"] {
            if "\(state)" != "State" {
                address = address + "\n\(state)"
            }
        }
        if let postCode = PFUser.current()?["postCode"] {
            address = address + " \(postCode)"
        }
        tv_shippingAddress.text = "\(address!)"
    }
    
    
    
    @IBAction func btn_shippingType(_ sender: UIButton) {

        if sender.tag == 1 {
            shipType = "Standard"
            btn_standard.backgroundColor = clr_golden
            btn_standard.setTitleColor(.white, for: .normal)
            lbl_totalAmount.text = "$\(Int(dic_product!["Price"] as! Int) + Int(dic_product!["StandardCost"] as! Int))"
            btn_express.backgroundColor = UIColor.white
            btn_express.setTitleColor(clr_golden, for: .normal)
        }
        else
        {
            shipType = "Express"
            btn_express.backgroundColor = clr_golden
            btn_express.setTitleColor(.white, for: .normal)
            btn_standard.setTitle("Standard: $\(dic_product!["StandardCost"]!)", for: .normal)
            if (dic_product!["ExpresCost"]) != nil
            {
                lbl_totalAmount.text = "$\(Int(dic_product!["Price"] as! Int) + Int(dic_product!["ExpresCost"] as! Int))"
                btn_express.setTitle("Express: $\(dic_product!["ExpresCost"]!)", for: .normal)
            }
            else {
                if (dic_product!["ExpressCost"]) != nil
                {
                    lbl_totalAmount.text = "$\(Int(dic_product!["Price"] as! Int) + Int(dic_product!["ExpressCost"] as! Int))"
                    btn_express.setTitle("Express: $\(dic_product!["ExpressCost"] ?? "0")", for: .normal)
                }
            else
                {
                lbl_totalAmount.text = "$\(Int(dic_product!["Price"] as! Int))"
                }
            }
            btn_standard.backgroundColor = UIColor.white
            btn_standard.setTitleColor(clr_golden, for: .normal)
        }
    }
    
    var address: String!
    
    @IBAction func btn_pay(_ sender: Any) {
        //print("paypal email == \((dic_product!["Owner"] as! PFUser)["paypalEmail"])")
        
        if shipType  == nil {
            showDialog(vc: self, title: "Error!", message: "Please Select Shipping Type")
        }
        else if (dic_product!["Owner"] as! PFUser)["paypalEmail"] == nil || (dic_product!["Owner"] as! PFUser)["paypalEmail"]! as? String == "" {
            showDialog(vc: self, title: "Error!", message: "We don't seem to have the PayPal email address of the owner of this item on record. We apologise for the inconvenience and will aim to resolve the issue as soon as we can. Please try again later and contact Yordrobe if the problem remains.")
        }
        else{
            API_paypal()
        }     
    }
    
    
    func API_paypal() {
        
        // Remove our last completed payment, just for demo purposes.
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        /*
         let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
         let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
         let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
         
         let items = [item1, item2, item3]
         let subtotal = PayPalItem.totalPrice(forItems: items)
         
         // Optional: include payment details
         let shipping = NSDecimalNumber(string: "5.99")
         let tax = NSDecimalNumber(string: "2.50")
         let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
         
         let total = subtotal.adding(shipping).adding(tax)
         */
        let str_totalAmount = lbl_totalAmount.text!
        
        let progressHUD = ProgressHUD(text: "Loading..")
        self.view.addSubview(progressHUD)
        self.view.isUserInteractionEnabled = false
        
        if let item_amount = Int(str_totalAmount.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        {
            // Do something with this number
            print("number == \(item_amount)")
            
            //Parameters
            
            let check1 = Double(90 * item_amount)/100
            let div1 = String(format: "%.2f", check1)
            
            let check2 = Double(10 * item_amount)/100
            let div2 = String(format: "%.2f", check2)
            
            //            let payment = PayPalPayment(amount: NSDecimalNumber(string: ""), currencyCode: "USD", shortDescription: "\(dic_product!["brand"]!)", intent: .sale)
            //            payment.payeeEmail = "\((dic_product!["Owner"]! as! PFUser)["paypalEmail"]!)"
            //
            
            //            var Payment_Adaptive : NSMutableDictionary = [:]
            //
            //            var Pay: Array<AnyObject> = []
            //
            //            Payment_Adaptive["actionType"] = "PAY"
            //            Payment_Adaptive["currencyCode"] = "USD"
            //            Pay.append(Payment_Adaptive)
            //            print(Pay)
            //            Payment_Adaptive = [:]
            //
            //            var Pay1: Array<Any> = []
            //
            //            var  amount1: NSMutableDictionary = [:]
            //            amount1["amount"] = "\(div1)"
            //            amount1["email"] = "qwerty11234@gmail.com"//"\((dic_product!["Owner"]! as! PFUser)["paypalEmail"]!)"
            //            Payment_Adaptive.setValue(amount1, forKey: "receiver")
            //            Pay1.append(Payment_Adaptive)
            //            print(Pay1)
            //            Payment_Adaptive  = [:]
            //            amount1 = [:]
            //
            //            amount1["amount"] = "\(div2)"
            //            amount1["email"] = "museer11@gmail.com"
            //            Pay1.insert(amount1, at: 1)
            //            print(Pay1)
            //            Payment_Adaptive.setValue(Pay1, forKey: "receiverList")
            //            print(Payment_Adaptive)
            //            Pay.append(Payment_Adaptive)
            //            print(Pay)
            //            Payment_Adaptive  = [:]
            //            amount1 = [:]
            //
            //            amount1["errorLanguage"] = "en_US"
            //            Payment_Adaptive.setValue(amount1, forKey: "requestEnvelope")
            //            Pay.append(Payment_Adaptive)
            //            print(Pay)
            //            Payment_Adaptive  = [:]
            //            amount1 = [:]
            //
            //            amount1["applicationId"] = "APP-80W284485P519543T"
            //            Payment_Adaptive.setValue(amount1, forKey: "clientDetails")
            //            Pay.append(Payment_Adaptive)
            //            print(Pay)
            //            Payment_Adaptive  = [:]
            //            amount1 = [:]
            //
            //            Payment_Adaptive["feesPayer"] = "EACHRECEIVER"
            //            Payment_Adaptive["returnUrl"] = "https://example.com"
            //            Payment_Adaptive["cancelUrl"] = "https://example.com"
            //            Pay.append(Payment_Adaptive)
            //            print(Pay)
            //            Payment_Adaptive  = [:]
            //            amount1 = [:]
            //
            //            Payment_Adaptive.setValue(Pay, forKey: "")
            //            let parameters : [String: Any]  = Payment_Adaptive as! [String : Any]
            //            print(parameters)
            //
            let parameters1 : [String: Any]  = [
                "actionType": "PAY",
                "currencyCode": "USD",
                
                "receiverList": [
                    "receiver" : [
                        [
                            "amount": "\(div1)",
                            "email": "\((dic_product!["Owner"]! as! PFUser)["paypalEmail"]!)"
                        ],
                        [
                            "amount": "\(div2)",
                            "email": "museer11@gmail.com"
                        ]
                    ]
                ],
                "requestEnvelope": [
                    "errorLanguage" : "en_US"  ],
                "clientDetails": [
                    "applicationId": "APP-80W284485P519543T"
                ],
                "feesPayer": "EACHRECEIVER",
                "returnUrl" : "https://paypal.com",
                "cancelUrl" : "https://example1.com"
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
            
            manager.request("https://svcs.sandbox.paypal.com/AdaptivePayments/Pay", method: .post, parameters: parameters1, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success(let value):
                        let dict = value as? Dictionary <String, Any>
            
                        if let payKey = dict!["payKey"] as? String {
                            print(payKey)
                            
                            
    
                            let  amount1: NSMutableDictionary = [:]
                            amount1.setValue("", forKey: "trackingNumber")
                            amount1.setValue(self.dic_product, forKey: "item")
                            amount1.setValue(str_totalAmount, forKey: "totalPrice")
                            amount1.setValue(self.shipType, forKey: "shipingMethod")
                            amount1.setValue((self.dic_product!["Owner"]! as! PFUser), forKey: "seller")
                            amount1.setValue(PFUser.current(), forKey: "buyer")
                            amount1.setValue(Date(), forKey: "soldDate")
                            amount1.setValue(payKey, forKey: "payKey")
                            
                            print(amount1)
                            self.performSegue(withIdentifier: "showPayment", sender: amount1)
                            
                            
                        } else {
                            
                            showDialog(vc: self, title: "Error!", message: "Something wrong with PayPal.Please try after few min.")
                            //print("Pay key not available")
                        }
                        
                        
                        
                        break
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            //HANDLE TIMEOUT HERE
                        }
                        print("\n\nAuth request failed with error:\n \(error)")
                        break
                    }
                    progressHUD.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
            }
            //
            
            //            let payment = PayPalPayment(amount: NSDecimalNumber(string: "\(item_amount)"), currencyCode: "USD", shortDescription: "\(dic_product!["brand"]!)", intent: .sale)
            //            payment.payeeEmail = "\((dic_product!["Owner"]! as! PFUser)["paypalEmail"]!)"
            
            //            let d = "\((dic_product!["Owner"]! as! PFUser)["paypalEmail"]!)"
            //            print(d)
            
            //payment.items = items
            //payment.paymentDetails = paymentDetails
            
            //            if (payment.processable)
            //            {
            //                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            //                present(paymentViewController!, animated: true, completion: nil)
            //            }
            //            else
            //            {
            //                // This particular payment will always be processable. If, for
            //                // example, the amount was negative or the shortDescription was
            //                // empty, this payment wouldn't be processable, and you'd want
            //                // to handle that here.
            //                print("Payment not processalbe: \(payment)")
            //            }
        }
    }
    
    
    //    var environment:String = PayPalEnvironmentSandbox {
    //        willSet(newEnvironment) {
    //            if (newEnvironment != environment) {
    //                PayPalMobile.preconnect(withEnvironment: newEnvironment)
    //            }
    //        }
    //    }
    
    
    // PayPalPaymentDelegate
    
    //    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
    //
    //        print("PayPal Payment Cancelled")
    //
    //        resultText = ""
    //        //successView.isHidden = true
    //        paymentViewController.dismiss(animated: true, completion: nil)
    //    }
    //
    //    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
    //        print("PayPal Payment Success !")
    //
    //        paymentViewController.dismiss(animated: true, completion: { () -> Void in
    //            // send completed confirmaion to your server
    //            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
    //
    //            self.resultText = completedPayment.description
    //            //self.showSuccess()
    //            self.updateRecordToDatabse(totalAmount: completedPayment.amount, trackID: (completedPayment.confirmation["response"]! as! Dictionary<String, Any>)["id"] as! String)
    //
    //        })
    //    }
    //    let progressHUD = ProgressHUD(text: "Loading..")
    //    func updateRecordToDatabse(totalAmount: NSNumber, trackID: String) {
    //
    //        self.view.addSubview(progressHUD)
    //
    //        print("totalAmount = \(totalAmount)\ntrackID == \(trackID)")
    //
    //        let itemSale = PFObject(className:"ItemSale")
    //        itemSale["trackingNumber"] = trackID
    //        itemSale["item"] = dic_product
    //        //item["shipToName"] = category
    //        itemSale["totalPrice"] = totalAmount
    //        itemSale["shipingMethod"] = shipType
    //        itemSale["buyer"] = PFUser.current()
    //        itemSale["seller"] = (dic_product!["Owner"]! as! PFUser)
    //
    //        itemSale.saveInBackground {
    //            (success: Bool, error: Error?) -> Void in
    //            if (success) {
    //                // The object has been saved.
    //                print("data save successfully.. ")
    //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyPurchaseVC") as! MyPurchaseVC
    //                vc.controllerName  =  "Confirm"
    //                self.navigationController?.pushViewController(vc, animated: true)
    //                //self.performSegue(withIdentifier: "MyPurchaseVC", sender: nil)
    //            }
    //
    //            else {
    //                // There was a problem, check error.description
    //                print("data not save successfully.. ")
    //                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
    //            }
    //            self.progressHUD.removeFromSuperview()
    //        }
    //
////            var item : PFObject
////            item = dic_product
//            dic_product["soldDate"] = Date()
//            dic_product.saveEventually()
    //
    //    }
    
    func updateRewardBalance(totalAmount: NSNumber, trackID: String) {
        
        print("totalAmount = \(totalAmount)\ntrackID == \(trackID)")
        
        
        let item = PFObject(className:"ItemSale")
        item["trackingNumber"] = trackID
        item["item"] = self.dic_product
        //item["shipToName"] = category
        item["totalPrice"] = totalAmount
        item["shipingMethod"] = self.shipType
        item["buyer"] = PFUser.current()
        item["seller"] = (self.dic_product!["Owner"]! as! PFUser)
        
        
        if dic_product["amount"] as! Int > 50 {
            let isUserFirstPurchase = PFQuery(className: "ItemSale")
            isUserFirstPurchase.whereKey("buyer", equalTo: PFUser.current()!)
            
            isUserFirstPurchase.findObjectsInBackground { (objects, error) -> Void in
                
                if error == nil {
                    if objects!.count == 0 {
                        item["rewardCreditAmount"] = 20
                        item.saveInBackground {
                            (success: Bool, error: Error?) -> Void in
                            if (success) {
                                // The object has been saved.
                                print("data save successfully.. ")
                            }
                            else {
                                // There was a problem, check error.description
                                print("data not save successfully.. ")
                                showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                            }
                        }
                    }
                    else {
                        showDialog(vc: self, title: "Error!", message: error!.localizedDescription)
                    }
                }
            }
        }
        else {
            // saving item withoiut rewrads amount
            item.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("data save successfully.. ")
                }
                    
                else {
                    // There was a problem, check error.description
                    print("data not save successfully.. ")
                    showDialog(vc: self, title: "Error!", message: "\(error!.localizedDescription)")
                }
            }
        }
    }
    
    
    
    @IBAction func btn_edit(_ sender: Any) {
        self.performSegue(withIdentifier: "EditAddressVC", sender: nil)
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showPayment"{
            print(sender as! NSMutableDictionary)
            let LVC = segue.destination as! AdaptivePayVC;
            LVC.details = sender as! NSMutableDictionary
            LVC.dic_product_save = dic_product
        }
        
    }
        // MARK: - Web browser
    
    
    
    func setup()  {
        
        
//        let webBrowserViewController = WebBrowserViewController()
//        // assign delegate
//        webBrowserViewController.delegate = self
//
//        webBrowserViewController.language = .english
//       // webBrowserViewController.tintColor = ...
//       // webBrowserViewController.barTintColor = ...
//        webBrowserViewController.isToolbarHidden = false
//        webBrowserViewController.isShowActionBarButton = true
//        webBrowserViewController.toolbarItemSpace = 50
//        webBrowserViewController.isShowURLInNavigationBarWhenLoading = true
//        webBrowserViewController.isShowPageTitleInNavigationBar = true
//      //  webBrowserViewController.customApplicationActivities = ...
//        webBrowserViewController.loadURLString("https://www.apple.com/cn/")
        
//        navigationController?.pushViewController(webBrowserViewController, animated: true)
    }
    
    
}
