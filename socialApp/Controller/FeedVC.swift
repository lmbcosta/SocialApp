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
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    // Image Cache
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

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
                for post in posts {
                    print("SocialAppDebug: \(post)")
                    if let postDictionary = post.value as? Dictionary<String, Any> {
                        let key = post.key
                        let post = Post(postKey: key, postData: postDictionary)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // Sigout Button
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
    
    // Add photo Button
    @IBAction func addImageButton(_ sender: Any) {
        // Present image view picker
        self.present(imagePicker, animated: true, completion: nil)
        // DONT FORGET ENABLE USER INTERACTION!!!
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
            // Check if image is in cache
            let image : UIImage? = FeedVC.imageCache.object(forKey: post.imageUrl as NSString)
            cell.configureCell(post: post, image: image)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension FeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
}

// MARK: - UIImagePickerControllerDelegate
extension FeedVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdder.image = image
            imageAdder.clipsToBounds = true
        } else {
            print("SocialAppDebug: Selected image was not added")
        }
        
        // Close image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


