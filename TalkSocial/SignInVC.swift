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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // The segue needs to be in viewdidappear
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID) {
            print("Derek: ID found in keychain!")
            
            performSegue(withIdentifier: "goToFeedVC", sender: nil)
        }

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
                if let user = user {
                    
                    self.completeSignIn(id: user.uid)
                }
                
            }
        })
    }
    
    // Dismiss the keyboard when background is tapped
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        
        if let email = emailTextField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print("Derek: Email user is authenticated with Firebase!")
                    
                    if let user = user {
                        
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("Derek: Doh! Unable to authenticate with Firebase using email")
                        } else {
                            print("Derek: Successfully authenticated with good ol' Firebase!!")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        print("Derek: Data was saved to the Keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeedVC", sender: nil)
    }
}












