//
//  FeedVC.swift
//  TalkSocial
//
//  Created by D on 10/2/16.
//  Copyright © 2016 D Conway. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: UIImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        
        
   
        // use this as a listener to the "posts" on Firebase for any changes
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
                        
            if let image = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        
        } else {
            return PostCell()
        }
        
    }
    
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image 
        } else {
            print("Derek: A valid image wasn't selected!!!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    @IBAction func SignOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        print("Derek: ID was successfully removed from Keychain!! \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignInVC", sender: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
}
