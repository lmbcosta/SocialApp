//
//  Post.swift
//  socialApp
//
//  Created by Luis  Costa on 06/11/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postReference: DatabaseReference!
    private var _owner: String!
    
    var caption: String {return _caption}
    
    var imageUrl: String {return _imageUrl}
    
    var likes: Int {return _likes}
    
    var postKey: String {return _postKey}
    
    var owner: String {return _owner}
    
    init(caption: String, imageUrl: String, likes: Int, owner: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._owner = owner
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let owner = postData["owner"] as? String {
            self._owner = owner
        }
        
        _postReference = DataService.shared.REF_DB_POSTS.child(postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        _likes = addLike ? _likes + 1 : _likes - 1
        
        // Update likes in post db
        DataService.shared.REF_DB_POSTS.child(_postKey).child("likes").setValue(_likes)
    }
}
