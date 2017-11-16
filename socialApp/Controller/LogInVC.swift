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
import SwiftKeychainWrapper

class LogInVC: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        // Check if user already exist
        if let _ = KeychainWrapper.standard.string(forKey: DataSession.shared.keyUser) {
            performSegue(withIdentifier: "LoginToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("SocialAppDebug: Unable to authenticate with Facebook \(error.debugDescription)")
            } else if (result?.isCancelled)! {
                print("SocialAppDebug: User canceled facebook authentication")
            } else {
                print("SocialAppDebug: Facebook authenticated")
                // Get credential to user firebase
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                // Authenticate with facebook using  facebook credential
                self.firebaseAuth(credential)
            }
        }
    }
    // Sign in in Firebase using credential
    private func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("SocialAppDebug: Unable to authenticate with Firebase")
            } else {
                guard let user = user else {return}
                print("SocialAppDebug: Successfully authenticated with Firebase")
                self.saveOnKeyChain(uid: user.uid)
                self.createFirebaseUser(uid: user.uid, provider: credential.provider)
                self.performSegue(withIdentifier: "LoginToFeed", sender: nil)
            }
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            createAlert(titleText: "Warning", messageText: "Email field is requied")
            return
        }
        guard let password = passwordTextField.text else {
            createAlert(titleText: "Warning", messageText: "Password field is manadatory")
            return
        }
        
        // Authenticate with Firebase using email
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("SocialAppDebug: Successfully authenticated with Firebase using Email")
                guard let user = user else {return}
                self.saveOnKeyChain(uid: user.uid)
                self.performSegue(withIdentifier: "LogintoFeed", sender: nil)
                
            } else {
                guard let error = error as NSError? else {return}
                
                let code = error.code
                // Error FIRAuthErrorDomain Code=17011
                if code != 17011 {
                    self.handleFirebaseError(error: error)
                } else {
                    // If user doesn't exist we will create a new user
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            if let error = error as NSError? {
                                self.handleFirebaseError(error: error)
                            }
                            print("SocialAppDebug: Unable to create a new User")
                        } else {
                            guard let user = user else {return}
                            print("SocialAppDebug: Successfully created a new User")
                            self.saveOnKeyChain(uid: user.uid)
                            self.createFirebaseUser(uid: user.uid, provider: user.providerID)
                            
                            let alert = UIAlertController(title: "Success", message: "New user was created successfully", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                                self.performSegue(withIdentifier: "LoginToSettings", sender: nil)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    })
                }
            }
        }
    }
    
    // Function to save user password on key chain
    private func saveOnKeyChain(uid: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(uid, forKey: DataSession.shared.keyUser)
        if saveSuccessful {
            print("SocialAppDebug: Save successfully on key chain")
        }
    }
    
    // Fuction to create an Authentication alerts
    private func createAlert(titleText: String, messageText: String) {
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alterAction) in
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
    
    private func createFirebaseUser(uid: String, provider: String) {
        let userData = ["provider" : provider]
        DataService.shared.createFirebaseUser(uid: uid, userData: userData)
        print("SocialAppDebug: Successfully created a new Firabase user")
    }
}
