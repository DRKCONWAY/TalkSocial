//
//  SignInVC.swift
//  TalkSocial
//
//  Created by Derek Conway on 9/29/16.
//  Copyright © 2016 D Conway. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
// This function is how you authenticate with Facebook
    @IBAction func fBButtonPressed(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("Derek: Unable to authenticate with Facebook! - \(error)")
            } else if result?.isCancelled == true {
                print("Derek: User cancelled FB authentication!")
            } else {
                print("Derek: Successfully authenticated with Facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            }
        }
        
    }

}

