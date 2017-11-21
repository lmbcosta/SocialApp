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

class FeedVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdder: CircleImage!
    @IBOutlet weak var captionField: UITextField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    // Image Cache
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    // To only download the selected image on imagePicker
    // rather then phtologo we use a flag
    var isImageSelected = false
    
    // MARK: - View stages
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        // User can edit choosed images
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // Observe changes in firebase db posts
        DataService.shared.REF_DB_POSTS.observe(.value) { (snapshot) in
            if let posts = snapshot.children.allObjects as? [DataSnapshot] {
                var newPosts = [Post]()
                for post in posts {
                    //print("SocialAppDebug: \(post)")
                    if let postDictionary = post.value as? Dictionary<String, Any> {
                        let key = post.key
                        let post = Post(postKey: key, postData: postDictionary)
                        newPosts.append(post)
                    }
                }
                self.posts = newPosts.reversed()
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Actions
    
    // Sigout Button
    @IBAction func signoutBtnPressed(_ sender: Any) {
        // 1. Signout Firebase
        try! Auth.auth().signOut()
        
        // 2. Remove user from key chain
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: DataSession.shared.keyUser)
        if removeSuccessful {
            print("SocialAppDebug: Remove seccessfully from Key Chain")
        }
        
        let dataSession = DataSession.shared
        dataSession.profileImageUrl = nil
        dataSession.username = nil
        
        self.performSegue(withIdentifier: "FeedToLogin", sender: nil)
    }
    
    // Add photo Button
    @IBAction func addImageButton(_ sender: Any) {
        // Present image view picker
        self.present(imagePicker, animated: true, completion: nil)
        // DONT FORGET ENABLE USER INTERACTION
        // THE OPTION IS IN OBJECT THAT WE ADD GESTURE TAP RECOGNIZER
    }
    
    // New post button
    @IBAction func newPostBtnPressed(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("SocialAppDebug: A Caption must be entered")
            // Handle with alert
            return
        }
        
        guard let image = imageAdder.image, isImageSelected else {
            print("SocialAppDebug: An image must be entered")
            // Handle with alert
            return
        }
        
        // Convert image to imagaData
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            // Get unique identifier to identify image
            let imgUid = UUID().uuidString
            // Data Type jpeg
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            // Upload
            DataService.shared.REF_STORAGE_POST_IMAGES.child(imgUid).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                if error != nil {
                    // Handle with alert
                    print("SocialAppDebug: Error uploading image")
                } else {
                    print("SocialAppDebug: Image successfully uploaded")
                    //let downloadUrl = metaData?.downloadURL()?.absoluteString
                    if let downloadUrl = metaData?.downloadURL()?.absoluteString {
                        self.postToFirebase(imgUrl: downloadUrl, caption: caption)
                    }
                }
            })
        }
    }
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "FeedToSettings", sender: self)
    }
    
    
    // MARK: - Private functions
    private func postToFirebase(imgUrl: String, caption: String) {
        
        let dataSession = DataSession.shared
        
        // Get post owner
        guard let username = dataSession.username else {
            print("SocialAppDebug: Unable to get username from data session")
            return
        }
        
        // Get profileImageUrl
        guard let profileImageUrl = dataSession.profileImageUrl else {
            print("SocialAppDebug: Enable to get profile image url from data session")
            return
        }
        
        let post: Dictionary<String, Any> = [
            "caption": caption,
            "imageUrl": imgUrl,
            "likes": 0,
            "username": username,
            "profileImageUrl": profileImageUrl
        ]
        DataService.shared.REF_DB_POSTS.childByAutoId().setValue(post)
        
        // Clear properties
        captionField.text = ""
        isImageSelected = false
        imageAdder.image = UIImage(named: "instagram-social-network-logo-of-photo-camera")
        imageAdder.clipsToBounds = false
        
        // Reload table view
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension FeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            let post = posts[indexPath.row]
            let postImage = FeedVC.imageCache.object(forKey: (post.imageUrl as NSString))
            if let _ = postImage {
                print("SocialAppDebug: Post image already in cache")
            }
            let profileImage = FeedVC.imageCache.object(forKey: (post.profileImageUrl as NSString))
            if let _ = profileImage {
                print("SocialAppDebug: Profile image already in cache")
            }
            cell.configureCell(post: post, postImage: postImage, profileImage: profileImage)
    
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension FeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
}

// MARK: - UIImagePickerControllerDelegate
extension FeedVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdder.image = image
            imageAdder.clipsToBounds = true
            isImageSelected = true
        } else {
            print("SocialAppDebug: Selected image was not added")
        }
        
        // Close image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


