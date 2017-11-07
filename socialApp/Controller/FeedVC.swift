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

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Observe changes in firebase db posts
        DataService.shared.REF_POSTS.observe(.value) { (snapshot) in
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
}

// MARK: - TableView DataSource and Delegate
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
            cell.configureCell(post: post)
            return cell
        }
        return UITableViewCell()
    }
}

extension FeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
}

