//
//  LogInVC.swift
//  socialApp
//
//  Created by Luis  Costa on 15/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuthUI

class LogInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("SocialApp: Unable to authenticate with Facebook \(error.debugDescription)")
            } else if (result?.isCancelled)! {
                print("SocialApp: User canceled facebook authentication")
            } else {
                print("SocialApp: Facebook authenticated")
                // Get credential to user firebase
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                // Authenticate with facebook using  facebook credential
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("SocialApp: Unable to authenticate with Firebase")
            } else {
                print("SocialApp: Successfully authenticated with Firebase")
            }
        }
    }
}
