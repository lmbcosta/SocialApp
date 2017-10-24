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
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    

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
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            createAlert(titleText: "Warning", messageText: "Email field is required")
            return
        }
        guard let password = passwordTextField.text else {
            createAlert(titleText: "Warning", messageText: "Password field is manadatory")
            return
        }
        
        // Authenticate with Firebase using email
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("SocialApp: Successfully authenticated with Firebase using Email")
            } else {
                guard let error = error as NSError? else {return}
                
                let code = error.code
                // Error FIRAuthErrorDomain Code=17011
                if code != 17011 {
                    self.handleFirebaseError(error: error)
                } else {
                    // If user dont exist we will create the user
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to create a new User")
                        } else {
                            print("Successfully created a new User")
                        }
                    })
                }
            }
        }
    }
    
    
    private func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("SocialApp: Unable to authenticate with Firebase")
            } else {
                print("SocialApp: Successfully authenticated with Firebase")
            }
        }
    }
    
    // Fuction to create an Authentication alets
    private func createAlert(titleText: String, messageText: String) {
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default) { (alterAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Function to handle Firebase Authenticaton Erros
    private func handleFirebaseError(error: NSError) {
        let title = "Error"
        var text: String
        
        print(error.debugDescription)
        
        guard let error = AuthErrorCode(rawValue: error.code) else {return}
        
        switch error {
        case .invalidEmail:
            text = "Invalid email adress"
            break
            
        case .weakPassword:
            text = "Password is to weak. Try with another"
            break
            
        case .wrongPassword:
            text = "Invalid password"
            break
            
        case .emailAlreadyInUse:
            text = "Email already in use"
            break
            
        default:
            text = "There was an internal error. Please try later"
        }
        
        createAlert(titleText: title, messageText: text)
    }
    
}
