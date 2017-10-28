//
//  FeedVC.swift
//  socialApp
//
//  Created by Luis  Costa on 28/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signoutBtnPressed(_ sender: Any) {
        // Thinks todo before signout
        // 1. Remove user from KeyChain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("SocialApp: User id removed from Key Chain")
        //2. Signout in firebase
        try! Auth.auth().signOut()
        print("SocialApp: Signout from Firebase")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    


}
