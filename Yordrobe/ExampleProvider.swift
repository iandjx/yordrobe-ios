//
//  ExampleProvider.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2017年 Vincent Li. All rights reserved.
//

import UIKit
//import ESTabBarController
import ESTabBarController_swift

enum ExampleProvider {
    
    static func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> NavigationVC {
        
        let storyboard = grabStoryboard()

        let tabBarController = ESTabBarController()
        
        let navigationController = NavigationVC.init(rootViewController: tabBarController)
        navigationController.isNavigationBarHidden = true
        //tabBarController.title = "Example"
        
        tabBarController.delegate = delegate
        
        //tabBarController.title = "Irregularity"
        //tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        //tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
        
            if index == 2 {
                return true
            }
            return false
        }
        
        
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Create the AlertController and add its actions like button in ActionSheet
                let actionSheetController = UIAlertController(title: "Which type of item are you uploading?", message: "", preferredStyle: .actionSheet)
                
                let SellActionButton = UIAlertAction(title: "SELL", style: .default) { action -> Void in
                    print("SELL")
                    let vc = storyboard.instantiateViewController(withIdentifier: "UploadItemVC") as! UploadItemVC
                    vc.hidesBottomBarWhenPushed = true
                    vc.isSale = true
                    
                    if let navigationController = viewController.navigationController {
                        navigationController.pushViewController(vc, animated: true)
                        return
                    }
                    
                }
                actionSheetController.addAction(SellActionButton)
                //
                /*
                let SwapActionButton = UIAlertAction(title: "SWAP", style: .default) { action -> Void in
                    print("SWAP")
                    let vc = storyboard.instantiateViewController(withIdentifier: "UploadItemVC") as! UploadItemVC
                    vc.hidesBottomBarWhenPushed = false
                    vc.isSale = false
                    
                    if let navigationController = viewController.navigationController {
                        navigationController.pushViewController(vc, animated: true)
                        return
                    }
                    //tabBarController?.present(vc, animated: true, completion: nil)
                    
                }
                actionSheetController.addAction(SwapActionButton)
                */
                //
                let DropActionButton = UIAlertAction(title: "DROP", style: .default) { action -> Void in
                    print("DROP")
                    let vc = storyboard.instantiateViewController(withIdentifier: "DropDescriptionVC") as! DropDescriptionVC
                    vc.hidesBottomBarWhenPushed = false
                    
                    if let navigationController = viewController.navigationController {
                        navigationController.pushViewController(vc, animated: true)
                        return
                    }
                    //tabBarController?.present(vc, animated: true, completion: nil)

                }
                actionSheetController.addAction(DropActionButton)
                //
                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheetController.addAction(cancelActionButton)
                //
                tabBarController?.present(actionSheetController, animated: true, completion: nil)
                
            }
        }
        
        
        let v1 = storyboard.instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC
        let v2 = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        let v3 = storyboard.instantiateViewController(withIdentifier: "UploadItemVC") as! UploadItemVC
        let v4 = storyboard.instantiateViewController(withIdentifier: "FavouritVC") as! FavouritVC
        let v5 = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Alerts", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        // Handling push notification here ...
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isPushRecieved == true {
            tabBarController.selectedIndex = 3
            tabBarController.selectedViewController = v4
            appDelegate.isPushRecieved = false
        }
        return navigationController
    }

    
}



func grabStoryboard() -> UIStoryboard {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    if DeviceType.IS_IPHONE_4_OR_LESS {
//        storyboard = UIStoryboard(name: "Main", bundle: nil)
//    }
//    else if DeviceType.IS_IPHONE_5 {
//        storyboard = UIStoryboard(name: "Main", bundle: nil)
//    }
//    else if DeviceType.IS_IPAD {
//        storyboard = UIStoryboard (name: "Main", bundle: nil)
//    }
//    else{
//        storyboard = UIStoryboard(name: "Main", bundle: nil)
//    }
    
    return storyboard
}
