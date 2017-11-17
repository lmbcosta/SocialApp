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
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        numberOfLikesLabel.text = "\(post.likes)"
        postTextView.text = post.caption
        
        // If we have the image update otherwise download from the storage
        if let image = image {
            self.postImage.image = image
        } else {
            let imageUrl = post.imageUrl
            let ref = Storage.storage().reference(forURL: imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("SocialAppDebug: Unable to download image from Firebase storage")
                } else {
                    print("SocialAppDebug: Image downloaded from Firebase storage")
                    guard let data = data else {return}
                    if let img = UIImage(data: data) {
                        // Save in cache and use as key image url
                        FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        self.postImage.image = img
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










