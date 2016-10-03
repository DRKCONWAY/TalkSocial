//
//  FeedVC.swift
//  TalkSocial
//
//  Created by D on 10/2/16.
//  Copyright © 2016 D Conway. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func SignOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        print("Derek: ID was successfully removed from Keychain!! \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignInVC", sender: nil)
    }
    
}
