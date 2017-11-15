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
    var isImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // upload user settings
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func saveBtnTapped(_ sender: Any) {
        // Check text field
        guard let username = userNameTextField.text, username != "" else {
            print("SocialAppDebug: Username is manadatory")
            // Handle
            return
        }
        
        // Check profile image
        guard let profileImage = profileImage.image, isImageSelected else {
            print("SocialAppDebug: Profile picture is mandatory")
            // TODO: Handle
            return
        }
        
        // Save profile image
        // Save user info
        saveCurrentUserSettings(username: username, profileImage: profileImage)
        
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
                        DataService.shared.saveCurrentUserSettings(username: nickname, imageProfileUrl: downloadUrl)
                        print("SocialAppDebug: Current user settings save successfuly")
                    }
                }
            })
        }
    }
    
   // private func saveCurrentUserSettings(username: String, profileImageUrl: String) {
     //   DataService.shared.saveCurrentUserSettings(username: username, profileImageUrl: profileImageUrl)
    //}
}

extension SettingsVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            profileImage.clipsToBounds = true
            isImageSelected = true
        } else {
            print("SocialAppDebug: Selected image was not added")
        }
        // Close image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
}





