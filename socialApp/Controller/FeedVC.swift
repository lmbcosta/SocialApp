//
//  FeedVC.swift
//  socialApp
//
//  Created by Luis  Costa on 28/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signoutBtnPressed(_ sender: Any) {
        // 1. Signout Firebase
        try! Auth.auth().signOut()
        
        // 2. Remove user from key chain
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_USER)
        if removeSuccessful {
            print("SocialAppDebug: Remove seccessfully from Key Chain")
        }
        dismiss(animated: true, completion: nil)
    }
}
