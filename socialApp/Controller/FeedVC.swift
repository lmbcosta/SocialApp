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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        tableView.dataSource = self
        tableView.delegate = self
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
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
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

