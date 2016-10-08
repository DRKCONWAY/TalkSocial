//
//  Post.swift
//  TalkSocial
//
//  Created by D on 10/7/16.
//  Copyright © 2016 D Conway. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }

    var likes: Int {
        return _likes
    }

    var postKey: String {
        return _postKey
    }

    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }

        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }

    }
    
    
    
    
    
    
    
    
    
    
    
}
