//
//  SettingsVC.swift
//  socialApp
//
//  Created by Luis  Costa on 13/11/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func saveBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
