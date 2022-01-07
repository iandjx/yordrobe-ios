//
//  Alertview.swift
//  Yordrobe
//
//  Created by MuseerAnsari on 7/14/17.
//  Copyright © 2017 MuseerAnsari. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog


// Dialog box for all screens
func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert);
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func showDialog(vc: UIViewController, title: String?, message: String) -> Void  {
    let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
        print("Completed")
    }
    let buttonOk = DefaultButton(title: "OK") {
        //self.label.text = "You ok'd the default dialog"
    }
    // Add buttons to dialog
    popup.addButtons([buttonOk])
    vc.present(popup, animated: true, completion: nil)
}

func showDialogAndBack(vc: UIViewController, title: String?, message: String, btn_Name: String?) -> Void  {
    let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false) {
        print("Completed")
    }
    let buttonOk = DefaultButton(title: btn_Name ?? "OK") {
        //self.label.text = "You ok'd the default dialog"
        if let navigationController = vc.navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
                return
            }
        }
        vc.dismiss(animated: true, completion: nil)
    }
    // Add buttons to dialog
    popup.addButtons([buttonOk])
    vc.present(popup, animated: true, completion: nil)
}
