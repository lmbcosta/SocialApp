//
//  DataService.swift
//  socialApp
//
//  Created by Luis  Costa on 30/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

class DataService {
    
    static let shared = DataService()
    
    // Data base references
    private var _REF_DB_BASE: DatabaseReference
    private var _REF_DB_POSTS: DatabaseReference
    private var _REF_DB_USERS: DatabaseReference
    
    // Storage base references
    private var _REF_STORAGE_BASE: StorageReference
    private var _REF_STORAGE_POST_IMAGES: StorageReference
    private var _REF_STORAGE_PROFILE_IMAGES: StorageReference
    
    private init() {
        // Database References
        _REF_DB_BASE = Database.database().reference()
        _REF_DB_USERS = _REF_DB_BASE.child("users")
        _REF_DB_POSTS = _REF_DB_BASE.child("posts")
        
        // Storage References
        _REF_STORAGE_BASE = Storage.storage().reference()
        _REF_STORAGE_POST_IMAGES = _REF_STORAGE_BASE.child("post-images")
        _REF_STORAGE_PROFILE_IMAGES = _REF_STORAGE_BASE.child("profile-images")
    }
    
    var REF_DB_BASE: DatabaseReference {
        return _REF_DB_BASE
    }
    
    var REF_DB_POSTS: DatabaseReference {
        return _REF_DB_POSTS
    }
    
    var REF_DB_USERS: DatabaseReference {
        return _REF_DB_USERS
    }
    
    // Reference the current user
    var REF_DB_CURRENT_USER: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: DataSession.shared.keyUser)
        let currentUserReference = _REF_DB_USERS.child(uid!)
        return currentUserReference
    }
    
    var REF_STORAGE_BASE: StorageReference {
        return _REF_STORAGE_BASE
    }
    
    var REF_STORAGE_POST_IMAGES: StorageReference {
        return _REF_STORAGE_POST_IMAGES
    }
    
    var REF_STORAGE_PROFILE_IMAGES: StorageReference {
        return _REF_STORAGE_PROFILE_IMAGES
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        _REF_DB_USERS.child(uid).updateChildValues(userData)
    }
    
    func createFirebasePost(pid: String, postData: Dictionary<String, String>) {
        _REF_DB_POSTS.child(pid).updateChildValues(postData)
    }
    
    func saveCurrentUserSettings(username: String, profileImageUrl: String) {
        // Save profileUrl in current user
        REF_DB_CURRENT_USER.child("profileImage").setValue(profileImageUrl)
        // Save username in currentUser
        REF_DB_CURRENT_USER.child("username").setValue(username)
    }
    
    func uploadCurrentUserSetings() -> (username: String?, imageProfileUrl: String?) {
        // Get username
        let username = REF_DB_CURRENT_USER.value(forKey: "username") as? String
        let imageProfileUrl = REF_DB_CURRENT_USER.value(forKey: "profileImage") as? String
        
        return (username, imageProfileUrl)
    }
}
