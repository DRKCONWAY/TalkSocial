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
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    


    
// This function is how you authenticate with Facebook
    @IBAction func fBButtonPressed(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("Derek: Unable to authenticate with Facebook. Doh! - \(error)")
            } else if result?.isCancelled == true {
                print("Derek: User cancelled FB authentication!")
            } else {
                print("Derek: Successfully authenticated with Facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuthentication(credential)
            }
        }
        
    }
    
    // Authentication with Firebase
    func firebaseAuthentication(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("Derek: Unable to authenticate with Firebase. Doh! - \(error)")
            } else {
                print("Derek: Successfully authenticated with Firebase!")
            }
        })
    }
    
    // Dismiss the keyboard when background is tapped
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
}












