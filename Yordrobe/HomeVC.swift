//
//  HomeVC.swift
//  Yordrobe
//
//  Created by Tamim on 27/11/21.
//  Copyright © 2021 MuseerAnsari. All rights reserved.
//

import UIKit
import AuthenticationServices
import Parse

class HomeVC: UIViewController {
    @IBOutlet weak var appBackgroundImaeView: UIImageView!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var appSloganLabel: UILabel!
    @IBOutlet weak var appSloganSubtitle: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signInWithApple: ASAuthorizationAppleIDButton!
    
    var userID: String?
    var email: String?
    var givenName: String?
    var familyName: String?
    var nickName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWithApple.isHidden = true
        signInWithApple.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        PFUser.register(AuthDelegate(), forAuthType: "apple")
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func selectUsername() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UsernameSelectVC") as! UsernameSelectVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("Received appleIDCredential from ASAuthorizationController")
            guard let token = appleIDCredential.identityToken else {
                print("appleIDCredential identityToken is nil...")
                return
            }
            guard let idTokenString = String(data: token, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(token.debugDescription)")
                return
            }
            print("Identity Token: " + (idTokenString))
            userID = appleIDCredential.user
            print("UserID: " + userID!)
            email = appleIDCredential.email
            print("Email: " + (email ?? "no email") )
            
            // optional, might be nil
            givenName = appleIDCredential.fullName?.givenName
            print("Given Name: " + (givenName ?? "no given name") )
            
            // optional, might be nil
            familyName = appleIDCredential.fullName?.familyName
            print("Family Name: " + (familyName ?? "no family name") )
            
            // optional, might be nil
            nickName = appleIDCredential.fullName?.nickname
            print("Nick Name: " + (nickName ?? "no nick name") )
            
            PFUser.logInWithAuthType(inBackground: "apple", authData: ["token": idTokenString, "id": userID!]).continueWith { task -> Any? in
                if ((task.error) != nil){
                    //DispatchQueue.main.async {
                    print("Could not login.\nPlease try again.")
                    print("Error with parse login after SIWA: \(task.error!.localizedDescription)")
                    //}
                    return task
                }
                print("Successfuly signed in with Apple")
                return nil
            }
            
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        // Handle error.
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension HomeVC: UsernameSelectVCDelegate {
    func uniqueUsernameSelected(username: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let installation =  PFInstallation.current()
        if (installation != nil) {
            installation?.setDeviceTokenFrom(appDelegate.deviceToken_data)
            installation?.setObject(PFUser.current()!, forKey: "user")
            installation?.saveEventually()
        }

        
        if let currentUser = PFUser.current() {
            if let email = self.email {
                currentUser.email = email
            }
            currentUser.username = String(describing: username)
            currentUser["firstName"] = self.givenName
            currentUser["lastName"] = self.familyName
            
            currentUser["allItemInFeed"] = true
            currentUser["notifiedItemListed"] = true
            currentUser["notifiedFollwMe"] = true
            currentUser["notifiedLovesMyItem"] = true
            currentUser["notifiedCommentMyItem"] = true
            currentUser["notifiedPurchaseMyItem"] = true
            currentUser["notifiedItemLovePurchasePosted"] = true
            currentUser.saveInBackground()
        }
        
        let defaults = UserDefaults.standard
        let dict = ["Name": PFUser.current()?.username, "Password": "*******"]
        defaults.set(dict, forKey: "autoLogin")

        self.present(ExampleProvider.customIrregularityStyle(delegate: nil), animated: true, completion: nil)
    }
}

class AuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func restoreAuthenticationWithAuthData(authData: [String : String]?) -> Bool {
        return true
    }
}
