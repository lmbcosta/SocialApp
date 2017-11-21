//
//  PostCell.swift
//  socialApp
//
//  Created by Luis  Costa on 29/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post!
    var userLikesPostReference: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, postImage: UIImage? = nil, profileImage: UIImage? = nil) {
        self.post = post
        numberOfLikesLabel.text = "\(post.likes)"
        postTextView.text = post.caption
        userNameLabel.text = post.username
        let firebaseStorage = Storage.storage()
        
        // onwer's profile image
        if let profileImage = profileImage {
            self.userImage.image = profileImage
        } else {
            // Download profile image
            let ref = firebaseStorage.reference(forURL: post.profileImageUrl)
            ref.getData(maxSize: 1024 * 1024 * 2, completion: { (data, error) in
                if error != nil {
                    print("SocialApp: Unable to download profile Image")
                } else {
                    guard let data = data else {return}
                    print("SocialApp: Profile Image downloaded successfully")
                    if let profileImageDownloaded = UIImage(data: data) {
                        self.userImage.image = profileImageDownloaded
                        // image in cache
                        FeedVC.imageCache.setObject(profileImageDownloaded, forKey: post.profileImageUrl as NSString)
                    }
                }
            })
        }
        
        // If we have the image update otherwise download from the storage
        if let postImage = postImage {
            self.postImage.image = postImage
        } else {
            // Download post image
            let ref = firebaseStorage.reference(forURL: post.imageUrl)
            ref.getData(maxSize: 1024 * 1024 * 2, completion: { (data, error) in
                if error != nil {
                    print("SocialApp: Unable to download post Image")
                } else {
                    guard let data = data else {return}
                    print("SocialApp: Post Image downloaded successfully")
                    if let postImageDownloaded = UIImage(data: data) {
                        self.postImage.image = postImageDownloaded
                        // image in cache
                        FeedVC.imageCache.setObject(postImageDownloaded, forKey: post.imageUrl as NSString)
                    }
                }
            })
        }
        
        // Likes
        userLikesPostReference = DataService.shared.REF_DB_CURRENT_USER.child("likes").child(post.postKey)
        userLikesPostReference.observeSingleEvent(of: .value) { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "like-5")
            } else {
                self.likeImage.image = UIImage(named: "like-1")
            }
        }
    }
    
    @objc func likeTapped() {
        userLikesPostReference.observeSingleEvent(of: .value) { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "like-1")
                self.post.adjustLikes(addLike: true)
                self.userLikesPostReference.setValue("true")
                print("SocialAppDebug: like+")
            } else {
                self.likeImage.image = UIImage(named: "like-5")
                self.post.adjustLikes(addLike: false)
                self.userLikesPostReference.removeValue()
                print("SocialAppDebug: like-")
            }
        }
    }
}











