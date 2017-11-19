//
//  SettingsVC.swift
//  socialApp
//
//  Created by Luis  Costa on 13/11/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UINavigationControllerDelegate {
    
    // IBOutlets
    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var userNameTextField: UITextField!
    
    // Variables
    var imagePicker: UIImagePickerController!
    let dataSession = DataSession.shared
    var hasDefaultSettings = false
    var hasChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // upload user settings
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        userNameTextField.delegate = self
        
        getCurrentUserSettings()
    }
    
    // MARK: - Actions
    @IBAction func saveBtnTapped(_ sender: Any) {
        // Check text field
        guard let username = userNameTextField.text, username != "" else {
            print("SocialAppDebug: Username is mandatory")
            // TODO: Handle
            return
        }
        
        // Check profile image
        guard let profileImage = profileImage.image, !hasDefaultSettings else {
            print("SocialAppDebug: Profile picture is mandatory")
            // TODO: Handle
            return
        }
        
        // Save profile image
        // Save user info
        if hasChanged {
            saveCurrentUserSettings(username: username, profileImage: profileImage)
        }
        
        self.performSegue(withIdentifier: "SettingsToFeed", sender: nil)
    }
    
    @IBAction func addProfileImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Private functions
    private func saveCurrentUserSettings(username nickname: String, profileImage: UIImage) {
        
        
        // Get unique identifier to identify image
        let imgUid = UUID().uuidString
            
        // Save in cache
        FeedVC.imageCache.setObject(profileImage, forKey: imgUid as NSString)
        print("SocialAppDebug: ProfileImage saved on cache")
        
        // Convert image to imagaData
        if let imageData = UIImageJPEGRepresentation(profileImage, 0.2) {
            // Data Type jpeg
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            // Upload
            DataService.shared.REF_STORAGE_PROFILE_IMAGES.child(imgUid).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                if error != nil {
                    // TODO: Handle with alert
                    print("SocialAppDebug: Error uploading profile image")
                    // TODO: Handle
                } else {
                    print("SocialAppDebug: Image successfully uploaded")
                    if let downloadUrl = metaData?.downloadURL()?.absoluteString {
                        DataService.shared.saveCurrentUserSettings(username: nickname, profileImageUrl: downloadUrl)
                        self.dataSession.username = nickname
                        self.dataSession.profileImageUrl = downloadUrl
                        print("SocialAppDebug: Current user settings save successfuly")
                    }
                }
            })
        }
    }
    
    private func getCurrentUserSettings() {
        // Get data session
        if let username = dataSession.username, username != "", let profileImageUrl = dataSession.profileImageUrl, profileImageUrl != "" {
            userNameTextField.text = username
            if let image = FeedVC.imageCache.object(forKey: profileImageUrl as NSString) {
                // Check image in cache
                profileImage.image = image
                profileImage.clipsToBounds = true
            } else {
                // Download profile image
                let ref = Storage.storage().reference(forURL: profileImageUrl)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if let _ = error {
                        print("SocialAppDebug: Unable to download profile image")
                    } else {
                        if let data = data, let image = UIImage(data: data) {
                            // Save in cache
                            FeedVC.imageCache.setObject(image, forKey: profileImageUrl as NSString)
                            // Update profile image
                            self.profileImage.image = image
                            self.profileImage.clipsToBounds = true
                            print("SocialAppDebug: Profile image successfully downloaded")
                        }
                    }
                })
            }
        } else {
            // No username / no profileImageUrl
            // Download username
            DataService.shared.REF_DB_CURRENT_USER.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.hasChild("username") {
                    guard let username = snapshot.childSnapshot(forPath: "username").value as? String else {
                        print("SocialAppDebug: Usersername downloaded from Firebase DB")
                        return
                    }
                    self.userNameTextField.text = username
                    self.dataSession.username = username
                } else {
                    print("SocialAppDebug: No such username to the current user")
                    self.userNameTextField.text = ""
                }
            })
            
            // Download profileImageUrl
            DataService.shared.REF_DB_CURRENT_USER.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.hasChild("profileImage") {
                    guard let profileImageUrl = snapshot.childSnapshot(forPath: "profileImage").value as? String else {
                        print("SocialAppDebug: No such profileImageUrl to the current user")
                        self.getCurrentUserSettings()
                        return
                    }
                    self.dataSession.profileImageUrl = profileImageUrl
                    self.getCurrentUserSettings()
                } else {
                    print("SocialAppDebug: No such profileImageUrl to the current user")
                    self.profileImage.image = UIImage(named: USER_DEFAULT_IMAGE)
                    self.hasDefaultSettings = true
                }
            })
        }
    }
}
// MARK: - Extensions
extension SettingsVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            profileImage.clipsToBounds = true
            hasChanged = true
            hasDefaultSettings = false
        } else {
            print("SocialAppDebug: Selected image was not added")
        }
        // Close image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension SettingsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        hasChanged = true
    }
}






