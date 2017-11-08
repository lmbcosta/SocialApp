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
    
    func configureCell(post: Post, image: UIImage?) {
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
                    }
                }
            })
            
        }
    }
}
