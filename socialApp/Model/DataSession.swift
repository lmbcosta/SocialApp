//
//  DataSession.swift
//  socialApp
//
//  Created by Luis  Costa on 16/11/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation

class DataSession {
    // Shared instance
    static let shared = DataSession()
    // User defaults to save sessionData
    private var _defaults: UserDefaults
    
    private let _KEY_USERNAME = "username"
    private let _PROFILE_IMAGE_URL = "profileImageUrl"
    private let _UUID_PROFILE_IMAGE = "uuidProfileImage"
    
    var keyUser: String {get {return "uid"}}
    
    var username: String? {
        get {return _defaults.string(forKey: _KEY_USERNAME)}
        set {_defaults.set(newValue, forKey: _KEY_USERNAME)}
    }
    var profileImageUrl: String? {
        get {return _defaults.string(forKey: _PROFILE_IMAGE_URL)}
        set {_defaults.set(newValue, forKey: _PROFILE_IMAGE_URL)}
    }
    var uuidProfileImage: String? {
        get {return _defaults.string(forKey: _UUID_PROFILE_IMAGE)}
        set {return _defaults.set(newValue, forKey: _UUID_PROFILE_IMAGE)}
    }
    
    private init() {
        _defaults = UserDefaults.standard
    }
}
