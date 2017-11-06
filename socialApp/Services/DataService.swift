//
//  DataService.swift
//  socialApp
//
//  Created by Luis  Costa on 30/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = Database.database().reference()

class DataService {
    
    static let shared = DataService()
    
    private var _REF_BASE: DatabaseReference
    private var _REF_POSTS: DatabaseReference
    private var _REF_USERS: DatabaseReference
    
    private init() {
        _REF_BASE = Database.database().reference()
        _REF_USERS = _REF_BASE.child("users")
        _REF_POSTS = _REF_BASE.child("posts")
    }
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createFirebasePost(pid: String, postData: Dictionary<String, String>) {
        REF_POSTS.child(pid).updateChildValues(postData)
    }
}
